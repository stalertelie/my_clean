import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/services/localization.dart';

class HomeHeader extends StatefulWidget {
  final User? login;
  final VoidCallback onProfiTaped;

  const HomeHeader({Key? key, this.login, required this.onProfiTaped})
      : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    animation = Tween<double>(begin: 0, end: 140).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        height: 300,
        width: double.maxFinite,
        color: const Color(colorPrimary),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.current.welcome +
                        ' ' +
                        (widget.login != null
                            ? widget.login!.prenoms.toString()
                            : ''),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => widget.onProfiTaped(),
                    child: SvgPicture.asset(
                      'images/icons/avatar.svg',
                      width: 25,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Text(
                  AppLocalizations.current.whatService,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      clipper: BottomWaveClipper(distance: animation.value),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  final distance;

  BottomWaveClipper({this.distance});

  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height * 1.2 - distance);

    // Draw a straight line from current point to the top right corner.
    path.quadraticBezierTo(size.width / 2, size.height * 1.2, size.width,
        size.height * 1.2 - distance);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class BottomShaper extends ShapeBorder {
  final distance;

  BottomShaper({this.distance});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    var path = Path();

    path.lineTo(0.0, rect.height - distance);

    // Draw a straight line from current point to the top right corner.
    path.quadraticBezierTo(
        rect.width / 2, rect.height, rect.width, rect.height - distance);

    path.lineTo(rect.width, 0.0);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
