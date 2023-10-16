import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:risu/pages/Settings/settings_page.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/pages/history_location/history_page.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/parameters/parameters_page.dart';
import 'package:risu/pages/pre_auth/pre_auth_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/profile/profile_page.dart';
import 'package:risu/pages/signup/signup_page.dart';

/// The project router.
/// When you want to add a new page, please refer his url here.
/// Don't forget to add a goTo**Page function in her _functional file.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const PreAuthPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignupPage();
          },
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfilePage();
          },
        ),
        GoRoute(
          path: 'profile/informations',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileInformationsPage();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'parameters',
          builder: (BuildContext context, GoRouterState state) {
            return const ParametersPage();
          },
        ),
        GoRoute(
          path: 'history-location',
          builder: (BuildContext context, GoRouterState state) {
            return HistoryLocationPage();
          },
        ),
        GoRoute(
          path: 'contact',
          builder: (BuildContext context, GoRouterState state) {
            return const ContactPage();
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsPage();
          },
        ),
      ],
    ),
  ],
);
