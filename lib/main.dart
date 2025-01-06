import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    BenimUygulamam(),
  );
}

class BenimUygulamam extends StatelessWidget {
  const BenimUygulamam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color.fromARGB(96, 195, 186, 186),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                "Bugün Ne Yarak Yesem ?",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          body: YemekSayfasi()),
    );
  }
}

class YemekSayfasi extends StatefulWidget {
  const YemekSayfasi({super.key});

  @override
  State<YemekSayfasi> createState() => _YemekSayfasiState();
}

class _YemekSayfasiState extends State<YemekSayfasi> {
  int yemek = 1, corba = 1, tatli = 1;

  List<String> corba_adlari = [
    "Mercimek",
    "Tarhana",
    "Tavuk Suyu",
    "Dügün Corbası",
    "Yogurt Corbası"
  ];
  List<String> yemek_adlari = [
    "Patlican Musaka",
    "Mantı",
    "Kuru Fasiülye",
    "Dertli Köfte",
    "Balık"
  ];
  List<String> tatli_adlari = [
    "Tel sarma",
    "Bakalava",
    "Sütlaç",
    "Kazan dibi",
    "Dondurma"
  ];

  void Yemekye() {
    setState(() {
      if (yemek == 5) {
        yemek = 0;
      }
      yemek += 1;
    });
  }

  void Corbaye() {
    setState(() {
      if (corba == 5) {
        corba = 0;
      }
      corba += 1;
    });
  }

  void Tatliye() {
    setState(() {
      if (tatli == 5) {
        tatli = 0;
      }
      tatli += 1;
    });
  }

  Widget corba_isim() {
    return Column(
      children: [
        Text(
          corba_adlari[corba - 1],
          style: TextStyle(fontSize: 20),
        ),
        Container(
          width: 200,
          child: Divider(
            height: 50,
            color: Colors.black,
          ),
        )
      ],
    );
  }
  Widget yemek_isim() {
    return Column(
      children: [
        Text(
          yemek_adlari[yemek - 1],
          style: TextStyle(fontSize: 20),
        ),
        Container(
          width: 200,
          child: Divider(
            height: 50,
            color: Colors.black,
          ),
        )
      ],
    );
  }
    Widget tatli_isim() {
    return Column(
      children: [
        Text(
          tatli_adlari[tatli - 1],
          style: TextStyle(fontSize: 20),
        ),
        Container(
          width: 200,
          child: Divider(
            height: 50,
            color: Colors.black,
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                onPressed: Corbaye,
                icon: Image.asset("assets/corba_$corba.jpg"),
              ),
            ),
          ),
          corba_isim(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onPressed: Yemekye,
                icon: Image.asset("assets/yemek_$yemek.jpg"),
              ),
            ),
          ),
          yemek_isim(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                onPressed: Tatliye,
                icon: Image.asset("assets/tatli_$tatli.jpg"),
              ),
            ),
          ),
          tatli_isim(),
        ],
      ),
    );
  }
}
