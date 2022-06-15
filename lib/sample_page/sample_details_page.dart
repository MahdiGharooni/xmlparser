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

  Future<void> _parseFolder() async {
    final byteData = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> _maps = json.decode(byteData) ?? {};

    _maps.forEach((key, value) async {
      if (key.contains(widget.folderName) && key.contains('.xml')) {
        final String _fileName = (value as List<dynamic>)[0];

        _filesName.add(_fileName);

        final String _text =
            await DefaultAssetBundle.of(context).loadString(_fileName);

        final String _res = Parser.parse(_text);

        _parsedTexts.add(_res);
      }
    });

    setState(() {
      _loading = false;
    });
  }
}
