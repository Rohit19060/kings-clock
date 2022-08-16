import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(const DigitalClock());
}

class DigitalClock extends StatefulWidget {
  const DigitalClock({super.key});

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
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

  String _hour0() => '${DateTime.now().hour ~/ 10}';

  String _hour1() => '${DateTime.now().hour % 10}';

  String _minute0() => '${DateTime.now().minute ~/ 10}';

  String _minute1() => '${DateTime.now().minute % 10}';

  String _date() {
    final now = DateTime.now();
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${now.day} ${monthNames[now.month - 1]}, ${now.year}';
  }

  Widget handle(String d) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        padding: const EdgeInsets.all(5),
        width: 65.0,
        height: 155.0,
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20.0)],
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
            child: Text(d,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
        darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                'Digital Clock',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}

class Anime extends StatefulWidget {
  const Anime({super.key});

  @override
  State<Anime> createState() => _AnimeState();
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
  Widget build(BuildContext context) =>
      Center(child: AnimatedLogo(animation: animation));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimationController>(
        'animationController', animationController));
    properties
        .add(DiagnosticsProperty<Animation<double>?>('animation', animation));
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({super.key, Animation<double>? animation})
      : super(listenable: animation!);
  String _sec() =>
      '${DateTime.now().second ~/ 10}${DateTime.now().second % 10}';

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
