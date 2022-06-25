import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xml_parser/helpers/parser.dart';
import 'package:xml_parser/widgets/parsed_text_widget.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({Key? key}) : super(key: key);

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  Directory? selectedDirectory;
  List<String> parsedFiles = [];
  List<String> dirNames = [];
  List<File> files = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
        actions: [
          if (parsedFiles.isNotEmpty)
            IconButton(
              onPressed: () async {
                _onSavedPressed(context);
              },
              icon: const Icon(Icons.download_sharp),
            ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () async {
                var _mediaStatus = await Permission.mediaLibrary.status;
                if (_mediaStatus.isGranted) {
                  var _externalStatus =
                      await Permission.manageExternalStorage.status;

                  if (_externalStatus.isGranted) {
                    _pickDirectory(context);
                  } else {
                    await Permission.manageExternalStorage.request();
                  }
                } else {
                  await Permission.mediaLibrary.request();
                }
              },
              child: const Text('choose directory'),
            ),
            const SizedBox(
              height: 12,
            ),
            _loading ? const CircularProgressIndicator() : _getWidgets(),
          ],
        ),
      ),
    );
  }

  /// choose multiple .xml files by user & then parse them
  Future<void> _pickDirectory(BuildContext context) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      setState(() {
        parsedFiles.clear();
        files.clear();
        dirNames.clear();
        _loading = true;
      });
      Directory _dir = Directory(selectedDirectory);
      var _children = _dir.listSync().toList();

      for (var child in _children) {
        /// folder has only some .xml files
        if (child.path.endsWith('.xml')) {
          if (child != null) {
            setState(() {
              _loading = true;
            });

            final File file = File(child.path);

            files.add(file);

            parsedFiles.add(Parser.parse(file.readAsStringSync()));
          }
        } else {
          /// folder has some other folders
          Directory _folder = Directory(child.path);

          final String _dirName =
              _folder.path.split('/').last.replaceAll('/', '').trim();

          dirNames.add(_dirName);

          var _files = _folder.listSync().toList();

          _parseFolder(_files);
        }
      }
    }

    setState(() {
      _loading = false;
    });
  }

  void _parseFolder(List<dynamic> _children) {
    for (var child in _children) {
      /// folder has only some .xml files
      if (child.path.endsWith('.xml')) {
        if (child != null) {
          setState(() {
            _loading = true;
          });

          final File file = File(child.path);

          files.add(file);

          parsedFiles.add(Parser.parse(file.readAsStringSync()));
        }

        setState(() {
          _loading = false;
        });
      } else {
        /// folder has some other folders
        Directory _folder = Directory(child.path);
        var _files = _folder.listSync().toList();
        _parseFolder(_files);
      }
    }
  }

  Future<void> _onSavedPressed(BuildContext context) async {
    try {
      /// merge all files output in one file
      final Directory? _dir = await getExternalStorageDirectory();
      for (var dirName in dirNames) {
        final File file = File('${_dir!.path}/$dirName.txt');

        String _res = '';

        files.asMap().forEach((index, file) {
          if ('${file.path}/'.contains('/$dirName/')) {
            _res = '$_res\n${parsedFiles[index]}';
          }
        });

        await file.writeAsString(_res);

        /// show successful snackBar
        SnackBar snackBar = SnackBar(
          content:
              Text('It was saved in this address:\n${_dir.path}/$dirName.txt'),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (_) {}
  }

  Widget _getWidgets() {
    List<Widget> _res = [Container()];
    for (var dirName in dirNames) {
      _res.add(
        Text(
          '$dirName:',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.red),
        ),
      );

      files.asMap().forEach((index, file) {
        if ("${file.path}/".contains('/$dirName/')) {
          _res.add(ParsedTextWidget(
              path: file.path, parsedText: parsedFiles[index]));
        }
      });
    }

    return Expanded(
      child: ListView(
        children: _res,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }
}
