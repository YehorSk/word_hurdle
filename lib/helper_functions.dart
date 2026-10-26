import 'package:flutter/material.dart';

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
}

void showResult({
  required BuildContext context,
  required String title,
  required String body,
  required VoidCallback onPlayAgain,
  required VoidCallback onCancel,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            onCancel();
          },
          child: const Text('ZAVRIEŤ'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            onPlayAgain();
          },
          child: const Text('HRAŤ ZNOVA'),
        ),
      ],
    ),
  );
}
