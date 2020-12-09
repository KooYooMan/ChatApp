import 'message.dart';

class LocationMessage extends Message {
  double latitude;
  double longitude;

  LocationMessage(String uid, DateTime sentTime, Map seen, String documentName, String address, double latitude, double longitude)
      : super(uid, sentTime, seen, MessageType.document, address) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  @override
  String toString() {
    return this.content;
  }
}