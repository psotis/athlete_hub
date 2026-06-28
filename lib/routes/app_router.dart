import 'package:athlete_hub/blocs/auth/auth_bloc.dart';
import 'package:athlete_hub/helpers/imports.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppRouter {
  late final AuthBloc authBloc;
  late final GoRouter router;
  AppRouter({required this.authBloc}) {
    router = GoRouter(
      refreshListenable: GoRouterRefreshStream(authBloc.stream),

      redirect: (context, state) {
        debugPrint(
          'AUTH STATE: ${authBloc.state.runtimeType}, loc=${state.matchedLocation}',
        );
        final authState = authBloc.state;
        final loggedIn = authBloc.state is AuthAuthenticated;
        final loc = state.matchedLocation;
        final onLanding = loc == Routes.landing;
        final onSplash = loc == Routes.splash;
        final onLogin = loc == Routes.login;
        final onSignup = loc == Routes.signup;
        final isChecking =
            authState is AuthInitial || authState is AuthChecking;

        if (onLanding && !kIsWeb) return Routes.splash;

        if (isChecking) {
          if (onLanding || onSplash || onLogin || onSignup) return null;
          return Routes.splash;
        }

        if (onSplash) {
          return loggedIn ? Routes.dashboard : Routes.login;
        }

        if (!loggedIn) {
          if (onLanding || onLogin || onSignup) return null;
          return Routes.login;
        }

        // if (!loggedIn && !onLogin) return Routes.login;
        // if (loggedIn && onLogin) return Routes.home;

        if (onLogin || onSignup) return Routes.dashboard;

        return null;
      },

      routes: [
        GoRoute(
          path: Routes.landing,
          builder: (context, state) => const LandingPage(),
        ),
        GoRoute(
          path: Routes.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: Routes.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: Routes.signup,
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: Routes.dashboard,
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: Routes.health,
          builder: (context, state) => const HealthPage(),
        ),
        GoRoute(
          path: Routes.healthCustomerSearch,
          builder: (context, state) => const HealthCustomerSearchPage(),
        ),
      ],
      initialLocation: Routes.landing,
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// import 'package:pro/blocs/auth/auth_bloc.dart';
// import 'package:pro/helpers/imports.dart';

// class AppRouter {
//   final SecureTokenStorage tokenStorage = SecureTokenStorage();
//   late final AuthBloc authBloc;
//   late final GoRouter router;
//   AppRouter() {
//     authBloc = AuthBloc(tokenStorage: tokenStorage)..add(const AuthStarted());
//     setupDioInterceptors(
//       getToken: () => tokenStorage.getToken(),
//       onUnauthorized: () => authBloc.add(const AuthLoggedOut()),
//     );

//     router = GoRouter(
//       refreshListenable: GoRouterRefreshStream(authBloc.stream),

//       redirect: (context, state) {
//         debugPrint(
//           'AUTH STATE: ${authBloc.state.runtimeType}, loc=${state.matchedLocation}',
//         );
//         final loc = state.matchedLocation;
//         final onSplash = loc == Routes.splash;
//         final onLogin = loc == Routes.login;

//         if (onSplash) return null;
//         final loggedIn = authBloc.state is AuthAuthenticated;

//         if (!loggedIn && !onLogin) return Routes.login;
//         if (loggedIn && onLogin) return Routes.home;

//         return null;
//       },

//       routes: [
//         GoRoute(
//           path: Routes.splash,
//           builder: (context, state) => const SplashPage(),
//         ),
//         GoRoute(
//           path: Routes.login,
//           builder: (context, state) => const LoginPage(),
//         ),
//         GoRoute(
//           path: Routes.home,
//           builder: (context, state) => const HomePage(),
//         ),
//       ],
//       initialLocation: Routes.splash,
//     );
//   }
// }

// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<dynamic> stream) {
//     _sub = stream.listen((_) => notifyListeners());
//   }
//   late final StreamSubscription<dynamic> _sub;

//   @override
//   void dispose() {
//     _sub.cancel();
//     super.dispose();
//   }
// }
