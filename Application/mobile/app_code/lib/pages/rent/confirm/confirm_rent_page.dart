import 'package:flutter/material.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/rent/confirm/confirm_rent_state.dart';

/// Confirm rent page.
/// this page is used to confirm the rental.
/// params:
/// [key] - key to identify the widget.
/// [hours] - rental duration.
/// [data] - article data to display.
/// [locationId] - location id.
class ConfirmRentPage extends StatefulWidget {
  final int hours;
  final ArticleData data;
  final int locationId;

  const ConfirmRentPage({
    super.key,
    required this.hours,
    required this.data,
    required this.locationId,
  });

  @override
  State<ConfirmRentPage> createState() => ConfirmRentState();
}
