import 'package:flutter/material.dart';

class ParsedTextWidget extends StatelessWidget {
  const ParsedTextWidget(
      {Key? key, required this.path, required this.parsedText})
      : super(key: key);

  final String path;

  final String parsedText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              path,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(parsedText),
          ],
        ),
      ),
      key: Key(path),
    );
  }
}
