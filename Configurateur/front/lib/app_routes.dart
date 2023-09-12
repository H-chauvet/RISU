import 'package:flutter/material.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/screens/login/login.dart';
import 'package:front/screens/profile/profile_page.dart';
import 'package:front/screens/recap-config/recap_config.dart';
import 'package:front/screens/password-recuperation/password-recuperation.dart';
import 'package:front/screens/password-recuperation/password_change.dart';
import 'package:front/screens/register-confirmation/confirmed_user.dart';
import 'package:front/screens/register-confirmation/register_confirmation.dart';
import 'package:front/screens/register/register.dart';
import 'package:go_router/go_router.dart';
import './main.dart';
import './contact_form/contact_form.dart';

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
          child: MyHomePage(title: 'home'),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MyHomePage(title: 'home'),
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
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RegisterConfirmation(params: ''),
        ),
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
        pageBuilder: (context, state) => NoTransitionPage(
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
      // GoRoute(
      //   path: '/contact',
      //   pageBuilder: (context, state) => MaterialPage(
      //     child: ContactPage(),
      //   ),
      // ),
    ],
  );

  static GoRouter get router => _router;
}
