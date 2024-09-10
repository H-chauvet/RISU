import 'package:flutter/material.dart';

import 'rentals_state.dart';

/// Rental page.
/// this page is used to display the rental informations.
/// params:
/// [key] - key to identify the widget.
/// [testRentals] - rental data to display.
class RentalPage extends StatefulWidget {
  final List<dynamic> testRentals;

  const RentalPage({
    super.key,
    this.testRentals = const [],
  });

  @override
  State<RentalPage> createState() => RentalPageState();
}
