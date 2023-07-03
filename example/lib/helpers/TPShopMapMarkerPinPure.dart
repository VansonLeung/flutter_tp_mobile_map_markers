import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TPShopMapMarkerPinPure extends StatelessWidget {
  final int index;
  TPShopMapMarkerPinPure({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.0,
      height: 48 * 97 / 73,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[

        CustomPaint(
          size: Size(48, 48),
          painter: BorderPainter(),
        ),

        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Text(
            "${index + 1}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),),

        ],
      ),
    );
  }
}


class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    paintMarker(canvas, size, 0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;



  void paintMarker(Canvas canvas, Size size, int index) {

    final path1 = Path();
    path1.moveTo(0, size.height / 2);
    path1.lineTo(size.width / 2 + size.width / 3.5, size.height / 2);
    path1.lineTo(size.width / 2, size.height / 2.5 + size.height / 2);
    path1.lineTo(size.width / 2 - size.width / 3.5, size.height / 2);
    path1.close();

    final path2 = Path();
    path2.addOval(Rect.fromLTRB(
        (size.width / 2) + (-size.width / 3) ,
        (size.height / 3) - (-size.width / 3) ,
        (size.width / 2) + (size.width / 3) ,
        (size.height / 3) - (size.width / 3) )
    );
    path2.close();

    final path3 = Path();
    path3.addOval(Rect.fromLTRB(
        (size.width / 2) + (-size.width / 4.0) ,
        (size.height / 3) - (-size.width / 4.0) ,
        (size.width / 2) + (size.width / 4.0) ,
        (size.height / 3) - (size.width / 4.0) )
    );
    path3.close();





    final path = Path.combine(PathOperation.union, path1, path2);


    Paint shadowPaint = Paint()
      ..color = Color(0xff01C4DE)
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 3);
    Paint bgPaint = Paint()
      ..color = Color(0xff000000);

    Paint shadowPaint2 = Paint()
      ..color = Color(0xFFE02C96)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    Paint shadowPaint3 = Paint()
      ..color = Color(0xAA64108B);

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Color(0xffffffff);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, bgPaint);
    canvas.drawPath(path3, shadowPaint2);
    canvas.drawPath(path3, shadowPaint2);
    canvas.drawPath(path3, shadowPaint2);
    canvas.drawPath(path3, shadowPaint2);
    canvas.drawPath(path3, shadowPaint3);
    canvas.drawPath(path, paint);
    canvas.drawPath(path3, paint);



    final textStyle = TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 32,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(
      text: "${index + 1}",
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 4;
    final offset = Offset(xCenter, yCenter);

    textPainter.paint(canvas, offset);
  }
}








class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path1 = Path();
    path1.moveTo(0, size.height / 2);
    path1.lineTo(size.width / 2 + size.width / 3.5, size.height / 2);
    path1.lineTo(size.width / 2, size.height / 2.5 + size.height / 2);
    path1.lineTo(size.width / 2 - size.width / 3.5, size.height / 2);
    path1.close();

    final path2 = Path();
    path2.addOval(Rect.fromLTRB(
        (size.width / 2) + (-size.width / 3) ,
        (size.height / 3) - (-size.width / 3) ,
        (size.width / 2) + (size.width / 3) ,
        (size.height / 3) - (size.width / 3) )
    );
    path2.close();

    final path = Path.combine(PathOperation.union, path1, path2);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}






// Future<Uint8List?> getBytesFromCanvas(int customNum, int width, int height) async  {
//   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//   final Canvas canvas = Canvas(pictureRecorder);
//   final Paint paint = Paint()..color = Colors.blue;
//   final Radius radius = Radius.circular(width/2);
//   canvas.drawImage(ui.Image, offset, paint)
//   canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromLTWH(0.0, 0.0, width.toDouble(),  height.toDouble()),
//         topLeft: radius,
//         topRight: radius,
//         bottomLeft: radius,
//         bottomRight: radius,
//       ),
//       paint);
//
//   TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
//   painter.text = TextSpan(
//     text: customNum.toString(), // your custom number here
//     style: TextStyle(fontSize: 65.0, color: Colors.white),
//   );
//
//   painter.layout();
//   painter.paint(
//       canvas,
//       Offset((width * 0.5) - painter.width * 0.5,
//           (height * .5) - painter.height * 0.5));
//   final img = await pictureRecorder.endRecording().toImage(width, height);
//   final data = await img.toByteData(format: ui.ImageByteFormat.png);
//   return data?.buffer.asUint8List();
// }