import 'package:app_3/ui/gif_pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _pesquisa;
  int _offset = 0;

  Future<Map> _buscaGifs() async {
    http.Response response;
    if (_pesquisa == null || _pesquisa.isEmpty)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=P8H8MsUg4N7Wvy81y51t8BC8BkEIkSu3&limit=20&rating=g");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=P8H8MsUg4N7Wvy81y51t8BC8BkEIkSu3&q=$_pesquisa&limit=19&offset=$_offset&rating=g&lang=en");
    return json.decode(response.body);
  }

  // @override
  // void initState() {
  //   super.initState();
//
//    _buscaGifs().then((map) {
//      print(map);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise Aqui",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _pesquisa = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _buscaGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white,
                        ),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container(child: Text("Erro"));
                    else
                      return _criaTabelaGift(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _buscaQuantidade(List data) {
    if (_pesquisa == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _criaTabelaGift(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //quantidade de itens por linha
          crossAxisCount: 2,
          //espaco entre os gifs
          crossAxisSpacing: 10,
          //espaço na vertical
          mainAxisSpacing: 10),
      //quantidade de itens na tela
      itemCount: _buscaQuantidade(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_pesquisa == null || index < snapshot.data["data"].length)
          return GestureDetector(
            child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (contexto) => GifPage(
                    snapshot.data["data"][index],
                  ),
                ),
              );
            },
            onLongPress: () {
              Share.share(
                snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              );
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 70),
                  Text(
                    "Carregar + ...",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
      },
    );
  }
}
