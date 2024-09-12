import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/rent/return_page.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/image_loader.dart';

/// Rental card.
/// this card is used to display the rental informations.
/// params:
/// [rental] - rental data to display.
class RentalCard extends StatelessWidget {
  final dynamic rental;

  const RentalCard({
    super.key,
    required this.rental,
  });

  /// Calculate the remaining time of the rental.
  /// params:
  /// [rental] - rental data.
  /// [context] - context of the widget.
  String calculateRemainingTime(dynamic rental, BuildContext context) {
    DateTime rentalStart = DateTime.parse(rental['createdAt']);
    int rentalDuration = rental['duration'];
    DateTime rentalEnd = rentalStart.add(Duration(hours: rentalDuration));
    Duration remainingTime = rentalEnd.difference(DateTime.now());
    int hours = remainingTime.inHours;
    int minutes = remainingTime.inMinutes.remainder(60);
    return AppLocalizations.of(context)!.hoursAndMinutes(hours, minutes);
  }

  /// Check if the rental is in progress.
  /// params:
  /// [rental] - rental data.
  bool isRentalInProgress(dynamic rental) {
    if (rental['createdAt'] != null &&
        rental['duration'] != null &&
        rental['ended'] == false) {
      DateTime rentalStart = DateTime.parse(rental['createdAt']);
      int rentalDuration = rental['duration'];
      DateTime rentalEnd = rentalStart.add(Duration(hours: rentalDuration));
      return rentalEnd.isAfter(DateTime.now());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('rental-list_card'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReturnArticlePage(rentId: rental['id']),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 0.0, left: 0.0, top: 10.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      key: const Key('article_image'),
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Image.asset(imageLoader(rental['item']['name'])),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rental['item']['name'],
                          key: const Key("article_name"),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.select(
                                (ThemeProvider themeProvider) =>
                                    themeProvider.currentTheme.primaryColor),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .priceTotalData(rental['price']),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.status}: ${isRentalInProgress(rental) ? AppLocalizations.of(context)!.inProgress : AppLocalizations.of(context)!.endedE}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        if (isRentalInProgress(rental))
                          Text(
                            "${AppLocalizations.of(context)!.timeRemaining}: ${calculateRemainingTime(rental, context)}",
                            key: const Key("article_timeRemaining"),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          )
                        else ...[
                          Text(
                            AppLocalizations.of(context)!
                                .rentTimeOfRenting(rental['duration']),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
              const Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chevron_right),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
