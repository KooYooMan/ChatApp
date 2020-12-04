import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/services/firebase.dart';
import 'package:firebase_database/firebase_database.dart';

class CallService{
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();

  Future<void> setCameraStatus(String channelName, int uid, bool isOn) async {
    var ref = _firebaseService.getDatabaseReference(["calls", channelName, uid.toString()]);
    await _firebaseService.updateDocument(ref, Map<String, dynamic>.from({
      "isCameraOn": isOn
    }));
  }

  Stream<Event> getCallStatus(String channelName){
    return _firebaseService.getDatabaseReference(["calls", channelName]).onValue;
  }
}