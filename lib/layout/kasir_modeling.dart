import 'package:flutter/material.dart';

import 'package:kasirpemesanancoffe/layout/produk_modeling.dart';
import 'package:kasirpemesanancoffe/model/bank_modeling.dart';
import 'package:kasirpemesanancoffe/model/menu_modeling.dart';

import 'package:kasirpemesanancoffe/model/pemesanan_modeling.dart';
import 'package:kasirpemesanancoffe/model/saldo_modeling.dart';
import 'package:kasirpemesanancoffe/style/const_color.dart';
import 'package:kasirpemesanancoffe/style/text_style.dart';

String coffe;

class KasirCoffe extends StatefulWidget {
  String coffe;
  Key key;
  Menu menu;
  KasirCoffe({this.coffe, this.menu, this.key}) : super(key: key);

  @override
  _KasirCoffeState createState() => _KasirCoffeState();
}

final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

class _KasirCoffeState extends State<KasirCoffe> {
  int selectedIndex = 0;

  List<Widget> _widget = [
    Menu(),
    Pesanan(),
    Payments(),
    VirtualBank(
      coffe: "Coffe " + coffe,
    )
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        unselectedItemColor: colorAmber,
        selectedItemColor: colorAmber2,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined), label: "Menu"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: "Pesanan"),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: "Saldo"),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_rounded), label: "Virtual Bank"),
        ],
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: colorAmber,
        title: Text(
          "Kasir Coffe ${widget.coffe}",
          style: textStyle20White,
        ),
      ),
      floatingActionButton: selectedIndex != 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contexr) => Produk(
                              coffe: "Coffe ${widget.coffe}",
                            )));
              },
              backgroundColor: colorAmber,
              child: Icon(Icons.add),
              tooltip: "Tambah Menu",
            ),
      body: _widget.elementAt(selectedIndex),
    );
  }
}
