import 'package:flutter/material.dart';

class VeloSpeedPage extends StatefulWidget {
  const VeloSpeedPage({Key? key}) : super(key: key);

  @override
  State<VeloSpeedPage> createState() => _VeloSpeedPageState();
}

class _VeloSpeedPageState extends State<VeloSpeedPage> with TickerProviderStateMixin{

  bool isDark = false;

  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this,duration: Duration(seconds: 2));

    animation = CurvedAnimation(parent: animation!, curve: Curves.easeInSine);

    controller!.repeat();

    super.initState();
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
      body: Center(
        child: RotationTransition(
          turns: animation!,
          child: Text("Salom"),
        ),
      ),
    );
  }


  void veloAnimation() async {
    controller = AnimationController(vsync: this,duration: Duration(seconds: 2));

    animation = CurvedAnimation(parent: animation!, curve: Curves.easeInSine);
    controller!.repeat();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
