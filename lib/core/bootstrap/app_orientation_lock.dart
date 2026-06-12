import 'package:flutter/services.dart';

/// Locks the app to landscape orientations at the Flutter layer.
///
/// Pair with native locks:
/// - **iOS** `Info.plist` → `UISupportedInterfaceOrientations` (landscape only).
/// - **Android** `AndroidManifest.xml` → `android:screenOrientation="sensorLandscape"`.
abstract final class AppOrientationLock {
  static const List<DeviceOrientation> landscapeOnly = <DeviceOrientation>[
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  /// Call once after [WidgetsFlutterBinding.ensureInitialized].
  static Future<void> apply() {
    return SystemChrome.setPreferredOrientations(landscapeOnly);
  }
}
