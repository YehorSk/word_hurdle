import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'helper_functions.dart';
import 'hurdle_provider.dart';
import 'keyboard_view.dart';
import 'wordle_view.dart';

class WordHurdlePage extends StatelessWidget {
  const WordHurdlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (_, event) => _handlePhysicalKey(context, event),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Word Hurdle'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Nová hra',
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<HurdleProvider>().reset(),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Consumer<HurdleProvider>(
                      builder: (context, provider, _) => Text(
                        'Pokus ${provider.attempts}/${HurdleProvider.totalAttempts}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio:
                              HurdleProvider.lettersPerRow /
                              HurdleProvider.totalAttempts,
                          child: Consumer<HurdleProvider>(
                            builder: (context, provider, _) => GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        HurdleProvider.lettersPerRow,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                  ),
                              itemCount: provider.hurdleBoard.length,
                              itemBuilder: (context, index) => WordleView(
                                wordle: provider.hurdleBoard[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Consumer<HurdleProvider>(
                      builder: (context, provider, _) => KeyboardView(
                        keyStatus: provider.keyStatus,
                        onPressed: provider.inputLetter,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () =>
                              context.read<HurdleProvider>().deleteLetter(),
                          icon: const Icon(Icons.backspace_outlined),
                          label: const Text('DELETE'),
                        ),
                        FilledButton.icon(
                          onPressed: () => _handleInput(context),
                          icon: const Icon(Icons.check),
                          label: const Text('SUBMIT'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleInput(BuildContext context) {
    final provider = context.read<HurdleProvider>();

    if (provider.isGameOver) {
      showMsg(context, 'Hra skončila – začni novú hru.');
      return;
    }
    if (!provider.shouldCheckForAnswer) {
      showMsg(
        context,
        'Slovo musí mať ${HurdleProvider.lettersPerRow} písmen.',
      );
      return;
    }
    if (!provider.isAValidWord) {
      showMsg(context, 'Toto slovo nie je v slovníku.');
      return;
    }

    provider.checkAnswer();

    if (provider.wins) {
      showResult(
        context: context,
        title: 'Vyhral si!',
        body:
            'Uhádol si slovo ${provider.targetWord} '
            'na ${provider.attempts}. pokus.',
        onPlayAgain: provider.reset,
        onCancel: () {},
      );
    } else if (provider.noAttemptsLeft) {
      showResult(
        context: context,
        title: 'Prehral si!',
        body: 'Hľadané slovo bolo ${provider.targetWord}.',
        onPlayAgain: provider.reset,
        onCancel: () {},
      );
    }
  }

  KeyEventResult _handlePhysicalKey(BuildContext context, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final provider = context.read<HurdleProvider>();
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _handleInput(context);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace) {
      provider.deleteLetter();
      return KeyEventResult.handled;
    }
    final label = key.keyLabel.toUpperCase();
    if (label.length == 1 && RegExp('[A-Z]').hasMatch(label)) {
      provider.inputLetter(label);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
