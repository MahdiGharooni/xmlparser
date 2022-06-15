import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml_parser/helpers/parser.dart';
import 'package:xml_parser/widgets/parsed_text_widget.dart';

class SampleDetailsPage extends StatefulWidget {
  const SampleDetailsPage(
      {Key? key, required this.folderName, required this.title})
      : super(key: key);

  final String folderName;
  final String title;

  @override
  _SampleDetailsPageState createState() => _SampleDetailsPageState();
}

class _SampleDetailsPageState extends State<SampleDetailsPage> {
  final List<String> _parsedTexts = [];
  final List<String> _filesName = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _parseFolder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return ParsedTextWidget(
                  path: '${_filesName[index]}:',
                  parsedText: _parsedTexts[index],
                );
              },
              itemCount: _parsedTexts.length,
              padding: const EdgeInsets.all(24),
            ),
    );
  }

}
