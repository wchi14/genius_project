import 'package:flutter_test/flutter_test.dart';

import 'package:genius_project/games/blind_bluff_fatal_fold/ai/fatal_fold_ai_config.dart';

void main() {
  test('standard FatalFoldAiConfig validates (sum-to-one rows)', () {
    const cfg = FatalFoldAiConfig.standard();
    cfg.assertValid();
  });
}
