import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

/// Enum defining the possible positions for the bubble arrow.
///
/// The arrow can be positioned on any of the four sides of the bubble,
/// creating a speech bubble or tooltip appearance.
enum BubblePosition { Bottom, Top, Left, Right }

/// A shape that creates speech bubble or tooltip-like containers with an arrow.
///
/// [BubbleShape] generates geometric paths for bubble shapes that resemble
/// speech bubbles or tooltips. The bubble consists of a rounded rectangle
/// with an arrow (tail) that can be positioned on any of the four sides.
///
/// The bubble's appearance can be customized with:
/// - Arrow position (bottom, top, left, right)
/// - Border radius for rounded corners
/// - Arrow dimensions (height and width)
/// - Arrow position along the edge (as a percentage)
///
/// Example usage:
/// ```dart
/// // Create a bottom-positioned speech bubble
/// BubbleShape(
///   position: BubblePosition.Bottom,
///   borderRadius: 12.0,
///   arrowHeight: 10.0,
///   arrowWidth: 15.0,
///   arrowPositionPercent: 0.5,
/// )
///
/// // Create a left-positioned tooltip
/// BubbleShape(
///   position: BubblePosition.Left,
///   borderRadius: 8.0,
///   arrowHeight: 8.0,
///   arrowWidth: 12.0,
///   arrowPositionPercent: 0.3,
/// )
/// ```
class BubbleShape extends Shape {
  /// The position of the arrow relative to the bubble body.
  ///
  /// Determines on which side of the bubble the arrow will be drawn.
  /// Can be [BubblePosition.Bottom], [BubblePosition.Top],
  /// [BubblePosition.Left], or [BubblePosition.Right].
  final BubblePosition position;

  /// The radius for the rounded corners of the bubble body.
  ///
  /// A larger value creates more rounded corners. Must be non-negative.
  /// Defaults to 12.0.
  final double borderRadius;

  /// The height (or length) of the arrow extending from the bubble body.
  ///
  /// For top/bottom positioned arrows, this is the vertical distance the arrow extends.
  /// For left/right positioned arrows, this is the horizontal distance the arrow extends.
  /// Defaults to 10.0.
  final double arrowHeight;

  /// The width of the base of the arrow where it connects to the bubble body.
  ///
  /// A larger value creates a wider arrow base. Defaults to 10.0.
  final double arrowWidth;

  /// The position of the arrow along the edge as a percentage (0.0 to 1.0).
  ///
  /// For top/bottom arrows: 0.0 places the arrow at the left edge, 0.5 at center, 1.0 at right edge.
  /// For left/right arrows: 0.0 places the arrow at the top edge, 0.5 at center, 1.0 at bottom edge.
  /// Defaults to 0.5 (center position).
  final double arrowPositionPercent;

  /// Creates a new [BubbleShape] with customizable arrow and styling options.
  ///
  /// All parameters are optional and have sensible defaults for creating
  /// a standard speech bubble appearance.
  ///
  /// [position] - Where to position the arrow. Defaults to [BubblePosition.Bottom].
  /// [borderRadius] - Corner radius for the bubble body. Defaults to 12.0.
  /// [arrowHeight] - How far the arrow extends from the bubble. Defaults to 10.0.
  /// [arrowWidth] - Width of the arrow base. Defaults to 10.0.
  /// [arrowPositionPercent] - Arrow position along the edge (0.0 to 1.0). Defaults to 0.5 (center).
  BubbleShape({
    this.position = BubblePosition.Bottom,
    this.borderRadius = 12,
    this.arrowHeight = 10,
    this.arrowWidth = 10,
    this.arrowPositionPercent = 0.5,
  });

