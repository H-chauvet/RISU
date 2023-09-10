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
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey,
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
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: articles!.length,
                itemBuilder: (_, i) {
                  return Text(
                    articles![i],
                  );
                })
          ],
        ));
  }
}
