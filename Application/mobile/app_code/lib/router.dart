import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/signup/signup_page.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/profile/profile_page.dart';
import 'package:risu/pages/pre_auth/pre_auth_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
      ],
    ),
  ],
);
