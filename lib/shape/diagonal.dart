import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:vector_math/vector_math.dart';

/// Enum defining the possible positions for the diagonal cut.
///
/// The diagonal cut can be positioned on any of the four sides of the rectangle,
/// creating various angled shapes and layouts.
enum DiagonalPosition { Bottom, Top, Left, Right }

/// Enum defining the direction of the diagonal cut.
///
/// The diagonal can slant either left or right, affecting the angle and
/// appearance of the cut.
enum DiagonalDirection { Left, Right }

/// A class that represents an angle for diagonal cuts.
///
/// [DiagonalAngle] encapsulates angle values and provides convenient constructors
/// for creating angles in both radians and degrees. It also implements proper
/// equality comparison for angle values.
class DiagonalAngle {
  /// The angle value stored in radians.
  ///
  /// All angle calculations are performed using radians internally
  /// for mathematical precision.
  final double angleRadians;

  /// Creates a [DiagonalAngle] from a radian value.
  ///
  /// [angle] - The angle in radians. Defaults to 0.
  const DiagonalAngle.radians({double angle = 0}) : angleRadians = angle;

  /// Creates a [DiagonalAngle] from a degree value.
  ///
  /// [angle] - The angle in degrees. Defaults to 0.
  /// The value is automatically converted to radians for internal storage.
  DiagonalAngle.deg({double angle = 0}) : this.radians(angle: radians(angle));

  /// Determines whether this angle is equal to another object.
  ///
  /// Two [DiagonalAngle] instances are considered equal if they
  /// have the same angle value in radians.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagonalAngle &&
          runtimeType == other.runtimeType &&
          angleRadians == other.angleRadians;

  /// Returns the hash code for this angle.
  ///
  /// The hash code is based on the angle value in radians.
  @override
  int get hashCode => angleRadians.hashCode;
}

/// A shape that creates rectangles with one diagonal edge.
///
/// [DiagonalShape] generates geometric paths for rectangular shapes where one edge
/// is cut diagonally instead of being straight. This creates dynamic, angled layouts
/// commonly used in modern UI designs.
///
/// The diagonal cut can be positioned on any of the four sides (top, bottom, left, right)
/// and can slant in either direction (left or right). The angle of the diagonal is
/// customizable and determines how steep the cut appears.
///
/// Example usage:
/// ```dart
/// // Create a bottom diagonal with 15-degree angle slanting left
/// DiagonalShape(
///   position: DiagonalPosition.Bottom,
///   direction: DiagonalDirection.Left,
///   angle: DiagonalAngle.deg(angle: 15),
/// )
///
/// // Create a top diagonal with custom radian angle
/// DiagonalShape(
///   position: DiagonalPosition.Top,
///   direction: DiagonalDirection.Right,
///   angle: DiagonalAngle.radians(angle: 0.2),
/// )
/// ```
class DiagonalShape extends Shape {
  /// The position of the diagonal cut relative to the rectangle.
  ///
  /// Determines which side of the rectangle will have the diagonal edge.
  /// Can be [DiagonalPosition.Bottom], [DiagonalPosition.Top],
  /// [DiagonalPosition.Left], or [DiagonalPosition.Right].
  final DiagonalPosition position;

  /// The direction the diagonal cut slants.
  ///
  /// Determines whether the diagonal slants left or right, affecting
  /// the visual appearance of the cut. Can be [DiagonalDirection.Left]
  /// or [DiagonalDirection.Right].
  final DiagonalDirection direction;

  /// The angle of the diagonal cut.
  ///
  /// Controls how steep the diagonal appears. Larger angles create
  /// more pronounced diagonal cuts, while smaller angles create subtler effects.
  final DiagonalAngle angle;

  /// Creates a new [DiagonalShape] with customizable diagonal properties.
  ///
  /// All parameters have sensible defaults for creating a bottom-positioned
  /// diagonal that slants left with a subtle angle.
  ///
  /// [position] - Where to position the diagonal cut. Defaults to [DiagonalPosition.Bottom].
  /// [direction] - Which direction the diagonal slants. Defaults to [DiagonalDirection.Left].
  /// [angle] - The angle of the diagonal cut. Defaults to a subtle negative angle.
  DiagonalShape({
    this.position = DiagonalPosition.Bottom,
    this.direction = DiagonalDirection.Left,
    this.angle = const DiagonalAngle.radians(angle: pi / -20),
  });

  /// Builds the geometric path for this diagonal shape.
  ///
  /// [rect] - The bounding rectangle that defines the area within which the shape should be drawn.
  /// [scale] - Optional scaling factor (currently not used in this implementation).
  ///
  /// Returns a [Path] object representing the diagonal shape's outline.
  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(rect: rect!);
  }

  /// Generates the actual path for the diagonal shape.
  ///
  /// Creates a rectangular path with one diagonal edge. The implementation handles
  /// all four possible positions (top, bottom, left, right) combined with both
  /// directions (left, right) to create the appropriate diagonal cut.
  ///
  /// The diagonal is calculated using trigonometry to determine the perpendicular
  /// height needed for the angled cut based on the rectangle width and angle.
  ///
  /// [rect] - The bounding rectangle that defines the drawing area.
  ///
  /// Returns a [Path] object with the diagonal shape's geometric outline.
  Path generatePath({required Rect rect}) {
    final Path path = Path();

    final width = rect.width;
    final height = rect.height;

    final double diagonalAngleRadAbs = this.angle.angleRadians.abs();
    final bool isDirectionLeft = this.direction == DiagonalDirection.Left;
    final double perpendicularHeight = (rect.width * tan(diagonalAngleRadAbs));

    switch (this.position) {
      case DiagonalPosition.Bottom:
        if (isDirectionLeft) {
          path.moveTo(0, 0);
          path.lineTo(width, 0);
          path.lineTo(width, height - perpendicularHeight);
          path.lineTo(0, height);
          path.close();
        } else {
          path.moveTo(width, height);
          path.lineTo(0, height - perpendicularHeight);
          path.lineTo(0, 0);
          path.lineTo(width, 0);
          path.close();
        }
        break;
      case DiagonalPosition.Top:
        if (isDirectionLeft) {
          path.moveTo(width, height);
          path.lineTo(width, 0 + perpendicularHeight);
          path.lineTo(0, 0);
          path.lineTo(0, height);
          path.close();
        } else {
          path.moveTo(width, height);
          path.lineTo(width, 0);
          path.lineTo(0, 0 + perpendicularHeight);
          path.lineTo(0, height);
          path.close();
        }
        break;
      case DiagonalPosition.Right:
        if (isDirectionLeft) {
          path.moveTo(0, 0);
          path.lineTo(width, 0);
          path.lineTo(width - perpendicularHeight, height);
          path.lineTo(0, height);
          path.close();
        } else {
          path.moveTo(0, 0);
          path.lineTo(width - perpendicularHeight, 0);
          path.lineTo(width, height);
          path.lineTo(0, height);
          path.close();
        }
        break;
      case DiagonalPosition.Left:
        if (isDirectionLeft) {
          path.moveTo(0 + perpendicularHeight, 0);
          path.lineTo(width, 0);
          path.lineTo(width, height);
          path.lineTo(0, height);
          path.close();
        } else {
          path.moveTo(0, 0);
          path.lineTo(width, 0);
          path.lineTo(width, height);
          path.lineTo(0 + perpendicularHeight, height);
          path.close();
        }
        break;
    }
    return path;
  }
}
