import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/tickets_page.dart';
import 'package:front/screens/contact/contact.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('Test de Contact page', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: const ContactPage(),
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();
  });

  testWidgets('Test du composant TicketPage', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: const ContactPage(),
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Contactez le support RISU !'), findsOneWidget);
    expect(find.text('Liste des tickets'), findsOneWidget);
    expect(find.text('En cours'), findsOneWidget);
    expect(find.text('Fermés'), findsOneWidget);
    expect(find.text('Aucun Ticket'), findsOneWidget);
    expect(find.byType(CustomFooter), findsOneWidget);
    expect(find.byType(LandingAppBar), findsOneWidget);
    expect(find.byKey(const Key("ticket-state-open")), findsOneWidget);

    await tester.tap(find.byKey(const Key("ticket-state-open")));
    await tester.pump();

    final state = tester.state(find.byType(TicketsPage)) as TicketsState;
    expect(state.showOpenedTickets, isTrue);

    expect(find.byKey(const Key("ticket-state-closed")), findsOneWidget);

    await tester.tap(find.byKey(const Key("ticket-state-closed")));
    await tester.pump();

    final state2 = tester.state(find.byType(TicketsPage)) as TicketsState;
    expect(state2.showOpenedTickets, isFalse);

    String testDate1 = '2024-05-16T12:34:56.789Z';
    String expectedFormattedDate1 =
        DateFormat.yMd().add_Hm().format(DateTime.parse(testDate1));

    String testDate2 = '2021-02-01T00:00:00.000Z';
    String expectedFormattedDate2 =
        DateFormat.yMd().add_Hm().format(DateTime.parse(testDate2));

    final state_time = tester.state(find.byType(TicketsPage)) as TicketsState;
    expect(state_time.formatDateTime(testDate1), expectedFormattedDate1);
    expect(state_time.formatDateTime(testDate2), expectedFormattedDate2);

    List<dynamic> tickets = [
      {"assignedId": "342"},
      {"assignedId": "123"},
    ];

    List<dynamic> tickets2 = [
      {"assignedId": ""},
      {"assignedId": ""},
    ];

    final state_assign = tester.state(find.byType(TicketsPage)) as TicketsState;
    expect(state_assign.notAssigned(tickets), false);
    expect(state_assign.notAssigned(tickets2), true);
    expect(state_assign.assigned(tickets), false);
    expect(state_assign.assigned(tickets2), true);

    state_assign.conversation = [
      {"creatorId": "user1", "assignedId": "user2"},
      {"creatorId": "user3", "assignedId": ""},
      {"creatorId": "", "assignedId": "user4"},
      {"creatorId": "user5", "assignedId": null},
    ];

    state_assign.uuid = "user2";

    expect(state_assign.findAssigned(), "user1");

    state_assign.conversation = [
      {"creatorId": "", "assignedId": "user3"},
      {"creatorId": "user3", "assignedId": ""},
      {"creatorId": "", "assignedId": "user4"},
      {"creatorId": "user5", "assignedId": null},
    ];

    state_assign.uuid = "user2";

    expect(state_assign.findAssigned(), "user3");

    state_assign.conversation = [
      {"creatorId": "", "assignedId": ""},
      {"creatorId": "", "assignedId": ""},
      {"creatorId": "", "assignedId": ""},
      {"creatorId": "", "assignedId": null},
    ];

    state_assign.uuid = "user2";

    expect(state_assign.findAssigned(), "");

    final result = await state_assign.createTicket(
      title: 'Test ticket',
      assignedId: 'assigned_user_id',
    );

    expect(result, false);

    final result2 = await state_assign.assignTicket(
      tickets: tickets2,
    );
    expect(result2, false);

    final state_tickets =
        tester.state(find.byType(TicketsPage)) as TicketsState;

    Map<String, dynamic> tickets_sort = {
      'category1': [
        {"createdAt": "2024-05-16T10:00:00Z"},
        {"createdAt": "2024-05-16T08:00:00Z"},
        {"createdAt": "2024-05-16T09:00:00Z"},
      ],
      'category2': [
        {"createdAt": "2024-05-16T14:00:00Z"},
        {"createdAt": "2024-05-16T12:00:00Z"},
        {"createdAt": "2024-05-16T13:00:00Z"},
      ],
    };

    // Appeler la fonction pour trier les tickets
    state_tickets.sortTickets(tickets_sort);

    // Vérifier si les tickets sont triés correctement
    expect(tickets_sort['category1'][0]["createdAt"], "2024-05-16T08:00:00Z");
    expect(tickets_sort['category1'][1]["createdAt"], "2024-05-16T09:00:00Z");
    expect(tickets_sort['category1'][2]["createdAt"], "2024-05-16T10:00:00Z");

    expect(tickets_sort['category2'][0]["createdAt"], "2024-05-16T12:00:00Z");
    expect(tickets_sort['category2'][1]["createdAt"], "2024-05-16T13:00:00Z");
    expect(tickets_sort['category2'][2]["createdAt"], "2024-05-16T14:00:00Z");

    state_tickets.isAdmin = true;
    await tester.pump();

    state_assign.conversation = [
      {
        "title": "Ticket 1",
        "content": "Contenu 1",
        "creatorId": "",
        "assignedId": "",
        "createdAt": "2024-05-16T14:00:00Z",
      },
      {
        "title": "Ticket 2",
        "content": "Contenu 2",
        "creatorId": "",
        "assignedId": "",
        "createdAt": "2024-05-16T14:00:00Z",
      },
      {
        "title": "Ticket 3",
        "content": "Contenu 3",
        "creatorId": "",
        "assignedId": "",
        "createdAt": "2024-05-16T14:00:00Z",
      },
      {
        "title": "Ticket 4",
        "content": "Contenu 4",
        "creatorId": "",
        "assignedId": "",
        "createdAt": "2024-05-16T14:00:00Z",
      },
    ];

    state_assign.openedTickets = {
      "123": [
        {
          "id": 1,
          "title": "Ticket 1",
          "content": "Contenu 1",
          "creatorId": "user2",
          "assignedId": "",
          "createdAt": "2024-05-16T14:00:00Z",
          "chatUid": "123"
        },
        {
          "id": 2,
          "title": "Ticket 1",
          "content": "Contenu 2",
          "creatorId": "",
          "assignedId": "user2",
          "createdAt": "2024-05-16T14:00:00Z",
          "chatUid": "123"
        },
      ]
    };

    state_assign.closedTickets = {
      "124": [
        {
          "id": 3,
          "title": "Ticket 1",
          "content": "Contenu 1",
          "creatorId": "user2",
          "assignedId": "",
          "createdAt": "2024-05-16T14:00:00Z",
          "chatUid": "124"
        },
        {
          "id": 4,
          "title": "Ticket 1",
          "content": "Contenu 2",
          "creatorId": "",
          "assignedId": "user2",
          "createdAt": "2024-05-16T14:00:00Z",
          "chatUid": "124"
        },
      ]
    };
    await tester.tap(find.byKey(const Key("ticket-state-open")));
    await tester.pump();

    await tester.tap(find.byKey(const Key("ticket-state-closed")));
    await tester.pump();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
