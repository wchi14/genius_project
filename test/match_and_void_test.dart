import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/games/match_and_void/logic/board_generator.dart';
import 'package:genius_project/games/match_and_void/logic/match_validator.dart';
import 'package:genius_project/games/match_and_void/models/match_card.dart';

void main() {
  group('MatchCard', () {
    test('full deck has 27 unique ids', () {
      final deck = BoardGenerator.generateFullDeck();
      expect(deck, hasLength(27));
      expect(deck.map((c) => c.id).toSet(), hasLength(27));
    });

    test('fromId round-trips attributes', () {
      for (var id = 0; id < 27; id++) {
        final card = MatchCard.fromId(id);
        expect(card.id, id);
        expect(
          card.shape.index * 9 + card.color.index * 3 + card.fill.index,
          id,
        );
      }
    });
  });

  group('MatchValidator', () {
    test('all same on every attribute is valid', () {
      final c = MatchCard.fromId(0);
      expect(MatchValidator.isValidMatch(c, c, c), isTrue);
    });

    test('all different on every attribute is valid', () {
      final a = MatchCard.fromId(0); // circle, red, solid
      final b = MatchCard.fromId(13); // square, blue, solid
      final c = MatchCard.fromId(26); // triangle, yellow, striped
      expect(MatchValidator.isValidMatch(a, b, c), isTrue);
    });

    test('two same one different on an attribute is invalid', () {
      final a = MatchCard.fromId(0); // circle, red, solid
      final b = MatchCard.fromId(1); // circle, red, empty
      final c = MatchCard.fromId(3); // circle, blue, solid
      expect(MatchValidator.isValidMatch(a, b, c), isFalse);
    });

    test('findAllValidMatches checks 84 triplets on a 9-card board', () {
      final board = BoardGenerator.generateBoard(random: Random(42));
      final matches = MatchValidator.findAllValidMatches(board);
      for (final triplet in matches) {
        expect(MatchValidator.isValidMatch(triplet[0], triplet[1], triplet[2]),
            isTrue);
      }
      expect(matches.length, lessThanOrEqualTo(84));
    });
  });

  group('BoardGenerator', () {
    test('generateBoard returns 9 distinct cards from the deck', () {
      final board = BoardGenerator.generateBoard(random: Random(7));
      expect(board, hasLength(9));
      expect(board.map((c) => c.id).toSet(), hasLength(9));
    });
  });
}
