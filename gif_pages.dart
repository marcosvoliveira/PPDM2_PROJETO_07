import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  //construtor
  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
          ),
        ],
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
