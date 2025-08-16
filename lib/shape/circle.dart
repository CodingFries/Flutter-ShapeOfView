import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

/// A shape that creates perfect circles with optional border styling.
///
/// [CircleShape] generates geometric paths for circular shapes that are inscribed
/// within the bounding rectangle. The circle's radius is determined by the smaller
/// dimension of the rectangle to ensure the circle fits completely within the bounds.
///
/// This shape supports custom border styling through the [BorderShape] mixin,
/// allowing for outlined circles with configurable border width and color.
///
/// Example usage:
/// ```dart
/// // Create a simple circle
/// CircleShape()
///
/// // Create a circle with a colored border
/// CircleShape(
///   borderWidth: 2.0,
///   borderColor: Colors.blue,
/// )
/// ```
class CircleShape extends Shape with BorderShape {
  /// The width of the border stroke around the circle.
  ///
  /// A value of 0 (default) means no border will be drawn.
  /// Must be non-negative.
  final double borderWidth;

  /// The color of the border stroke.
  ///
  /// Only visible when [borderWidth] is greater than 0.
  /// Defaults to white.
  final Color borderColor;

  /// Paint object used for drawing the border.
  ///
  /// Configured with anti-aliasing enabled and stroke style for smooth border rendering.
  final Paint borderPaint = Paint();

  /// Creates a new [CircleShape] with optional border styling.
  ///
  /// [borderWidth] - Width of the border stroke. Defaults to 0 (no border).
  /// [borderColor] - Color of the border. Defaults to [Colors.white].
  CircleShape({this.borderWidth = 0, this.borderColor = Colors.white}) {
    this.borderPaint.isAntiAlias = true;
    this.borderPaint.style = PaintingStyle.stroke;
  }

  /// Builds the geometric path for this circle shape.
  ///
  /// [rect] - The bounding rectangle that defines the area within which the circle should be drawn.
  /// [scale] - Optional scaling factor (currently not used in this implementation).
  ///
  /// Returns a [Path] object representing the circle's outline.
  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(rect: rect!);
  }

  /// Generates the actual path for the circle shape.
  ///
  /// Creates a perfect circle that fits within the given rectangle. The circle's
  /// center is positioned at the center of the rectangle, and its radius is determined
  /// by the smaller of the width or height dimensions to ensure the circle fits completely.
  ///
  /// [useBezier] - Optional parameter for future Bézier curve support (currently unused).
  /// [rect] - The bounding rectangle that defines the drawing area.
  ///
  /// Returns a [Path] object with the circle's geometric outline.
  Path generatePath({bool? useBezier, required Rect rect}) {
    return Path()..addOval(
      Rect.fromCircle(
        center: Offset(rect.width / 2.0, rect.height / 2.0),
        radius: min(rect.width / 2.0, rect.height / 2.0),
      ),
    );
  }

  /// Draws a custom border for the circle shape.
  ///
  /// This method is called when the shape needs to draw its border.
  /// The border is only drawn if [borderWidth] is greater than 0.
  /// The border is drawn as a circle with radius adjusted to account for the border width.
  ///
  /// [canvas] - The canvas on which to draw the border.
  /// [rect] - The bounding rectangle that defines the drawing area.
  @override
  void drawBorder(Canvas canvas, Rect rect) {
    if (this.borderWidth > 0) {
      borderPaint.color = this.borderColor;
      borderPaint.strokeWidth = this.borderWidth;
      canvas.drawCircle(
        rect.center,
        min(
          (rect.width - borderWidth) / 2.0,
          (rect.height - borderWidth) / 2.0,
        ),
        borderPaint,
      );
    }
  }
}
