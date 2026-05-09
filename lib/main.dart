import 'package:flutter/material.dart';

import 'package:genius_project/core/routing/app_router.dart';

/// Entry point stays synchronous so the first frame is not delayed behind
/// [SystemChrome] work — that ordering can race the Android surface and produce
/// `FlutterRenderer: Width is zero` on some emulators (no hits, no Dart logs).
/// Landscape is enforced by `android:screenOrientation` in AndroidManifest.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp.router(
      title: 'Genius Project',
      debugShowCheckedModeBanner: true,
      routerConfig: appRouter,
    ),
  );
}
