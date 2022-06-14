import 'package:flutter/material.dart';
import 'package:xml_parser/sample_page/sample_details_page.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Text(
                'In this page you can see the sample of parsing from English or Italian input folder.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const SampleDetailsPage(
                          folderName: '/values/',
                          title: 'English input',
                        )));
              },
              child: const Text('English Folder Input'),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const SampleDetailsPage(
                          folderName: '/values-it/',
                          title: 'Italian input',
                        )));
              },
              child: const Text('Italian Folder Input'),
            ),
          ],
        ),
      ),
    );
  }
}
