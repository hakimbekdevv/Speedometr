import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:location/location.dart';

import '../service/prefs_service.dart';

class AvtoSpeedPage extends StatefulWidget {
  const AvtoSpeedPage({Key? key}) : super(key: key);

  @override
  State<AvtoSpeedPage> createState() => _AvtoSpeedPageState();
}

class _AvtoSpeedPageState extends State<AvtoSpeedPage> {

  GlobalKey<KdGaugeViewState> key = GlobalKey<KdGaugeViewState>();
  Location location = Location();
  double speed = 0;
  bool isDark = true;

  @override
  void initState() {
    getMod();
    basic();
    super.initState();
  }

  void getMod() async {
    await PrefsService.loadMode().then((value) {
      setState(() {
        isDark = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark?Colors.black.withOpacity(.94):Colors.white,
        iconTheme: IconThemeData(
            color: isDark?Colors.white:Colors.black
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: KdGaugeView(
            key: key,
            minSpeed: 0,
            maxSpeed: 260,
            speed: speed,
            animate: true,
            speedTextStyle: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 90),
          ),
        ),
        color: isDark?Colors.black.withOpacity(.94):Colors.white,
      ),
    );
  }

  Future<int> basic() async {
    location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        speed = (locationData.speed!*36)/10;
      });
    });



    return speed.round();
  }
}
