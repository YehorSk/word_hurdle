import 'dart:math';

import 'package:flutter/material.dart';

import 'wordle.dart';
import 'wordle_view.dart';

const keysList = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
];

class KeyboardView extends StatelessWidget {
  const KeyboardView({
    super.key,
    required this.keyStatus,
    required this.onPressed,
  });

  final Map<String, LetterStatus> keyStatus;
  final ValueChanged<String> onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 4.0;
        final keyWidth = min(44.0, (constraints.maxWidth - gap * 10) / 10);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final row in keysList)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final letter in row)
                    Padding(
                      padding: const EdgeInsets.all(gap / 2),
                      child: _Key(
                        letter: letter,
                        width: keyWidth,
                        status: keyStatus[letter] ?? LetterStatus.initial,
                        onTap: () => onPressed(letter),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.letter,
    required this.width,
    required this.status,
    required this.onTap,
  });

  final String letter;
  final double width;
  final LetterStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: status == LetterStatus.initial
          ? Colors.grey.shade500
          : colorForStatus(status),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: 52,
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
