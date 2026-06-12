import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:genius_project/core/bootstrap/app_orientation_lock.dart';
import 'package:genius_project/core/routing/app_router.dart';
import 'package:genius_project/core/services/audio_haptic_manager.dart';
import 'package:genius_project/core/services/audio_haptic_service.dart';
import 'package:genius_project/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppOrientationLock.apply();
  // BGM + structured SFX + haptic tracks — must be awaited so the BGM player
  // has ReleaseMode.loop set before any screen calls playLobbyBGM().
  await AudioHapticService.instance.initialize();
  // ASMR game clips (card flip, dice shake…) — fire-and-forget; files may not
  // exist until added, and missing files are skipped gracefully.
  unawaited(AudioHapticManager.instance.preloadCommonAssets());
  runApp(GeniusApp(router: createAppRouter()));
}

class GeniusApp extends StatelessWidget {
  const GeniusApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Genius Project',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.neoCasinoDark(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
