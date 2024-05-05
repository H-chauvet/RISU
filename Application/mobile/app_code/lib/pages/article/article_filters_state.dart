import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/components/filled_button.dart';
import 'article_filters_page.dart';

class ArticleFiltersState extends State<ArticleFiltersPage> {
  late String? sortBy;
  late bool isAscending;
  late bool isAvailable;
  late String? selectedCategoryId;
  late List<dynamic> _articleCategories;

  @override
  void initState() {
    super.initState();

    sortBy = widget.sortBy ?? 'price';
    isAscending = widget.isAscending;
    isAvailable = widget.isAvailable;
    selectedCategoryId = widget.selectedCategoryId;
    _articleCategories = widget.articleCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!.filter,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.select((ThemeProvider themeProvider) =>
                        themeProvider
                            .currentTheme.buttonTheme.colorScheme!.secondary),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
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
                  dropdownColor: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
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
                      value: 'null',
                      child: Text(
                        AppLocalizations.of(context)!.allCategories,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    for (var category in _articleCategories)
                      DropdownMenuItem<String>(
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
            const Text(
              'Trier par :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Radio buttons for selecting sort option
            ListTile(
              title: const Text('Prix'),
              onTap: () => setState(() {
                sortBy = 'price';
              }),
              leading: Radio<String>(
                value: 'price',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Notes'),
              onTap: () => setState(() {
                sortBy = 'rating';
              }),
              leading: Radio<String>(
                value: 'rating',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(AppLocalizations.of(context)!.ascending),
              onTap: () => setState(() {
                isAscending = true;
              }),
              leading: Radio(
                value: true,
                groupValue: isAscending,
                onChanged: (value) {
                  setState(() {
                    isAscending = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.descending),
              onTap: () => setState(() {
                isAscending = false;
              }),
              leading: Radio(
                value: false,
                groupValue: isAscending,
                onChanged: (value) {
                  setState(() {
                    isAscending = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.available),
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
            ),
            const SizedBox(height: 20),
            MyButton(
              key: const Key('article-button_article-rent'),
              text: "Appliquer les filtres",
              onPressed: () {
                Navigator.pop(context, {
                  'sortBy': sortBy,
                  'isAscending': isAscending,
                  'isAvailable': isAvailable,
                  'selectedCategoryId': selectedCategoryId,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
