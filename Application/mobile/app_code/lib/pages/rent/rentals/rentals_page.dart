import 'package:flutter/material.dart';

import 'rentals_state.dart';

class RentalPage extends StatefulWidget {
  final List<dynamic> testRentals;

  const RentalPage({
    super.key,
    this.testRentals = const [],
  });

  @override
  State<RentalPage> createState() => RentalPageState();
}
