import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  runApp(
    const DigitalClock(),
  );
}

class DigitalClock extends StatefulWidget {
  const DigitalClock({Key? key}) : super(key: key);

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (V) {
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

  Widget handle(d) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      padding: const EdgeInsets.all(5),
      width: 65.0,
      height: 155.0,
      decoration: BoxDecoration(
        boxShadow: const [
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
            ]),
      ),
      child: FittedBox(
        child: Center(
          child: Text(
            d,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _date(),
              style: const TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                handle(_hour0()),
                handle(_hour1()),
                const Anime(),
                handle(_minute0()),
                handle(_minute1()),
              ],
            ),
            const Text(
              "Digital Clock",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class Anime extends StatefulWidget {
  const Anime({Key? key}) : super(key: key);

  @override
  _AnimeState createState() => _AnimeState();
}

class _AnimeState extends State<Anime> with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    Timer.periodic(const Duration(seconds: 1), (V) {
      if (mounted) {
        setState(() {});
      }
    });
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animation!.addStatusListener((status) {
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
      child: AnimatedLogo(animation: animation),
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key? key, Animation? animation})
      : super(key: key, listenable: animation!);
  _sec() {
    var sec1 = DateTime.now().second.toInt() / 10;
    var sec0 = DateTime.now().second.toInt() % 10;
    return "${sec1.toInt()}$sec0";
  }

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.scale(
      scale: animation.value,
      child: Text(
        _sec(),
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
