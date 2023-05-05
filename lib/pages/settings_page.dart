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

  @override
  void initState() {
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

  void setMod() async {
    await PrefsService.storeMode(isDark);
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
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: isDark?Colors.black.withOpacity(.94):Colors.white,
        child: Column(
          children: [
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
            Divider(color: Colors.grey,)
          ],
        ),
      ),
    );
  }

}
