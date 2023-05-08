import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../service/location_service.dart';
import '../service/prefs_service.dart';

class MirrorModePage extends StatefulWidget {
  const MirrorModePage({Key? key}) : super(key: key);

  @override
  State<MirrorModePage> createState() => _MirrorModePageState();
}

class _MirrorModePageState extends State<MirrorModePage> {

  LocationService myService = LocationService();
  StreamSubscription<LocationData>? locationSubscription;
  LocationData? locationData;
  bool isDark = true;
  double speed = 0;

  void initState() {
    getMod();
    basic();
    super.initState();
  }

  @override
  void dispose() {
    locationSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark?Colors.black:Colors.white,
        iconTheme: IconThemeData(
          color: isDark?Colors.white:Colors.black
        ),
      ),
      body: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationX(pi),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: isDark?Colors.black:Colors.white,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red,width: 15),
                borderRadius: BorderRadius.circular(300)
              ),
              child: Center(
                child: Text(speed.toInt().toString(),style: TextStyle(color: isDark?Colors.white:Colors.black,fontSize: 140),),
              )
            ),
          ),
        ),
      ),
    );
  }

  void getMod() async {
    await PrefsService.loadMode().then((value) {
      setState(() {
        isDark = value!;
      });
    });
  }

  void basic() {
    locationSubscription = myService.getLocationUpdates().listen((event) {
      locationData = event;
      setState(() {
        speed = (locationData!.speed!*36)/10;
      });
    });
  }

}
