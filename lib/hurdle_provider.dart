import 'dart:math';

import 'package:english_words/english_words.dart' as words;
import 'package:flutter/foundation.dart';

import 'wordle.dart';

class HurdleProvider extends ChangeNotifier {
  final Random _random = Random.secure();

  static const int lettersPerRow = 5;
  static const int totalAttempts = 6;

  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<Wordle> hurdleBoard = [];

  Map<String, LetterStatus> keyStatus = {};

  String targetWord = '';
  int count = 0;
  int index = 0;
  int attempts = 0;
  bool wins = false;

  bool get shouldCheckForAnswer => rowInputs.length == lettersPerRow;
  bool get noAttemptsLeft => attempts == totalAttempts;
  bool get isGameOver => wins || noAttemptsLeft;
  bool get isAValidWord => totalWords.contains(rowInputs.join().toLowerCase());

  void init() {
    totalWords = words.all
        .where((w) => w.length == lettersPerRow)
        .map((w) => w.toLowerCase())
        .toSet()
        .toList();
    _generateBoard();
    _generateRandomWord();
  }

  void _generateBoard() {
    hurdleBoard = List.generate(
      lettersPerRow * totalAttempts,
      (_) => Wordle(letter: ''),
    );
  }

  void _generateRandomWord() {
    targetWord = totalWords[_random.nextInt(totalWords.length)].toUpperCase();
  }

  void inputLetter(String letter) {
    if (isGameOver || count >= lettersPerRow) return;
    rowInputs.add(letter);
    hurdleBoard[index] = Wordle(letter: letter);
    count++;
    index++;
    notifyListeners();
  }

  void deleteLetter() {
    if (isGameOver || count == 0) return;
    rowInputs.removeLast();
    count--;
    index--;
    hurdleBoard[index] = Wordle(letter: '');
    notifyListeners();
  }

  void checkAnswer() {
    if (!shouldCheckForAnswer || isGameOver) return;

    final input = rowInputs.join();
    final rowStart = index - lettersPerRow;
    final statuses = List.filled(lettersPerRow, LetterStatus.absent);

    final remaining = <String, int>{};
    for (var i = 0; i < lettersPerRow; i++) {
      if (input[i] == targetWord[i]) {
        statuses[i] = LetterStatus.correct;
      } else {
        remaining.update(targetWord[i], (v) => v + 1, ifAbsent: () => 1);
      }
    }
    for (var i = 0; i < lettersPerRow; i++) {
      if (statuses[i] == LetterStatus.correct) continue;
      final left = remaining[input[i]] ?? 0;
      if (left > 0) {
        statuses[i] = LetterStatus.present;
        remaining[input[i]] = left - 1;
      }
    }

    for (var i = 0; i < lettersPerRow; i++) {
      hurdleBoard[rowStart + i].status = statuses[i];
      _updateKeyStatus(input[i], statuses[i]);
    }

    wins = input == targetWord;
    attempts++;
    rowInputs = [];
    count = 0;
    notifyListeners();
  }

  void _updateKeyStatus(String letter, LetterStatus status) {
    final current = keyStatus[letter];
    if (current == null ||
        current == LetterStatus.absent ||
        (current == LetterStatus.present && status == LetterStatus.correct)) {
      keyStatus[letter] = status;
    }
  }

  void reset() {
    rowInputs = [];
    keyStatus = {};
    count = 0;
    index = 0;
    attempts = 0;
    wins = false;
    _generateBoard();
    _generateRandomWord();
    notifyListeners();
  }
}
