class Parser {
  /// a regex to find placeholders like: %1$s
  static RegExp regex = RegExp(r'(%[0-9]*\$[a-z])');

  static final List<String> _names = [];

  /// parse the text as argument
  static String parse(String _text) {
    _names.clear();
    final List<String> _stringsTag = _text.split('<string');
    String _res = '';

    for (var element in _stringsTag) {
      if (element.contains('</string>')) {
        final int _nameLastTag = element.indexOf(">");
        final int _afterNameLastTag = element.indexOf("</string>") + 9;
        final String _name = element
            .substring(0, _nameLastTag)
            .replaceAll('name=', '')
            .replaceAll('"', '')
            .trim();
        if (!_nameAddedBefore(_name)) {
          _names.add(_name);
          final String _afterName = element
              .substring(_nameLastTag, _afterNameLastTag)
              .replaceAll('</string>', '')
              .replaceAll('\\t', '\t')
              .replaceAll('\\n', '\n')
              .replaceAll("\\'", "'")
              .replaceAll('\\"', '"')
              .replaceAll('>', '')
              .replaceAll('%d', '{d}')
              .replaceAll('</resources', '');

          /// plurals
          final String _plurals = element.substring(_afterNameLastTag).trim();
          if (_plurals.isNotEmpty && _plurals.contains('plurals')) {
            final List<String> _listOfPlurals = _plurals.split('<plurals');
            for (var element in _listOfPlurals) {
              if (element.isNotEmpty) {
                _res = _setPlurals(_res, element);
              }
            }
          }

          /// use regex to find placeholders
          final bool _hasMatch = regex.hasMatch(_afterName);
          if (_hasMatch) {
            final String _afterName2 = _afterName
                .replaceAll('%', '{')
                .replaceAll('\$s', '}')
                .replaceAll('\$d', '}');
            _res = '$_res\n$_name = $_afterName2';
          } else {
            _res = '$_res\n$_name = $_afterName';
          }
        }
      }
    }

    return _res;
  }

  /// separated the plurals
  static String _setPlurals(String _res, String _plurals) {
    final int _pluralNameIndex = _plurals.indexOf('name');
    final int _pluralNameLastIndex = _plurals.indexOf('>');

    final String _pluralName = _plurals
        .substring(_pluralNameIndex, _pluralNameLastIndex)
        .replaceAll('name=', '')
        .replaceAll('"', '')
        .trim();
    _res = '$_res\n$_pluralName = [\n';

    final List<String> _pluralItems =
        _plurals.substring(_pluralNameLastIndex).split('<item');
    for (var element in _pluralItems) {
      if (element.contains('</item>')) {
        final int _quantityIndex = element.indexOf('quantity');
        final int _quantityLastIndex = element.indexOf('>');

        final String _quantity = element
            .substring(_quantityIndex, _quantityLastIndex)
            .replaceAll('quantity', '')
            .replaceAll('=', '')
            .replaceAll('"', '')
            .trim();
        String _quantityValue = element
            .substring(_quantityLastIndex)
            .replaceAll('>', '')
            .replaceAll('</item', '')
            .replaceAll('</plurals', '')
            .replaceAll('\\t', '\t')
            .replaceAll('\\n', '\n')
            .replaceAll("\\'", "'")
            .replaceAll('\\"', '"')
            .replaceAll('%d', '{}')
            .trim();

        final bool _regex = regex.hasMatch(_quantityValue);
        if (_regex) {
          _quantityValue = _quantityValue
              .replaceAll('%', '{')
              .replaceAll('\$s', '}')
              .replaceAll('\$d', '}');
        }

        _res = '$_res$_quantity = $_quantityValue\n';
      }
    }

    return '$_res]';
  }

}
