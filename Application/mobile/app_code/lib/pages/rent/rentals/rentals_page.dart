import 'package:flutter/material.dart';

import 'rentals_state.dart';

/// Rental page.
/// this page is used to display the rental informations.
/// params:
/// [testRentals] - rental data to display.
class RentalPage extends StatefulWidget {
  final List<dynamic> testRentals;
  final bool appbar;

  const RentalPage({
    super.key,
    this.testRentals = const [],
    required this.appbar,
  });

  @override
  State<RentalPage> createState() => RentalPageState();
}
