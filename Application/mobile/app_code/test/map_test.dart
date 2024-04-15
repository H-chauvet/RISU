import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/map/map_page.dart';
import 'package:risu/pages/map/map_state.dart';

import 'globals.dart';

class MockGoogleMapController extends Mock implements GoogleMapController {}

class MockPermissionHandler extends Mock {}

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  testWidgets('displayGoogleMap set to true', (WidgetTester tester) async {
    userInformation = initExampleUser();
    await tester.pumpWidget(initPage(const MapPage(displayGoogleMap: false)));
    await tester.pumpAndSettle();
    BuildContext context = tester.element(find.byType(MapPage));
    expect(find.text(AppLocalizations.of(context)!.mapNoDisplayedByRisu),
        findsOneWidget);
  });

  testWidgets('displayGoogleMap set to false', (WidgetTester tester) async {
    userInformation = initExampleUser();
    await tester.pumpWidget(initPage(const MapPage(displayGoogleMap: true)));
    await tester.pumpAndSettle();
    BuildContext context = tester.element(find.byType(MapPage));
    expect(find.text(AppLocalizations.of(context)!.mapNoDisplayedByRisu),
        findsNothing);
  });

  testWidgets('Test _onMapCreated method', (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const MapPage(displayGoogleMap: true)));
    final MockGoogleMapController mockController = MockGoogleMapController();

    MapPageState mapPageState = tester.state(find.byType(MapPage));

    mapPageState.testOnMapCreated(mockController);

    expect(mapPageState.mapController, mockController);
  });
}
