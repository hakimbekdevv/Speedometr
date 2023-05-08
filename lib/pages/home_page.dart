import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:speedometr/pages/avto_speed_page.dart';
import 'package:speedometr/pages/reverse_mode_page.dart';
import 'package:speedometr/pages/settings_page.dart';
import 'package:speedometr/pages/walking_speed_page.dart';
import 'package:speedometr/service/location_service.dart';
import 'package:speedometr/service/prefs_service.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key,}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isDark = true;
  StreamSubscription<LocationData>? locationSubscription;
  LocationData? locationData;
  LocationService myService = LocationService();


  @override
  void initState() {
    getMod();
    initLocation();
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
          backgroundColor: isDark ? Colors.black : Colors.white,
          title: Text("Speedometr",
            style: TextStyle(color: isDark ? Colors.white : Colors.black),),
          actions: [
            IconButton(
              onPressed: () {},
              color: isDark ? Colors.white : Colors.black,
              icon: const Icon(CupertinoIcons.bell_fill),
            ),
            IconButton(
              onPressed: () async {
                await Navigator.push(context, CupertinoPageRoute(
                  builder: (context) => const SettingsPage(),));
                getMod();
              },
              color: isDark ? Colors.white : Colors.black,
              icon: const Icon(Icons.settings,),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: isDark ? Colors.black : Colors.white,
          child: Column(
            children: [
              locationData == null ?
              Column(
                children: [
                  Container(
                      height: 30,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text("Please.Turn on location.",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),),
                                  SizedBox(width: 15,),
                                  const Icon(
                                    Icons.warning, color: Colors.yellow,),
                                ],
                              ),
                              TextButton(
                                onPressed: () => bottomSheet(context),
                                child: Text("more", style: TextStyle(
                                    color: Colors.white),),
                              )
                            ],
                          )
                      )
                  ),
                  const SizedBox(height: 20,)
                ],
              ) :
              const SizedBox.shrink(),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 3,
                      crossAxisSpacing: 10
                  ),
                  children: [
                    buttons("assets/images/auto.png", const AvtoSpeedPage()),
                    // buttons("assets/images/velo.png",const VeloSpeedPage()),
                    buttons("assets/images/walk.png", const WalkingSpeedPage()),
                    buttons("assets/images/mirror.png", const MirrorModePage()),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  void getMod() async {
    await PrefsService.loadMode().then((value) {
      setState(() {
        isDark = value!;
      });
    });
  }

  Widget buttons(String image, pageName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => pageName,));
      },
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isDark ?
            []
                : [
              BoxShadow(color: Colors.grey.withOpacity(.3),
                  blurRadius: 2,
                  offset: const Offset(-3, -3)),
              BoxShadow(color: Colors.grey.withOpacity(.3),
                  blurRadius: 2,
                  offset: const Offset(1, 1))
            ]
        ),
        child: Center(
          child: Image.asset(image),
        ),
      ),
    );
  }

  void bottomSheet(context) {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      backgroundColor: isDark?Colors.grey.shade900:Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Text("Hello dear user. You must enable LOCATION to use my app. Only then you can measure the speed. Otherwise you can't measure",style: TextStyle(color: isDark?Colors.white:Colors.black,fontWeight: FontWeight.bold),),
        );
      },
    );
  }

  void basic() {
    myService.getLocationUpdates().listen((event) {
      setState(() {
        locationData = event;
      });
    });
  }

  Future<void> initLocation() async {
    final futurePermission = Location().requestPermission();
    final isLocationEnabled = await Location().serviceEnabled();

    if (!isLocationEnabled) {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: const Text('Location Service'),
              content: const Text('Please turn on the location service.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
      );
      return;
    }

    await futurePermission;
  }
}