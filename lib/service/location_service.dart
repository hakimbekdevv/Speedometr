import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Stream<LocationData> getLocationUpdates() {
    return _location.onLocationChanged;
  }



}