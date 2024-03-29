import 'package:flutter/material.dart';

export 'package:shape_of_view_null_safe/shape/arc.dart';
export 'package:shape_of_view_null_safe/shape/bubble.dart';
export 'package:shape_of_view_null_safe/shape/circle.dart';
export 'package:shape_of_view_null_safe/shape/custom.dart';
export 'package:shape_of_view_null_safe/shape/cutcorner.dart';
export 'package:shape_of_view_null_safe/shape/diagonal.dart';
export 'package:shape_of_view_null_safe/shape/polygon.dart';
export 'package:shape_of_view_null_safe/shape/roundrect.dart';
export 'package:shape_of_view_null_safe/shape/star.dart';
export 'package:shape_of_view_null_safe/shape/triangle.dart';

abstract class Shape {
  Path build({Rect? rect, double? scale});
}

abstract mixin class BorderShape {
  void drawBorder(Canvas canvas, Rect rect);
}

class ShapeOfViewBorder extends ShapeBorder {
  final Shape shape;

  ShapeOfViewBorder({required this.shape});

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(0);
  }

  @override
  ShapeBorder scale(double t) => this;

  /*
  @override
  ShapeBorder lerpFrom(ShapeBorder a, double t) {
    if (a is CircleBorder)
      return CircleBorder(side: BorderSide.lerp(a.side, side, t));
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder lerpTo(ShapeBorder b, double t) {
    if (b is CircleBorder)
      return CircleBorder(side: BorderSide.lerp(side, b.side, t));
    return super.lerpTo(b, t);
  }
  */

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return shape.build(rect: rect, scale: 1);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (shape is BorderShape) {
      (shape as BorderShape).drawBorder(canvas, rect);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! ShapeOfViewBorder) return false;
    return shape == other.shape;
  }

  @override
  int get hashCode => shape.hashCode;

  @override
  String toString() {
    return '$runtimeType($shape)';
  }
}

class ShapeOfView extends StatelessWidget {
  final Widget? child;
  final Shape? shape;
  final double elevation;
  final Clip clipBehavior;
  final double? height;
  final double? width;

  ShapeOfView({
    Key? key,
    this.child,
    this.elevation = 4,
    this.shape,
    this.clipBehavior = Clip.antiAlias,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: ShapeOfViewBorder(shape: this.shape!),
      clipBehavior: this.clipBehavior,
      elevation: this.elevation,
      child: Container(
        height: this.height,
        width: this.width,
        child: this.child,
      ),
    );
  }
}
