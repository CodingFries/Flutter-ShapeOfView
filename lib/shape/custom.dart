import 'package:flutter/material.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

typedef ShapeBuilder = Path Function(Rect? rect);

class CustomShape extends Shape {
  final ShapeBuilder? builder;

  CustomShape({this.builder});

  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(rect: rect);
  }

  Path generatePath({Rect? rect}) {
    return this.builder!(rect);
  }
}
