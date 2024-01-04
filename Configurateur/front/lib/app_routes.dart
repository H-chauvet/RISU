import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/screens/admin/admin.dart';
import 'package:front/screens/container-creation/payment_screen.dart';
import 'package:front/screens/container-list/container_list.dart';
import 'package:front/screens/feedbacks/feedbacks.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/screens/login/login.dart';
import 'package:front/screens/messages/messages.dart';
import 'package:front/screens/profile/profile_page.dart';
import 'package:front/screens/recap-config/recap_config.dart';
import 'package:front/screens/password-recuperation/password-recuperation.dart';
import 'package:front/screens/password-recuperation/password_change.dart';
import 'package:front/screens/register-confirmation/confirmed_user.dart';
import 'package:front/screens/register-confirmation/register_confirmation.dart';
import 'package:front/screens/register/register.dart';
import 'package:front/screens/container-creation/container_creation.dart';
import 'package:front/screens/contact/contact.dart';
import 'package:front/screens/confidentiality/confidentiality.dart';
import 'package:front/screens/company/company.dart';
import 'package:front/screens/user-list/user_list.dart';
import 'package:go_router/go_router.dart';

///
/// App router
///
/// Gestion des routes de l'application
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LandingPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register-confirmation',
        builder: (BuildContext context, GoRouterState state) {
          final mail = state.extra! as String;
          return RegisterConfirmation(
            params: mail,
          );
        },
      ),
      GoRoute(
        path: '/confirmed-user/:id',
        pageBuilder: (context, state) {
          final param = state.pathParameters['id'].toString();
          return NoTransitionPage(
            child: ConfirmedUser(
              params: param,
            ),
          );
        },
      ),
      GoRoute(
        path: '/landingPage',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LandingPage(),
        ),
      ),
      GoRoute(
        path: '/password-recuperation',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: PasswordRecuperation(),
        ),
      ),
      GoRoute(
        path: '/password-change/:id',
        pageBuilder: (context, state) {
          final param = state.pathParameters['id'].toString();
          return NoTransitionPage(
            child: PasswordChange(
              params: param,
            ),
          );
        },
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfilePage(),
        ),
      ),
      GoRoute(
        path: '/recap-config',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RecapConfigPage(),
        ),
      ),
      GoRoute(
          path: '/container-creation',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ContainerCreation())),
      GoRoute(
        path: '/container-creation/payment',
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra! as String;
          final user = jsonDecode(data) as Map<String, dynamic>;

          return PaymentScreen(
            amount: user['amount'],
            containerMapping: user['containerMapping'],
          );
        },
      ),
      GoRoute(
        path: '/contact',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ContactPage(),
        ),
      ),
      GoRoute(
        path: '/confidentiality',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ConfidentialityPage(),
        ),
      ),
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AdminPage(),
        ),
      ),
      GoRoute(
        path: '/admin/messages',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MessagePage(),
        ),
      ),
      GoRoute(
        path: '/containerList',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ContainerPage(),
        ),
      ),
      GoRoute(
        path: '/userList',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: UserPage(),
        ),
      ),
      GoRoute(
        path: '/company',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CompanyPage(),
        ),
      ),
      GoRoute(
        path: '/feedbacks',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: FeedbacksPage(),
        ),
      ),
    ],
  );

  static GoRouter get router => _router;
}
