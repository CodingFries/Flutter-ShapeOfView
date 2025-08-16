import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

/// A shape that creates rectangles with cut (beveled) corners instead of rounded corners.
///
/// [CutCornerShape] generates geometric paths for rectangular shapes where the corners
/// are "cut off" at an angle, creating a beveled appearance rather than curved corners.
/// This creates a modern, geometric look that's different from traditional rounded rectangles.
///
/// The corner cuts are controlled by a [BorderRadius] parameter, where the radius values
/// determine how much of each corner is cut off. Unlike rounded corners, these cuts create
/// straight diagonal lines at each corner.
///
/// Example usage:
/// ```dart
/// // Create a rectangle with all corners cut equally
/// CutCornerShape(
///   borderRadius: BorderRadius.all(Radius.circular(12.0)),
/// )
///
/// // Create a rectangle with asymmetric corner cuts
/// CutCornerShape(
///   borderRadius: BorderRadius.only(
///     topLeft: Radius.circular(20.0),
///     bottomRight: Radius.circular(15.0),
///   ),
/// )
/// ```
class CutCornerShape extends Shape {
  /// The border radius that defines how much of each corner should be cut.
  ///
  /// Unlike rounded rectangles where this creates curves, here it determines
  /// the size of the diagonal cuts at each corner. Larger radius values create
  /// larger cut sections.
  ///
  /// Can be null, which would result in sharp 90-degree corners (no cuts).
  final BorderRadius? borderRadius;

  /// Creates a new [CutCornerShape] with optional corner cuts.
  ///
  /// [borderRadius] - Defines the size of corner cuts. If null, corners will be sharp.
  CutCornerShape({this.borderRadius});

  /// Builds the geometric path for this cut corner shape.
  ///
  /// [rect] - The bounding rectangle that defines the area within which the shape should be drawn.
  /// [scale] - Optional scaling factor (currently not used in this implementation).
  ///
  /// Returns a [Path] object representing the cut corner shape's outline.
  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(rect: rect!);
  }

  /// Generates the actual path for the cut corner shape.
  ///
  /// Creates a rectangular path with diagonal cuts at the corners instead of curves.
  /// The path traces around the perimeter, creating diagonal lines at each corner
  /// where the cuts are made.
  ///
  /// [rect] - The bounding rectangle that defines the drawing area.
  ///
  /// Returns a [Path] object with the cut corner shape's geometric outline.
  /// Throws an exception if [borderRadius] is null.
  Path generatePath({required Rect rect}) {
    final topLeftDiameter = max(borderRadius!.topLeft.x, 0);
    final topRightDiameter = max(borderRadius!.topRight.x, 0);
    final bottomLeftDiameter = max(borderRadius!.bottomLeft.x, 0);
    final bottomRightDiameter = max(borderRadius!.bottomRight.x, 0);

    return Path()
      ..moveTo(rect.left + topLeftDiameter, rect.top)
      ..lineTo(rect.right - topRightDiameter, rect.top)
      ..lineTo(rect.right, rect.top + topRightDiameter)
      ..lineTo(rect.right, rect.bottom - bottomRightDiameter)
      ..lineTo(rect.right - bottomRightDiameter, rect.bottom)
      ..lineTo(rect.left + bottomLeftDiameter, rect.bottom)
      ..lineTo(rect.left, rect.bottom - bottomLeftDiameter)
      ..lineTo(rect.left, rect.top + topLeftDiameter)
      ..lineTo(rect.left + topLeftDiameter, rect.top)
      ..close();
  }
}
