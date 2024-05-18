import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/container/container_list_data.dart';
import 'package:risu/pages/container/container_page.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  final container1 = ContainerList(
    id: 1,
    address: 'rue george',
    city: 'nantes',
    latitude: 0.0,
    longitude: 0.0,
    itemCount: 0,
    distance: 27.5,
  );
  sleep(const Duration(seconds: 1));
  dynamic json2 = {
    'id': 2,
    'address': 'rue test',
    'city': 'nantes',
    'latitude': 1.0,
    'longitude': 0.0,
    '_count': {
      'items': 0,
    },
  };
  final container2 = ContainerList.fromJson(json2);
  sleep(const Duration(seconds: 1));
  final container3 = ContainerList(
    id: 3,
    address: 'rue george',
    city: 'nantes',
    latitude: 0.0,
    longitude: 1.0,
    itemCount: 0,
    distance: 27.5,
  );

  group("ContainerList Data integration test", () {
    test('ContainerList Data creation test', () {
      expect(container1.id, 1);
      expect(container1.address, 'rue george');
      expect(container1.city, 'nantes');
      expect(container1.latitude, 0.0);
      expect(container1.longitude, 0.0);
      expect(container1.itemCount, 0);
      expect(container1.distance, 27.5);
    });

    test('ContainerList Data creation from json test', () {
      expect(container2.id, 2);
      expect(container2.address, 'rue test');
      expect(container2.city, 'nantes');
      expect(container2.latitude, 1.0);
      expect(container2.longitude, 0.0);
      expect(container2.itemCount, 0);
      expect(container2.distance, 0);
    });

    test('ContainerList Data creation from json test', () {
      final json3 = container3.toMap();
      expect(json3['id'], 3);
      expect(json3['address'], 'rue george');
      expect(json3['city'], 'nantes');
      expect(json3['latitude'], 0.0);
      expect(json3['longitude'], 1.0);
      expect(json3['itemCount'], 0);
      expect(json3['distance'], 27.5);
    });
  });

  group("ContainerPage tests", () {
    testWidgets("ContainerPage basic page with containers", (WidgetTester tester) async {
      final testpage = initPage(ContainerPage(
        onDirectionClicked: (id) {},
        testContainers: [container1, container2, container3],
        testPosition: const LatLng(1, 1),
      ));

      await waitForLoader(tester: tester, testPage: testpage);

      Finder titleData = find.byKey(const Key('container-list_title'));
      Finder containerData1 = find.byKey(const Key('container-list_container-1'));
      Finder containerlocalization1 = find.byKey(const Key('container-list_icon-localization-1'));

      
      expect(titleData, findsOneWidget);
      expect(containerData1, findsOneWidget);

      await tester.tap(containerlocalization1);
      await tester.pumpAndSettle();

      await tester.tap(containerData1);
      await tester.pumpAndSettle();
    });

    testWidgets("ContainerPage no container found", (WidgetTester tester) async {
      final testpage = initPage(ContainerPage(
        onDirectionClicked: (id) {},
        testContainers: [],
      ));

      await waitForLoader(tester: tester, testPage: testpage);

      Finder noContainerData = find.byKey(const Key('container-list_no-container'));
      expect(noContainerData, findsOneWidget);
    });
  });
}
