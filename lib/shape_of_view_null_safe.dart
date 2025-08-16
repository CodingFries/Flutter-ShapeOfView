import 'package:flutter/material.dart';

// Export all shape implementations to make them available to users of this package
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

/// Abstract base class that defines the contract for all shapes in the ShapeOfView package.
///
/// All shape implementations must extend this class and implement the [build] method
/// to define their geometric path.
abstract class Shape {
  /// Builds the geometric path for this shape.
  ///
  /// [rect] - The bounding rectangle that defines the area within which the shape should be drawn.
  /// [scale] - Optional scaling factor to resize the shape proportionally.
  ///
  /// Returns a [Path] object that represents the shape's outline.
  Path build({Rect? rect, double? scale});
}

/// Mixin that provides border drawing capabilities for shapes.
///
/// Shapes that need to draw custom borders should implement this mixin
/// in addition to extending the [Shape] class.
abstract mixin class BorderShape {
  /// Draws a custom border for the shape on the given canvas.
  ///
  /// [canvas] - The canvas on which to draw the border.
  /// [rect] - The bounding rectangle that defines the drawing area.
  void drawBorder(Canvas canvas, Rect rect);
}

/// A custom [ShapeBorder] implementation that wraps a [Shape] to provide
/// border functionality for Flutter widgets.
///
/// This class serves as an adapter between the custom [Shape] implementations
/// and Flutter's built-in shape border system, allowing shapes to be used
/// with Material widgets and other components that expect a [ShapeBorder].
class ShapeOfViewBorder extends ShapeBorder {
  /// The underlying shape that defines the border's geometry.
  final Shape shape;

  /// Creates a new [ShapeOfViewBorder] with the given [shape].
  ///
  /// The [shape] parameter is required and defines the geometric outline
  /// of the border.
  ShapeOfViewBorder({required this.shape});

  /// Returns the dimensions of the border.
  ///
  /// For custom shapes, this returns zero insets since the shape itself
  /// defines the visual boundaries.
  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(0);
  }

  /// Scales this border by the given factor.
  ///
  /// Since custom shapes handle their own scaling through the [Shape.build] method,
  /// this returns the current instance unchanged.
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

  /// Returns the inner path of the border.
  ///
  /// For custom shapes, this returns an empty path since the shape itself
  /// defines the complete boundary without separate inner/outer paths.
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  /// Returns the outer path of the border.
  ///
  /// This delegates to the underlying [shape] to build its geometric path
  /// within the given rectangle with a scale factor of 1.
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return shape.build(rect: rect, scale: 1);
  }

  /// Paints the border on the given canvas.
  ///
  /// If the underlying [shape] implements [BorderShape], this method will
  /// delegate to the shape's custom border drawing logic. Otherwise,
  /// no border is drawn.
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (shape is BorderShape) {
      (shape as BorderShape).drawBorder(canvas, rect);
    }
  }

  /// Determines whether this border is equal to another object.
  ///
  /// Two [ShapeOfViewBorder] instances are considered equal if they
  /// wrap the same [shape].
  @override
  bool operator ==(Object other) {
    if (other is! ShapeOfViewBorder) return false;
    return shape == other.shape;
  }

  /// Returns the hash code for this border.
  ///
  /// The hash code is based on the underlying [shape].
  @override
  int get hashCode => shape.hashCode;

  /// Returns a string representation of this border.
  ///
  /// Includes the runtime type and the underlying shape information.
  @override
  String toString() {
    return '$runtimeType($shape)';
  }
}

/// A widget that applies a custom shape to its child widget.
///
/// [ShapeOfView] wraps its child in a [Material] widget with a custom
/// [ShapeOfViewBorder] to create visually appealing shaped containers.
/// The widget supports elevation, clipping, and size constraints.
///
/// Example usage:
/// ```dart
/// ShapeOfView(
///   shape: CircleShape(),
///   elevation: 8.0,
///   child: Container(
///     width: 100,
///     height: 100,
///     child: Text('Shaped Content'),
///   ),
/// )
/// ```
class ShapeOfView extends StatelessWidget {
  /// The child widget to be displayed within the shaped container.
  final Widget? child;

  /// The shape to apply to the container. Must not be null when building.
  final Shape? shape;

  /// The elevation of the shaped container, creating a shadow effect.
  /// Defaults to 4.0.
  final double elevation;

  /// How to clip the child widget within the shape boundaries.
  /// Defaults to [Clip.antiAlias] for smooth edges.
  final Clip clipBehavior;

  /// The height constraint for the shaped container.
  /// If null, the container will size itself based on its child.
  final double? height;

  /// The width constraint for the shaped container.
  /// If null, the container will size itself based on its child.
  final double? width;

  /// Creates a new [ShapeOfView] widget.
  ///
  /// The [shape] parameter defines the geometric shape to apply.
  /// The [elevation] defaults to 4.0 and creates a shadow effect.
  /// The [clipBehavior] defaults to [Clip.antiAlias] for smooth clipping.
  /// Optional [width] and [height] can constrain the container size.
  ShapeOfView({
    Key? key,
    this.child,
    this.elevation = 4,
    this.shape,
    this.clipBehavior = Clip.antiAlias,
    this.width,
    this.height,
  }) : super(key: key);

  /// Builds the widget tree for this [ShapeOfView].
  ///
  /// Creates a [Material] widget with a custom [ShapeOfViewBorder] that wraps
  /// the child widget. The Material provides elevation and clipping capabilities,
  /// while the Container applies size constraints.
  ///
  /// Throws an assertion error if [shape] is null.
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
