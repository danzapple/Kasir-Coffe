import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kasirpemesanancoffe/database/produk_base.dart';
import 'package:kasirpemesanancoffe/layout/kasir_modeling.dart';
import 'package:kasirpemesanancoffe/style/const_color.dart';
import 'package:kasirpemesanancoffe/style/text_style.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  _showSnackBar() {
    final snackBar = SnackBar(
      content: Text("Konfirmasi sukses "),
      action: SnackBarAction(
          label: "close",
          onPressed: () {
            print("close");
          }),
    );
    _scaffoldState.currentState.showSnackBar(snackBar);
  }

  @override
  TabController controller;
  @override
  void initState() {
    controller = TabController(vsync: this, length: 2, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabBar(
              controller: controller,
              labelColor: colorAmber,
              indicatorColor: colorAmber,
              tabs: [
                Tab(
                  icon: Icon(Icons.payment_rounded),
                  text: "Konfirmasi",
                ),
                Tab(
                  icon: Icon(Icons.check_box),
                  text: "Sudah Terkonfirmasi",
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: TabBarView(
                controller: controller,
                children: [paymentList(""), paymentList("sukses")],
              ),
            )
          ],
        ),
      ),
    );
  }

  paymentList(String konfirmasi) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("saldo_user")
            .where("coffe", isEqualTo: "Coffe " + coffe)
            .where("verifikasi", isEqualTo: konfirmasi == "" ? "" : "sukses")
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
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      String jumlahSaldo =
                          snapshot.data.documents[index]['jum_saldo'];
                      String tmpSaldo =
                          snapshot.data.documents[index]['tambah_saldo'];
                      String nama = snapshot.data.documents[index]['nama_user'];
                      String id = snapshot.data.documents[index]['id'];
                      String type = snapshot.data.documents[index]['type'];
                      int jumSaldo = int.parse(jumlahSaldo) +
                          (tmpSaldo == "" ? 0 : int.parse(tmpSaldo));
                      var ref = snapshot.data.documents[index].reference;

                      return paymentItem(
                          nama,
                          konfirmasi == "" ? "" : "sukses",
                          id,
                          type,
                          tmpSaldo == "" ? jumlahSaldo : tmpSaldo,
                          jumSaldo.toString(),
                          ref);
                    },
                  ),
                ),
              ],
            );
        });
  }

  Container paymentItem(String nama, String konfirmasi, String id, String type,
      String jumlah, String jumSaldo, var ref) {
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
                  "[ID:$id]",
                  style: textStyleNormalBlackW500,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Type ($type)",
                  style: type == "Saldo"
                      ? textStyleNormalBlue11
                      : textStyleNormalGreen11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Jumlah Rp. $jumlah",
                      style: textStyleNormalBlack11,
                    ),
                    Text(
                      konfirmasi,
                      style: textStyleNormalGreen11,
                    ),
                  ],
                ),
              ],
            ),
          ),
          konfirmasi == "sukses"
              ? SizedBox()
              : RaisedButton(
                  color: type == "Saldo" ? Colors.blue : Colors.green,
                  onPressed: () {
                    _showSnackBar();
                    ProdukService()
                        .updatePayments("sukses", jumSaldo.toString(), ref);
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
