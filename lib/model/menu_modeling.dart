import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kasirpemesanancoffe/database/produk_base.dart';
import 'package:kasirpemesanancoffe/layout/kasir_modeling.dart';
import 'package:kasirpemesanancoffe/model/edit_produk_modeling.dart';

import 'package:kasirpemesanancoffe/style/const_color.dart';
import 'package:kasirpemesanancoffe/style/text_style.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with TickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    controller = TabController(vsync: this, length: 2, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabBar(
              controller: controller,
              labelColor: colorAmber,
              indicatorColor: colorAmber,
              tabs: [
                Tab(
                  icon: Icon(Icons.food_bank_outlined),
                  text: "Makanan",
                ),
                Tab(
                  icon: Icon(Icons.local_drink_rounded),
                  text: "Minuman",
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: TabBarView(
                controller: controller,
                children: [menuMakanan(), menuMinuman()],
              ),
            )
          ],
        ),
      ),
    );
  }

  menuMakanan() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("produks")
            .where("jenis", isEqualTo: "Makanan")
            .where("coffe", isEqualTo: "Coffe $coffe")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null || !snapshot.hasData) {
            return SizedBox();
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                itemCount: snapshot.data.documents.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1.8 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (contex, index) {
                  var ref = snapshot.data.documents[index].reference;
                  String nama = snapshot.data.documents[index]['nama'];
                  String jenis = snapshot.data.documents[index]['jenis'];
                  String harga = snapshot.data.documents[index]['harga'];
                  String img = snapshot.data.documents[index]['photo'];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          contex,
                          MaterialPageRoute(
                              builder: (contex) => EditProduk(
                                    coffe: coffe,
                                    harga: harga,
                                    img: img,
                                    nama: nama,
                                    ref: ref,
                                    jenis: jenis,
                                  )));
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: colorWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2, 2),
                            )
                          ]),
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                color: colorWhite,
                                image: DecorationImage(
                                    image: NetworkImage(snapshot
                                        .data.documents[index]['photo']),
                                    fit: BoxFit.cover)),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 102,
                                        child: Text(
                                          snapshot.data.documents[index]
                                              ['nama'],
                                          style: textStyleNormalBlack11,
                                        ),
                                      ),
                                      Text(
                                        "Rp. ${snapshot.data.documents[index]['harga']}",
                                        style: textStyleNormalBlack11,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      ProdukService().produkDelete(ref);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }

  menuMinuman() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("produks")
            .where("jenis", isEqualTo: "Minuman")
            .where("coffe", isEqualTo: "Coffe $coffe")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null || !snapshot.hasData) {
            return SizedBox();
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                physics: ScrollPhysics(),
                padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                itemCount: snapshot.data.documents.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1.8 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (contex, index) {
                  var ref = snapshot.data.documents[index].reference;
                  String nama = snapshot.data.documents[index]['nama'];
                  String jenis = snapshot.data.documents[index]['jenis'];
                  String harga = snapshot.data.documents[index]['harga'];
                  String img = snapshot.data.documents[index]['photo'];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          contex,
                          MaterialPageRoute(
                              builder: (contex) => EditProduk(
                                    coffe: coffe,
                                    harga: harga,
                                    img: img,
                                    nama: nama,
                                    ref: ref,
                                    jenis: jenis,
                                  )));
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: colorWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2, 2),
                            )
                          ]),
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                color: colorWhite,
                                image: DecorationImage(
                                    image: NetworkImage(snapshot
                                        .data.documents[index]['photo']),
                                    fit: BoxFit.cover)),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 102,
                                        child: Text(
                                          snapshot.data.documents[index]
                                              ['nama'],
                                          style: textStyleNormalBlack11,
                                        ),
                                      ),
                                      Text(
                                        "Rp. ${snapshot.data.documents[index]['harga']}",
                                        style: textStyleNormalBlack11,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      ProdukService().produkDelete(ref);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}
