import 'message.dart';

class LocationMessage extends Message {
  double latitude;
  double longitude;

  LocationMessage(String uid, DateTime sentTime, Map seen, String address, double latitude, double longitude)
      : super(uid, sentTime, seen, MessageType.location, address) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  @override
  String toString() {
    return this.content;
  }

  LocationMessage.fromSnapshot(String mid, Map data): super.fromSnapshot(mid, data) {
    this.latitude = data['latitude'];
    this.longitude = data['longitude'];
  }
}