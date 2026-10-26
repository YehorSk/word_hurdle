import 'package:flutter/material.dart';

import 'wordle.dart';

Color colorForStatus(LetterStatus status) => switch (status) {
  LetterStatus.correct => Colors.green.shade600,
  LetterStatus.present => Colors.amber.shade700,
  LetterStatus.absent => Colors.blueGrey.shade700,
  LetterStatus.initial => Colors.transparent,
};

class WordleView extends StatelessWidget {
  const WordleView({super.key, required this.wordle});

  final Wordle wordle;

  @override
  Widget build(BuildContext context) {
    final evaluated = wordle.status != LetterStatus.initial;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorForStatus(wordle.status),
        border: Border.all(
          color: evaluated
              ? Colors.transparent
              : wordle.letter.isEmpty
              ? Colors.grey.shade700
              : Colors.grey.shade400,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            wordle.letter,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
