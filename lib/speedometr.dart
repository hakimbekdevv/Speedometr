import 'package:location/location.dart';

class Speedometr {
  Location location = Location();
  double speed = 0;

  Future<int> basic() async {
    location.onLocationChanged.listen((LocationData locationData) {
        speed = (locationData.speed!*36)/10;
    });

    return speed.round();
  }

}