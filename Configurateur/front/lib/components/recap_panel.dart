import 'package:flutter/material.dart';

///
/// RecapPanel
///
class RecapPanel extends StatelessWidget {
  const RecapPanel({super.key, this.price, this.articles});

  final int? price;
  final List<String>? articles;

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
                  return Text(
                    articles![i],
                  );
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  child: const Text('Sauvegarde'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  child: const Text('Imprimer'),
                ),
              ],
            )
          ],
        ));
  }
}
