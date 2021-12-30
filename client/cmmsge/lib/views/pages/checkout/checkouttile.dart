import 'package:cmmsge/services/models/checkout/checkoutModel.dart';
import 'package:flutter/material.dart';

class CheckoutTile extends StatelessWidget {
  late final CheckoutModel checkout;
  CheckoutTile({required this.checkout});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 3.0,
        color: Colors.white,
        child: InkWell(
          onTap: () {},
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text('Kode : ${checkout.idbarang}',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Nama : ${checkout.barang}',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Qty : ${checkout.qty} ${checkout.satuan}',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Keterangan : ${checkout.keterangan}',
                            style: TextStyle(fontSize: 18.0)),
                        Text('Tanggal : ${checkout.tanggal}',
                            style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
