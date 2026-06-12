import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai.dart';
import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';

void main() {
  test('config creates memory with tunable pool size', () {
    const tuned = BlindCountOpponentAiConfig(memoryPoolSize: 6);
    final ai = BlindCountOpponentAi(config: tuned);

    expect(ai.config.memoryPoolSize, 6);
    expect(ai.memory.memoryPoolSize, 6);
    expect(tuned.sumRevealMaxPoolRemaining, 14);
    expect(tuned.highConfidenceGuessThreshold, 30);
  });
}
