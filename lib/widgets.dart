
import 'package:flutter/widgets.dart';

class Wave extends StatelessWidget {
  final WaveClipper clipper;
  final double opacity;
  final double height;

  const Wave(this.clipper, {this.opacity = 1, this.height = 175});

  @override
  Widget build(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    double scale = 1;
    if (scaleFactor > 1) scale = 1 + 0.3 * (scaleFactor - 1);

    return ClipPath(
        clipper: clipper,
        child: Opacity(
          opacity: opacity,
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff3A26B3), Color(0xff6C18A4)])),
              height: height * scale),
        ));
  }
}

class WaveClipper extends CustomClipper<Path> {
  final firstLineHeightRatio;
  final firstControlPointRatios;
  final firstEndPointRatios;
  final secondControlPointRatios;
  final secondEndPointRatios;
  final bool rotate;

  const WaveClipper(
      this.firstLineHeightRatio,
      this.firstControlPointRatios,
      this.firstEndPointRatios,
      this.secondControlPointRatios,
      this.secondEndPointRatios,
      {this.rotate = false});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height * firstLineHeightRatio);

    var firstControlPoint = Offset(size.width * firstControlPointRatios[0],
        size.height * firstControlPointRatios[1]);
    var firstEndPoint = Offset(size.width * firstEndPointRatios[0],
        size.height * firstEndPointRatios[1]);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * secondControlPointRatios[0],
        size.height * secondControlPointRatios[1]);
    var secondEndPoint = Offset(size.width * secondEndPointRatios[0],
        size.height * secondEndPointRatios[1]);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    if (!rotate) {
      path.lineTo(size.width, 0);
    } else {
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
    }
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}
