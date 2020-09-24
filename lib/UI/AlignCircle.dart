import 'package:flutter/material.dart';

class AlignCircle extends StatelessWidget {
  Alignment AlignPosition;
  double width;
  double height;

  AlignCircle(this.AlignPosition, this.width, this.height);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignPosition,
      widthFactor: width,
      heightFactor: height,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(200)),
        color: Color.fromRGBO(255, 255, 255, 0.4),
        child: Container(
          width: 280,
          height: 120,
        ),
      ),
    );
  }
}
