import 'package:flutter/material.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/rent/confirm/confirm_rent_state.dart';

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
