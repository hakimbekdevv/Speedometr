import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../service/location_service.dart';
import '../service/prefs_service.dart';

class AvtoSpeedPage extends StatefulWidget {
  const AvtoSpeedPage({Key? key}) : super(key: key);

  @override
  State<AvtoSpeedPage> createState() => _AvtoSpeedPageState();
}

class _AvtoSpeedPageState extends State<AvtoSpeedPage> {

  LocationData? locationData;
  double speed = 0;
  LocationService myService = LocationService();
  StreamSubscription<LocationData>? locationSubscription;
  bool isDark = true;
  bool isColor = true;
  @override
  void initState() {
    getMod();
    getColor();
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
        backgroundColor: isDark ? Colors.black: Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: isDark ? Colors.black: Colors.white,
        child: Center(
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 200,
                axisLineStyle: AxisLineStyle(thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03),
                majorTickStyle:MajorTickStyle(length: 6, thickness: 4, color: isDark?Colors.white:Colors.black),
                minorTickStyle:MinorTickStyle(length: 3, thickness: 3, color: isDark?Colors.white:Colors.black),
                axisLabelStyle: GaugeTextStyle(color: isDark?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontSize: 14),
                pointers: <GaugePointer>[
                NeedlePointer(
                  value: speed,
                  needleLength: 0.95,
                  enableAnimation: true,
                  animationType: AnimationType.ease,
                  needleStartWidth: 1.5,
                  needleEndWidth: 6,
                  needleColor: Colors.red,
                  knobStyle: KnobStyle(knobRadius: 0.09)
                ),
              ],
                ranges: isColor?[
                  GaugeRange(
                  startValue: 0,
                  endValue: 70,
                  color: Colors.green,
                ),
                  GaugeRange(
                  startValue: 70,
                  endValue: 120,
                  color: Colors.orangeAccent,
                ),
                  GaugeRange(
                  startValue: 120,
                  endValue: 200,
                  color: Colors.red,
                ),
                ]:[],
                annotations: [
                GaugeAnnotation(
                  widget: Text(speed.round().toString(),style: TextStyle(color: isDark?Colors.white:Colors.black,fontSize: 44),),
                  positionFactor: .5,
                  angle: 90,
                )
              ],
            )
          ]
          ),
        )
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

  void getColor() async {
    await PrefsService.loadColor().then((value) {
      setState(() {
        isColor = value!;
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
