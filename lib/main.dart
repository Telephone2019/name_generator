import 'dart:collection';

import 'package:name_generator/animated_route/slide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

typedef WordPairGenerator = Iterable<WordPair> Function(int count);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final source = new LinkedHashSet<WordPair>();
    final favorite = new LinkedHashSet<WordPair>();
    return MaterialApp(
      title: "名称推荐",
      home: WordPairs("挑选你喜爱的名称", source, favorite, (pair) {
        if (favorite.contains(pair)) {
          favorite.remove(pair);
        } else {
          favorite.add(pair);
        }
      }, true, (count) => generateWordPairs().take(count), true),
    );
  }
}

class WordPairs extends StatefulWidget {
  final String _title;
  final LinkedHashSet<WordPair> _source; // ordered set
  final LinkedHashSet<WordPair> _favorite; // ordered set
  final void Function(WordPair pair) _onTapInSetState;
  final bool _growable;
  final WordPairGenerator _generator;
  final bool _canOpenFavorite;

  WordPairs(this._title, this._source, this._favorite, this._onTapInSetState,
      this._growable, this._generator, this._canOpenFavorite);

  @override
  _WordPairsState createState() => _WordPairsState(_title, _source, _favorite,
      _onTapInSetState, _growable, _generator, _canOpenFavorite);
}

class _WordPairsState extends State<WordPairs> {
  String _title;
  LinkedHashSet<WordPair> _source; // ordered set
  LinkedHashSet<WordPair> _favorite; // ordered set
  void Function(WordPair pair) _onTapInSetState;
  bool _growable;
  WordPairGenerator _generator;
  bool _canOpenFavorite;

  final _biggerFont = TextStyle(fontSize: 18.0);

  _WordPairsState(
      this._title,
      this._source,
      this._favorite,
      this._onTapInSetState,
      this._growable,
      this._generator,
      this._canOpenFavorite) {
    this._title ??= "名称推荐";
    this._source ??= new LinkedHashSet();
    this._favorite ??= new LinkedHashSet();
    this._growable ??= false;
    this._canOpenFavorite ??= false;
  }

  Widget _buildRow(int index, WordPair pair) {
    final bool isFavorite = _favorite.contains(pair);
    return ListTile(
      title: Text(
        index.toString() + "." + pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          _onTapInSetState?.call(pair);
        });
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _growable ? null : _source.length * 2,
      itemBuilder: (c, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        final len = _source.length;
        if (index >= len) {
          final exLen = len + 10;
          while (_source.length < exLen) {
            _source.addAll(_generator(exLen - _source.length));
          }
        }
        return _buildRow(
          index + 1,
          _source.elementAt(index),
        );
      },
      padding: EdgeInsets.all(16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: _canOpenFavorite
            ? [
                new IconButton(
                    icon: const Icon(Icons.list), onPressed: _openSavedList),
              ]
            : null,
      ),
      body: _buildListView(),
    );
  }

  void _openSavedList() {
    Navigator.of(context)
        .push(
          new SlideRoute.slideInBottom(
            page: WordPairs(
                "收藏的名称", new LinkedHashSet.from(_favorite), _favorite, (pair) {
              if (_favorite.contains(pair)) {
                _favorite.remove(pair);
              } else {
                _favorite.add(pair);
              }
            }, false, null, null),
          ),
        )
        .then((value) => setState(() {}));
  }
}
