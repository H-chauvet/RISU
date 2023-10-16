import 'package:flutter/material.dart';

class Locker {
  String type;
  int price;

  Locker(this.type, this.price);
}

///
/// RecapPanel
///
// ignore: must_be_immutable
class RecapPanel extends StatelessWidget {
  RecapPanel({super.key, this.articles, required this.onSaved});

  int sumPrice() {
    int price = 0;
    for (int i = 0; i < articles!.length; i++) {
      price += articles![i].price;
    }
    return price;
  }

  final List<Locker>? articles;
  late int? price = sumPrice();
  final Function() onSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
        //width: 300,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Panier',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: articles!.length,
                itemBuilder: (_, i) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            articles![i].type,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: Text(
                            "${articles![i].price.toString()}€",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ]);
                }),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Text('prix: ${price!}€'),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onSaved,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  child: const Text('Sauvegarde',
                      style: TextStyle(color: Colors.white)),
                ),
                /*const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  child: const Text('Imprimer'),
                ),*/
              ],
            )
          ],
        ));
  }
}
