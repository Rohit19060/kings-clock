import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  runApp(King());
}

class King extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: Scaffold(
          body: DigitalClock(),
        ));
  }
}

class DigitalClock extends StatefulWidget {
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (V) {
      if (mounted) {
        setState(() {
          _hour0();
          _hour1();
          _minute0();
          _minute1();
          _date();
        });
      }
    });
    super.initState();
  }

  _hour0() {
    var hour = DateTime.now().hour.toInt() / 10;
    return "${hour.toInt()}";
  }

  _hour1() {
    var hour = DateTime.now().hour.toInt() % 10;
    return "$hour";
  }

  _minute0() {
    var min = DateTime.now().minute.toInt() / 10;
    return "${min.toInt()}";
  }

  _minute1() {
    var min = DateTime.now().minute.toInt() % 10;
    return "$min";
  }

  _date() {
    var day = DateTime.now().day.toInt();
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    var month = monthNames[DateTime.now().month.toInt() - 1];
    var year = DateTime.now().year.toInt();
    return "$day $month, $year";
  }

  Widget handle(d, w, h) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      width: w,
      height: h,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20.0,
            )
          ],
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.white.withOpacity(0.6),
                Colors.white,
                Colors.white.withOpacity(0.6),
                Colors.black.withOpacity(0.2),
              ])),
      child: FittedBox(
        child: Center(
          child: Text(d,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(),
            Container(
              child: Text("Digital Clock",
                  style:
                      TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _date(),
                  style: TextStyle(fontSize: 24),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                handle(_hour0(), 75.0, 165.0),
                handle(_hour1(), 75.0, 165.0),
                handle(" : ", 25.0, 40.0),
                handle(_minute0(), 75.0, 165.0),
                handle(_minute1(), 75.0, 165.0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Anime()],
            ),
          ],
        ));
  }
}

class Anime extends StatefulWidget {
  @override
  _AnimeState createState() => _AnimeState();
}

class _AnimeState extends State<Anime> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (V) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: AnimatedLogo(animation: animation),
      ),
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation animation, text})
      : super(key: key, listenable: animation);
  _sec() {
    var sec1 = DateTime.now().second.toInt() / 10;
    var sec0 = DateTime.now().second.toInt() % 10;
    return "${sec1.toInt()}$sec0";
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Transform.scale(
      scale: animation.value,
      child: Text(
        _sec(),
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
