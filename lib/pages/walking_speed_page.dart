import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:speedometr/service/prefs_service.dart';

class WalkingSpeedPage extends StatefulWidget {
  const WalkingSpeedPage({Key? key}) : super(key: key);

  @override
  State<WalkingSpeedPage> createState() => _WalkingSpeedPageState();
}

class _WalkingSpeedPageState extends State<WalkingSpeedPage> {

  bool isDark = true;
  Location location = Location();
  double speed = 0;

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
        padding: EdgeInsets.only(top: 20),
        color: isDark?Colors.black.withOpacity(.94):Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: isDark?Colors.black.withOpacity(.94):Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isDark?
                [
                  BoxShadow(color: Colors.grey.shade800,blurRadius: 2,offset: Offset(-3,-3)),
                  BoxShadow(color: Colors.grey.shade800,blurRadius: 2,offset: Offset(1,1))
                ]:[
                  BoxShadow(color: Colors.grey.withOpacity(.3),blurRadius: 2,offset: Offset(-3,-3)),
                  BoxShadow(color: Colors.grey.withOpacity(.3),blurRadius: 2,offset: Offset(1,1))
                ]
              ),
              child: Image.asset("assets/images/walking.png"),
            ),
            SizedBox(height: 30,),
            Text(speed.toInt().toString(),style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 90),),
            Text("K/H",style: TextStyle(color: isDark?Colors.white:Colors.blue,fontSize: 20),)
          ],
        ),
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
