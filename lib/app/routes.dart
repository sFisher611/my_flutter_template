import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_template/app/services/navigation_service.dart';
import 'package:my_flutter_template/pages/page_export.dart';


class AppRouter {
  static final GoRouter appRouter = GoRouter(
    navigatorKey: GetIt.I<NavigationService>().navigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',

        pageBuilder: (context, state) {
          return animatedNextPage(state: state, child: SplashScreen());
        },
      ),
      // GoRoute(
      //   path: '/voice',
      //   name: 'voice',

      //   pageBuilder: (context, state) {
      //     return animatedDownPage(state: state, child: VoicePage());
      //   },
      // ),
     
      // GoRoute(
      //   path: '/filter',
      //   name: 'filter',

      //   pageBuilder: (context, state) {
      //     return CupertinoPage(
      //       key: state.pageKey,
      //       child: FilterPage(dataFilter: state.extra),
      //     );
      //   },
      // ),
     
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            Home(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home_page',
                name: 'home_page',
                builder: (context, state) => HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => SearchScreen(),
              ),
            ],
          ),
        
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => ProfileScreen(),
              ),
            ],
          ),
        
        ],
      ),
     
    ],
  );

  static CustomTransitionPage<dynamic> animatedNextPage({
    required GoRouterState state,
    child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation = CurvedAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          parent: animation,
          reverseCurve: Curves.linear,
        );
        return SlideTransition(
          position: Tween(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(animation),

          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<dynamic> animatedDownPage({
    required GoRouterState state,
    child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation = CurvedAnimation(
          curve: Curves.easeOutCubic,
          parent: animation,
          reverseCurve: Curves.linear,
        );
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizeTransition(
            axisAlignment: 0,
            sizeFactor: animation,
            child: child,
          ),
        );
      },
    );
  }
}
