import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LocationData _locationData;
  late StreamSubscription<LocationData> _locationSubscription;
  late bool _isConnected;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _initLocation();
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected =    connectivityResult != ConnectivityResult.none ? true : false;
    });
  }

  Future<void> _initLocation() async {
    final futurePermission = Location().requestPermission();
    final isLocationEnabled = await Location().serviceEnabled();

    if (!isLocationEnabled) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Location Service'),
          content: Text('Please turn on the location service.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    await futurePermission;

    if (_isConnected) {
      _locationSubscription = Location().onLocationChanged.listen((event) {
        setState(() {
          _locationData = event;
        });
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Internet Connection'),
          content: Text('Please connect to the internet and try again.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _isConnected && _locationData != null
              ? [
            Text(
                'Latitude: ${_locationData.latitude}\nLongitude: ${_locationData.longitude}'),
            SizedBox(height: 16.0),
            Text('Speed: ${_locationData.speed}'),
          ]
              : _isConnected == false
              ? [Text('Please connect to the internet and try again.')]
              : [CircularProgressIndicator()],
        ),
      ),
    );
  }
}