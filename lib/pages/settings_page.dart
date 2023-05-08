import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speedometr/service/prefs_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = true;
  bool isColor = true;
  String key1 = "uzb";
  String key2 = "rus";
  String key3 = "usa";
  String currentLanguage = "uzb";


  @override
  void initState() {
    getMod();
    getLanguage();
    getColor();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark?Colors.black.withOpacity(.94):Colors.white,
        title: Text("Settings",style: TextStyle(color: isDark?Colors.white:Colors.black),),
        iconTheme: IconThemeData(
          color: isDark?Colors.white:Colors.black
        ),
        actions: [
          Image(
            width: 30,
            image: AssetImage("assets/images/$currentLanguage.png"),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: isDark?Colors.black.withOpacity(.94):Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    await setLanguage(key1);
                    getLanguage();
                  },
                  child: Image.asset("assets/images/uzb.png",height: 50,),
                ),
                InkWell(
                  onTap: () async {
                    await setLanguage(key2);
                    getLanguage();
                  },
                  child: Image.asset("assets/images/rus.png",height: 50,),
                ),
                InkWell(
                  onTap: () async {
                    await setLanguage(key3);
                    getLanguage();
                  },
                  child: Image.asset("assets/images/usa.png",height: 50,),
                ),
              ],
            ),
            Container(
              child: Row(
                children: [
                  Switch(
                    value: isDark,
                    onChanged: (value) {
                      setState(() {
                        isDark = value;
                      });
                      setMod();
                    },
                  ),
                  SizedBox(width: 20,),
                  Text("Dark Mode",style: TextStyle(color: isDark?Colors.white:Colors.black),),
                ],
              ),
            ),
            Divider(color: Colors.grey,),
            Container(
              child: Row(
                children: [
                  Switch(
                    value: isColor,
                    onChanged: (value) {
                      setState(() {
                        isColor = value;
                      });
                      setColor();
                    },
                  ),
                  SizedBox(width: 20,),
                  Text("Discoloration of car speedometer",style: TextStyle(color: isDark?Colors.white:Colors.black),),
                ],
              ),
            ),
          ],
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

  void setMod() async {
    await PrefsService.storeMode(isDark);
  }

  void getColor() async {
    await PrefsService.loadColor().then((value) {
      print(value);
      setState(() {
        isColor = value!;
      });
    });
  }

  void setColor() async {
    await PrefsService.storeColor(isColor);
  }

  void getLanguage() async {
    await PrefsService.loadLanguage().then((value) {
      setState(() {
        currentLanguage = value!;
      });
    });
  }

  Future<void> setLanguage(String key) async {
    await PrefsService.storeLanguage(key);
  }

}
