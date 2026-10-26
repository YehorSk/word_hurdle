import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:word_hurdle/hurdle_provider.dart';
import 'package:word_hurdle/main.dart';
import 'package:word_hurdle/wordle.dart';

HurdleProvider _provider(String target) => HurdleProvider()
  ..init()
  ..targetWord = target;

void _type(HurdleProvider p, String word) {
  for (final c in word.split('')) {
    p.inputLetter(c);
  }
}

void main() {
  group('HurdleProvider', () {
    test('input and delete stay within current row', () {
      final p = _provider('APPLE');
      _type(p, 'ABCDEF');
      expect(p.rowInputs.join(), 'ABCDE');
      p.deleteLetter();
      expect(p.rowInputs.join(), 'ABCD');
      expect(p.hurdleBoard[4].letter, '');
    });

    test('marks correct / present / absent with duplicate letters', () {
      final p = _provider('APPLE');
      _type(p, 'PAPER');
      p.checkAnswer();
      final s = p.hurdleBoard.take(5).map((w) => w.status).toList();
      expect(s, [
        LetterStatus.present,
        LetterStatus.present,
        LetterStatus.correct,
        LetterStatus.present,
        LetterStatus.absent,
      ]);
      expect(p.keyStatus['P'], LetterStatus.correct);
      expect(p.attempts, 1);
      expect(p.wins, isFalse);
    });

    test('win stops further input', () {
      final p = _provider('APPLE');
      _type(p, 'APPLE');
      p.checkAnswer();
      expect(p.wins, isTrue);
      expect(p.isGameOver, isTrue);
      p.inputLetter('A');
      expect(p.rowInputs, isEmpty);
    });

    test('loses after 6 wrong attempts, reset starts new game', () {
      final p = _provider('APPLE');
      for (var i = 0; i < HurdleProvider.totalAttempts; i++) {
        _type(p, 'HOUSE');
        p.checkAnswer();
      }
      expect(p.noAttemptsLeft, isTrue);
      expect(p.wins, isFalse);

      p.reset();
      expect(p.attempts, 0);
      expect(p.index, 0);
      expect(p.keyStatus, isEmpty);
      expect(p.hurdleBoard.every((w) => w.letter.isEmpty), isTrue);
      expect(p.targetWord.length, 5);
    });
  });

  testWidgets('typing on keyboard fills the board', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => HurdleProvider()..init(),
        child: const MyApp(),
      ),
    );
    expect(find.text('SUBMIT'), findsOneWidget);
    await tester.tap(find.text('Q'));
    await tester.pump();
    expect(find.text('Q'), findsNWidgets(2));
    await tester.tap(find.text('SUBMIT'));
    await tester.pump();
    expect(find.text('Slovo musí mať 5 písmen.'), findsOneWidget);
  });
}
