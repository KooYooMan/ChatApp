import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/call_service.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';


const APP_ID = '0179d09fb6db495f913653715dc0b7f2';

class CallScreen extends StatefulWidget {
  final String channelName;
  CallScreen({this.channelName});
  @override
  _CallScreenState createState() => _CallScreenState();
}

enum VideoStatus {
  off,
  front,
  back,
  denied
}

class _CallScreenState extends State<CallScreen> {
  CallService _callService = GetIt.I.get<CallService>();
  AuthService _authService = GetIt.I.get<AuthService>();
  final _users = <int>[];
  final _infoStrings = <String>[];
  String currentUserName;
  int currentUID;
  bool _muted = false;
  VideoStatus _videoStatus;
  RtcEngine _engine;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }
  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(null, widget.channelName, null, 0);
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (cameraStatus.isPermanentlyDenied || cameraStatus.isDenied) {
      _videoStatus = VideoStatus.denied;
    } else {
      _videoStatus = VideoStatus.front;
    }
    print("video status = " + _videoStatus.toString());
  }
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      if (mounted) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      }
    }, joinChannelSuccess: (channel, uid, elapsed) {
      if (mounted) {
        setState(() async {
          currentUID = uid;
          await _callService.setCameraStatus(widget.channelName, uid, true);
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      }
    }, leaveChannel: (stats) {
      if (mounted) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      }
    }, userJoined: (uid, elapsed) {
      if (mounted) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
        });
      }
    }, userOffline: (uid, elapsed) {
      if (mounted) {
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      }
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      if (mounted) {
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
        });
      }
    }));
  }



  List<Widget> _getRenderViews(Map <int, bool> cameraStatus) {
    final List<Widget> list = [];
    print("CurrentID = ${currentUID}");
    if (cameraStatus[currentUID] != null && cameraStatus[currentUID])
      list.add(RtcLocalView.SurfaceView());
    else
      list.add(_buildReplacementWidget(
          NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
          'Off Camera'
      ));
    // list.add();
    //fake Replacement widget.
    _users.forEach((int uid) {
      if (cameraStatus[uid] != null && cameraStatus[uid])
        list.add(RtcRemoteView.SurfaceView(uid: uid));
      else
        list.add(_buildReplacementWidget(
            NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
            'Off Camera'
        ));
    });
    return list;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    if (mounted) {
      setState(() {
        _muted = !_muted;
      });
    }
    _engine.muteLocalAudioStream(_muted);
    
  }

  void _onSwitchCameraStatus() async {
    print("VideoStatus = " + _videoStatus.toString());
    if (_videoStatus == VideoStatus.off) {
      if (mounted) {
        setState(() {
          _videoStatus = VideoStatus.front;
        });
      }
      await _engine.muteLocalVideoStream(false);
      //TODO: send event turn on camera
      await _callService.setCameraStatus(widget.channelName, currentUID, true);
    } else if (_videoStatus == VideoStatus.front) {
      if (mounted) {
        setState(() {
          _videoStatus = VideoStatus.back;
        });
      }
      _engine.switchCamera();
    } else if (_videoStatus == VideoStatus.back) {
      if (mounted) {
        setState(() {
          _videoStatus = VideoStatus.off;
        });
      }
      await _engine.muteLocalVideoStream(true);
      _engine.switchCamera();
      print(currentUID);
      await _callService.setCameraStatus(widget.channelName, currentUID, false);
    }
  }
  // _buildReplacementWidget return widget replacing remote view when users turn off their camera.
  Widget _buildReplacementWidget(ImageProvider avatarProvider, String name) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2.0,
          color: Colors.cyan,
        )
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2.0,
                  color: Colors.cyan,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: avatarProvider,
                radius: MediaQuery.of(context).size.width / 10,
              ),
            ),
            Text(name, style: TextStyle(fontSize: 15.0, color: Colors.black),),
          ],
        ),
      ),
    );
  }
  Widget _buildToolbar() {
    IconData cameraIconData;
    if (_videoStatus == VideoStatus.off) {
      cameraIconData = Icons.videocam_rounded;
    } else if (_videoStatus == VideoStatus.front) {
      cameraIconData = Icons.flip_camera_android_sharp;
    } else if (_videoStatus == VideoStatus.back) {
      cameraIconData = Icons.videocam_off;
    }
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              _muted ? Icons.mic : Icons.mic_off,
              color: _muted? Colors.white : Colors.black,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: _muted? Colors.black : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCameraStatus,
            child: Icon(
              cameraIconData,
              color: (_videoStatus == VideoStatus.off) ? Colors.white : Colors.black,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: (_videoStatus == VideoStatus.off) ? Colors.black : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),

        ],
      ),
    );
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }
  /// Video layout wrapper
  Widget _buildViews() {
    Map <int, bool> cameraStatus = new Map<int, bool>();
    return StreamBuilder(
      stream: _callService.getCallStatus(widget.channelName),
      builder: (context, snapshot){
        print("CAM = $cameraStatus");

        if (snapshot.hasData){
          Map data = snapshot.data.snapshot.value;
          if (data != null)
            data.forEach((key, value) {
              cameraStatus[int.parse(key)] = value['isCameraOn'];
            });
          // print("CAM after = $cameraStatus");
        }
        final views = _getRenderViews(cameraStatus);

        switch (views.length) {
          case 1:
            return Container(
              child: Column(
                children: <Widget>[_videoView(views[0])],
              )
            );
          case 2:
            return Container(
              child: Column(
                children: <Widget>[
                  _expandedVideoRow([views[0]]),
                  _expandedVideoRow([views[1]])
                ],
              )
            );
          case 3:
            return Container(
              child: Column(
                children: <Widget>[
                  _expandedVideoRow(views.sublist(0, 2)),
                  _expandedVideoRow(views.sublist(2, 3))
                ],
              )
            );
          case 4:
            return Container(
              child: Column(
                children: <Widget>[
                  _expandedVideoRow(views.sublist(0, 2)),
                  _expandedVideoRow(views.sublist(2, 4))
                ],
              )
            );
          default:
        }
        return Container();
      }
    );
  }
  bool _showToolBar = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: _buildViews(),
              onTap: () {
                setState(() {
                  _showToolBar = !_showToolBar;
                });
              }
            ),
            (_showToolBar) ? _buildToolbar() : Container(),
          ],
        ),
      ),
    );
  }
}
