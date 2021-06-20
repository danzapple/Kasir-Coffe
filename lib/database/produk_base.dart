import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProdukService {
  void produkDataInsert(var nama, var harga, String photoUrl, String coffe,
      String jenis, BuildContext context) async {
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference = Firestore.instance.collection("produks");
      reference.add({
        "jenis": jenis,
        "nama": nama,
        "harga": harga,
        "photo": photoUrl,
        "coffe": coffe
      });
    });
  }

  //deleted produk
  void produkDelete(var ref) {
    Firestore.instance.runTransaction((transaksi) async {
      await transaksi.get(ref);
      await transaksi.delete(ref);
    });
  }

  //produk update
  void produkUpdate(
      var nama, var harga, String photoUrl, String jenis, var ref) {
    Firestore.instance.runTransaction((transaksi) async {
      await transaksi.get(ref);
      await transaksi.update(
          ref,
          ({
            "jenis": jenis,
            "nama": nama,
            "harga": harga,
            "photo": photoUrl,
          }));
    });
  }

  //pembelian barang update
  void pembelianBarangUpdate(String konfirmasi, var ref) {
    Firestore.instance.runTransaction((transaksi) async {
      await transaksi.get(ref);
      await transaksi.update(ref, {"konfirmasi": konfirmasi});
    });
  }

  //payment konfirmasi update
  void updatePayments(String konfirmasi, String jumSaldo, var ref) {
    Firestore.instance.runTransaction((transaksi) async {
      await transaksi.get(ref);
      await transaksi.update(ref, {
        "jum_saldo": jumSaldo,
        "tambah_saldo": "",
        "verifikasi": konfirmasi,
      });
    });
  }
}
