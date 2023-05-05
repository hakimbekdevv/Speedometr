import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:location/location.dart';
import 'package:speedometr/pages/avto_speed_page.dart';
import 'package:speedometr/pages/settings_page.dart';
import 'package:speedometr/pages/velo_speed_page.dart';
import 'package:speedometr/pages/walking_speed_page.dart';
import 'package:speedometr/service/prefs_service.dart';



class HomePage extends StatefulWidget {
  final bool? primaryColor;
  const HomePage({Key? key, this.primaryColor}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Location location = Location();


  bool isDark = true;

  @override
  void initState() {
    print(location.serviceEnabled());
    getMod();
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
        title: Text("Speedometr",style: TextStyle(color: isDark?Colors.white:Colors.black),),
        actions: [
          IconButton(
            onPressed: () {},
            color: isDark?Colors.white:Colors.black,
            icon: const Icon(CupertinoIcons.bell_fill),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(context, CupertinoPageRoute(builder: (context) => const SettingsPage(),));
              getMod();
            },
            color: isDark?Colors.white:Colors.black,
            icon: Icon(Icons.settings,),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: isDark?Colors.black.withOpacity(.94):Colors.white,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3/3,
            crossAxisSpacing: 10
          ),
          children: [
            buttons("assets/images/auto.png",const AvtoSpeedPage()),
            buttons("assets/images/velo.png",const VeloSpeedPage()),
            buttons("assets/images/walk.png",const WalkingSpeedPage()),
          ],
        ),
      )
    );
  }

  Widget buttons(String image,pageName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => pageName,));
      },
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: isDark?Colors.grey.shade900:Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isDark?
          []
          :[
            BoxShadow(color: Colors.grey.withOpacity(.3),blurRadius: 2,offset: Offset(-3,-3)),
            BoxShadow(color: Colors.grey.withOpacity(.3),blurRadius: 2,offset: Offset(1,1))
          ]
        ),
        child: Center(
          child: Image.asset(image),
        ),
      ),
    );
  }
}
