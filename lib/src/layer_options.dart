import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'data.dart';
import 'data_stream_factory.dart';
import 'drawing/default_location_marker.dart';
import 'marker_direction.dart';

/// Describes the needed properties to create a location marker layer. Location
/// marker layer is a compose layer, containing 3 widgets which are
/// 1) an accuracy circle (in a circle layer)
/// 2) a heading sector (in a marker layer) and
/// 3) a marker (in the same marker layer).
class LocationMarkerLayerOptions extends LayerOptions {
  /// A Stream that provide position data for this marker.
  final Stream<LocationMarkerPosition> positionStream;

  /// A Stream that provide heading data for this marker.
  final Stream<LocationMarkerHeading>? headingStream;

  /// The main marker widget.
  final Widget marker;

  /// The size of main marker widget.
  final Size markerSize;

  /// The direction of the marker.
  final MarkerDirection markerDirection;

  /// Whether to show accuracy circle. Android define accuracy as the radius of
  /// 68% confidence so there is a 68% probability that the true location is
  /// inside the circle.
  final bool showAccuracyCircle;

  /// The color of the accuracy circle.
  final Color accuracyCircleColor;

  /// Whether to show the heading sector.
  /// This is unsupported on web and this value will be ignored there.
  final bool showHeadingSector;

  /// The radius of the heading sector in pixels.
  final double headingSectorRadius;

  /// The color of the heading sector.
  final Color headingSectorColor;

  /// The duration of the marker's move animation .
  final Duration moveAnimationDuration;

  /// The curve of the marker's move animation.
  final Curve moveAnimationCurve;

  /// The duration of the heading sector rotate animation.
  final Duration rotateAnimationDuration;

  /// The curve of the heading sector rotate animation.
  final Curve rotateAnimationCurve;

  /// Create a LocationMarkerLayerOptions.
  LocationMarkerLayerOptions({
    Key? key,
    Stream<LocationMarkerPosition>? positionStream,
    Stream<LocationMarkerHeading>? headingStream,
    this.marker = const DefaultLocationMarker(),
    this.markerSize = const Size(20, 20),
    this.markerDirection = MarkerDirection.top,
    this.showAccuracyCircle = true,
    this.accuracyCircleColor = const Color.fromARGB(0x18, 0x21, 0x96, 0xF3),
    this.showHeadingSector = true,
    this.headingSectorRadius = 60,
    this.headingSectorColor = const Color.fromARGB(0xCC, 0x21, 0x96, 0xF3),
    @Deprecated(
      '`markerAnimationDuration` is split into `moveAnimationDuration` and `rotateAnimationDuration`',
    )
        Duration markerAnimationDuration = const Duration(milliseconds: 200),
    Duration? moveAnimationDuration,
    Duration? rotateAnimationDuration,
    this.moveAnimationCurve = Curves.fastOutSlowIn,
    this.rotateAnimationCurve = Curves.easeInOut,
    Stream<void>? rebuild,
  })  : positionStream = positionStream ??
            const LocationMarkerDataStreamFactory().geolocatorPositionStream(),
        headingStream = headingStream ?? _getDefaultHeadingStream(),
        moveAnimationDuration =
            moveAnimationDuration ?? markerAnimationDuration,
        rotateAnimationDuration =
            rotateAnimationDuration ?? markerAnimationDuration,
        super(
          key: key,
          rebuild: rebuild,
        );

  static Stream<LocationMarkerHeading>? _getDefaultHeadingStream() {
    // The compass plugin does not support web, hence, return a null stream if
    // the project is building for web.
    if (!kIsWeb) {
      return const LocationMarkerDataStreamFactory().compassHeadingStream();
    }
    return null;
  }

  /// The duration of the animation of location update.
  @Deprecated(
    '`markerAnimationDuration` is split into `moveAnimationDuration` and `rotateAnimationDuration`',
  )
  Duration get markerAnimationDuration => moveAnimationDuration;
}
