import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/components/filled_button.dart';
import 'package:risu/components/text_input.dart';
import 'article_filters_page.dart';
import 'package:risu/components/alert_dialog.dart';

/// State class for the ArticleFiltersPage
/// Contains the state of the filters
class ArticleFiltersState extends State<ArticleFiltersPage> {
  late String? sortBy;
  late bool isAscending;
  late bool isAvailable;
  late String? selectedCategoryId;
  late List<dynamic> _articleCategories;
  double? min;
  double? max;

  @override
  void initState() {
    super.initState();

    sortBy = widget.sortBy ?? 'price';
    isAscending = widget.isAscending;
    isAvailable = widget.isAvailable;
    selectedCategoryId = widget.selectedCategoryId;
    _articleCategories = widget.articleCategories;
    min = widget.min;
    max = widget.max;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!.filter,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    AppLocalizations.of(context)!.sortBy,
                    key: const Key('filter-text_sortBy'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.buttonTheme
                                  .colorScheme!.secondary),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButton<String>(
                        key: const Key('filter-category_dropdown'),
                        value: selectedCategoryId,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategoryId = newValue;
                          });
                        },
                        style: TextStyle(
                          color: context.select((ThemeProvider themeProvider) =>
                              themeProvider.currentTheme.primaryColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        dropdownColor: context.select(
                            (ThemeProvider themeProvider) => themeProvider
                                .currentTheme.secondaryHeaderColor),
                        underline: Container(
                          height: 0,
                          color: context.select(
                            (ThemeProvider themeProvider) =>
                                themeProvider.currentTheme.secondaryHeaderColor,
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: context.select(
                            (ThemeProvider themeProvider) =>
                                themeProvider.currentTheme.primaryColor,
                          ),
                        ),
                        elevation: 3,
                        items: [
                          DropdownMenuItem<String>(
                            key: const Key('filter-null_category'),
                            value: 'null',
                            child: Text(
                              AppLocalizations.of(context)!.allCategories,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          for (var category in _articleCategories)
                            DropdownMenuItem<String>(
                              key: Key('filter-category_${category['id']}'),
                              value: category['id'].toString(),
                              child: Text(
                                category['name'],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    key: const Key('filter-radio_priceAscending'),
                    title: Text(
                      AppLocalizations.of(context)!.ascendingPrice,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onTap: () => setState(() {
                      sortBy = 'price';
                      isAscending = true;
                    }),
                    leading: Radio<String>(
                      value: 'priceAscending',
                      groupValue:
                          sortBy! + (isAscending ? 'Ascending' : 'Descending'),
                      onChanged: (value) {
                        setState(() {
                          sortBy = 'price';
                          isAscending = true;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    key: const Key('filter-radio_priceDescending'),
                    title: Text(
                      AppLocalizations.of(context)!.descendingPrice,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onTap: () => setState(() {
                      sortBy = 'price';
                      isAscending = false;
                    }),
                    leading: Radio<String>(
                      value: 'priceDescending',
                      groupValue:
                          sortBy! + (isAscending ? 'Ascending' : 'Descending'),
                      onChanged: (value) {
                        setState(() {
                          sortBy = 'price';
                          isAscending = false;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    key: const Key('filter-radio_noteAscending'),
                    title: Text(
                      AppLocalizations.of(context)!.ascendingRating,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onTap: () => setState(() {
                      sortBy = 'rating';
                      isAscending = true;
                    }),
                    leading: Radio<String>(
                      value: 'ratingAscending',
                      groupValue:
                          sortBy! + (isAscending ? 'Ascending' : 'Descending'),
                      onChanged: (value) {
                        setState(() {
                          sortBy = 'rating';
                          isAscending = true;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    key: const Key('filter-radio_noteDescending'),
                    title: Text(
                      AppLocalizations.of(context)!.descendingRating,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onTap: () => setState(() {
                      sortBy = 'rating';
                      isAscending = false;
                    }),
                    leading: Radio<String>(
                      value: 'ratingDescending',
                      groupValue:
                          sortBy! + (isAscending ? 'Ascending' : 'Descending'),
                      onChanged: (value) {
                        setState(() {
                          sortBy = 'rating';
                          isAscending = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: MyTextInput(
                          key: const Key('filter-input_min'),
                          initialValue:
                              (min != null) ? min?.toStringAsFixed(2) : null,
                          labelText: (sortBy == 'price')
                              ? AppLocalizations.of(context)!.minimumPrice
                              : AppLocalizations.of(context)!.minimumRating,
                          keyboardType: TextInputType.text,
                          icon: (sortBy == 'price')
                              ? Icons.euro
                              : Icons.star_border,
                          onChanged: (value) {
                            setState(() {
                              min = double.tryParse(value) ?? 0.0;
                              if (min! < 0) {
                                min = 0.0;
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: MyTextInput(
                          key: const Key('filter-input_max'),
                          initialValue:
                              (max != null) ? max?.toStringAsFixed(2) : null,
                          labelText: (sortBy == 'price')
                              ? AppLocalizations.of(context)!.maximumPrice
                              : AppLocalizations.of(context)!.maximumRating,
                          keyboardType: TextInputType.text,
                          icon: (sortBy == 'price')
                              ? Icons.euro
                              : Icons.star_border,
                          onChanged: (value) {
                            setState(() {
                              max = double.tryParse(value) ?? 0.0;
                              if (max! < 0) {
                                max = 0.0;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    key: const Key('filter-switch_available'),
                    title: Text(
                      AppLocalizations.of(context)!.availableItemsOnly,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    value: isAvailable,
                    onChanged: (value) {
                      setState(() {
                        isAvailable = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    key: const Key('filter-button_apply'),
                    text: AppLocalizations.of(context)!.applyFilters,
                    onPressed: () {
                      if (min != null && max != null && min! > max!) {
                        MyAlertDialog.showInfoAlertDialog(
                          context: context,
                          title: AppLocalizations.of(context)!.incorrectInputs,
                          message:
                              AppLocalizations.of(context)!.incorrectMinMax,
                        );
                        return;
                      }
                      Navigator.pop(context, {
                        'sortBy': sortBy,
                        'isAscending': isAscending,
                        'isAvailable': isAvailable,
                        'selectedCategoryId': selectedCategoryId,
                        'min': min,
                        'max': max,
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
