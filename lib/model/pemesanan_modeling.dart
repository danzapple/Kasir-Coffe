import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kasirpemesanancoffe/database/produk_base.dart';
import 'package:kasirpemesanancoffe/layout/kasir_modeling.dart';
import 'package:kasirpemesanancoffe/style/const_color.dart';
import 'package:kasirpemesanancoffe/style/text_style.dart';

class Pesanan extends StatefulWidget {
  @override
  _PesananState createState() => _PesananState();
}

class _PesananState extends State<Pesanan> with TickerProviderStateMixin {
  @override
  TabController controller;
  GlobalKey<ScaffoldState> scafoldState = GlobalKey<ScaffoldState>();
  var data;
  @override
  void initState() {
    controller = TabController(vsync: this, length: 2, initialIndex: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldState,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabBar(
              controller: controller,
              labelColor: colorAmber,
              indicatorColor: colorAmber,
              tabs: [
                Tab(
                  icon: Icon(Icons.list_alt_outlined),
                  text: "Konfirmasi",
                ),
                Tab(
                  icon: Icon(Icons.check_box),
                  text: "Sudah Terkonfirmasi",
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height - 50,
              width: double.infinity,
              child: TabBarView(
                controller: controller,
                children: [
                  listPemesanan(context, ""),
                  listPemesanan(context, "sukses")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  listPemesanan(BuildContext context, String konfirmasi) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
          stream: Firestore.instance
              .collection("pembelian_brg")
              .orderBy('konfirmasi', descending: true)
              .where("konfirmasi", isEqualTo: konfirmasi == "" ? "" : "sukses")
              .where("coffe", isEqualTo: "Coffe $coffe")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return SizedBox();
            else
              return Column(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    color: colorAmber2,
                    child: Center(
                        child: Text(
                      konfirmasi == ""
                          ? "Total Belum Terkonfirmasi " +
                              snapshot.data.documents.length.toString()
                          : 'Total Terkonfirmasi ' +
                              snapshot.data.documents.length.toString(),
                      style: textStyle11White,
                    )),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 100,
                    width: double.infinity,
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 200),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        var namaBarang =
                            snapshot.data.documents[index]['nama_barang'];

                        int total = snapshot.data.documents[index]['total'];

                        String meja = snapshot.data.documents[index]['meja'];

                        String user = snapshot.data.documents[index]['user'];
                        String pembayaran =
                            snapshot.data.documents[index]['pembayaran'];
                        var ref = snapshot.data.documents[index].reference;
                        return mejaPesanan(
                            user,
                            meja,
                            namaBarang,
                            pembayaran,
                            konfirmasi == "" ? "" : "sukses",
                            total,
                            ref,
                            context);
                      },
                    ),
                  ),
                ],
              );
          }),
    );
  }

  Container mejaPesanan(
      String nama,
      String meja,
      List listBarang,
      String pembayaran,
      String konfirmasi,
      int total,
      var ref,
      BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorWhite,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(
                  2,
                  2,
                ))
          ]),
      child: Row(
        children: [
          Container(
            width: 190,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$nama",
                  style: textStyleNormalBlackW500,
                ),
                Text(
                  "$meja",
                  style: meja == "Saldo"
                      ? textStyleNormalBlue11
                      : textStyleNormalGreen11,
                ),
                Text(
                  "Jenis Pesanan :",
                  style: textStyleNormalBlack11,
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 3, bottom: 10),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: listBarang.length,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Text(
                            "- " + listBarang[index],
                            style: textStyleNormalBlack11,
                          );
                        },
                      ),
                    )),
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "Konfirmasi : ", style: textStyleNormalBlack11),
                  TextSpan(text: konfirmasi, style: textStyleNormalGreen11)
                ])),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Jumlah Rp. ${total.toString()}",
                      style: textStyleNormalBlack11,
                    ),
                    Text(
                      pembayaran,
                      style: textStyleNormalBlue11,
                    ),
                  ],
                ),
              ],
            ),
          ),
          konfirmasi == "sukses"
              ? SizedBox()
              : RaisedButton(
                  color: meja == "Saldo" ? Colors.blue : Colors.green,
                  onPressed: () {
                    ProdukService().pembelianBarangUpdate("sukses", ref);
                  },
                  child: Text(
                    "Konfirmasi",
                    style: textStyle11White,
                  ),
                )
        ],
      ),
    );
  }
}
