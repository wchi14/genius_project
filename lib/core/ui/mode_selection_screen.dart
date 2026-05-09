import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Genius Project')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text(
              'Choose a mode',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                try {
                  // Use the router from the element tree (same instance as
                  // MaterialApp.router). Avoid importing `app_router.dart` here —
                  // that circular import can load a second copy of the router library
                  // so `appRouter.go` would not match `routerConfig`.
                  debugPrint('Single Player → context.go(/games)');
                  context.go('/games');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Navigation failed: $e')),
                  );
                }
              },
              child: const Text('Single Player'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming Phase 4')),
                );
              },
              child: const Text('Online'),
            ),
          ],
        ),
      ),
    );
  }
}

