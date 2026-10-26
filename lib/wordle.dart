enum LetterStatus { initial, correct, present, absent }

class Wordle {
  String letter;
  LetterStatus status;

  Wordle({required this.letter, this.status = LetterStatus.initial});

  factory Wordle.fromString(String letter) => Wordle(letter: letter);

  bool get existsInTarget => status == LetterStatus.correct;
  bool get existsElsewhere => status == LetterStatus.present;
  bool get doesNotExistInTarget => status == LetterStatus.absent;
}
