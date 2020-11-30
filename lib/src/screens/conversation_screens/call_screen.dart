import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


const APP_ID = '0179d09fb6db495f913653715dc0b7f2';

class CallScreen extends StatefulWidget {
  final String channelName;
  final Map<Permission, PermissionStatus> statuses;
  CallScreen({this.channelName, this.statuses});
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

  final _users = <int>[];
  final _infoStrings = <String>[];
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
        setState(() {
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



  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
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
      //TODO: send event turn off camera.
    }
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

    final views = _getRenderViews();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _buildViews(),
            _buildToolbar(),
          ],
        ),
      ),
    );
  }
}