  /// Builds the geometric path for this bubble shape.
  ///
  /// [rect] - The bounding rectangle that defines the area within which the bubble should be drawn.
  /// [scale] - Optional scaling factor (currently not used in this implementation).
  ///
  /// Returns a [Path] object representing the bubble shape's outline.
  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(rect: rect!);
  }

  /// Generates the actual path for the bubble shape including the arrow.
  ///
  /// Creates a rounded rectangle with an arrow extending from one of its sides.
  /// The implementation uses quadratic Bézier curves for smooth rounded corners
  /// and calculates spacing to accommodate the arrow based on its position.
  ///
  /// The method handles four different arrow positions:
  /// - Top: Arrow extends upward from the top edge
  /// - Bottom: Arrow extends downward from the bottom edge
  /// - Left: Arrow extends leftward from the left edge
  /// - Right: Arrow extends rightward from the right edge
  ///
  /// [rect] - The bounding rectangle that defines the drawing area.
  ///
  /// Returns a [Path] object with the bubble's geometric outline including the arrow.
  Path generatePath({required Rect rect}) {
    final Path path = new Path();

    double topLeftDiameter = max(borderRadius, 0);
    double topRightDiameter = max(borderRadius, 0);
    double bottomLeftDiameter = max(borderRadius, 0);
    double bottomRightDiameter = max(borderRadius, 0);

    final double spacingLeft = this.position == BubblePosition.Left
        ? arrowHeight
        : 0;
    final double spacingTop = this.position == BubblePosition.Top
        ? arrowHeight
        : 0;
    final double spacingRight = this.position == BubblePosition.Right
        ? arrowHeight
        : 0;
    final double spacingBottom = this.position == BubblePosition.Bottom
        ? arrowHeight
        : 0;

    final double left = spacingLeft + rect.left;
    final double top = spacingTop + rect.top;
    final double right = rect.right - spacingRight;
    final double bottom = rect.bottom - spacingBottom;

    final double centerX = (rect.left + rect.right) * arrowPositionPercent;

    path.moveTo(left + topLeftDiameter / 2.0, top);
    //LEFT, TOP

    if (position == BubblePosition.Top) {
      path.lineTo(centerX - arrowWidth, top);
      path.lineTo(centerX, rect.top);
      path.lineTo(centerX + arrowWidth, top);
    }
    path.lineTo(right - topRightDiameter / 2.0, top);

    path.quadraticBezierTo(right, top, right, top + topRightDiameter / 2);
    //RIGHT, TOP

    if (position == BubblePosition.Right) {
      path.lineTo(
        right,
        bottom - (bottom * (1 - arrowPositionPercent)) - arrowWidth,
      );
      path.lineTo(rect.right, bottom - (bottom * (1 - arrowPositionPercent)));
      path.lineTo(
        right,
        bottom - (bottom * (1 - arrowPositionPercent)) + arrowWidth,
      );
    }
    path.lineTo(right, bottom - bottomRightDiameter / 2);

    path.quadraticBezierTo(
      right,
      bottom,
      right - bottomRightDiameter / 2,
      bottom,
    );
    //RIGHT, BOTTOM

    if (position == BubblePosition.Bottom) {
      path.lineTo(centerX + arrowWidth, bottom);
      path.lineTo(centerX, rect.bottom);
      path.lineTo(centerX - arrowWidth, bottom);
    }
    path.lineTo(left + bottomLeftDiameter / 2, bottom);

    path.quadraticBezierTo(left, bottom, left, bottom - bottomLeftDiameter / 2);
    //LEFT, BOTTOM

    if (position == BubblePosition.Left) {
      path.lineTo(
        left,
        bottom - (bottom * (1 - arrowPositionPercent)) + arrowWidth,
      );
      path.lineTo(rect.left, bottom - (bottom * (1 - arrowPositionPercent)));
      path.lineTo(
        left,
        bottom - (bottom * (1 - arrowPositionPercent)) - arrowWidth,
      );
    }
    path.lineTo(left, top + topLeftDiameter / 2);

    path.quadraticBezierTo(left, top, left + topLeftDiameter / 2, top);

    path.close();

    return path;
  }
}
