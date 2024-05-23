import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wascan_soil_secrets/blocs/config_bloc/config_bloc.dart';
import 'package:wascan_soil_secrets/blocs/game_bloc/game_bloc.dart';
import 'package:wascan_soil_secrets/screens/screens.dart';
import 'package:wascan_soil_secrets/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferenceService().init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runZonedGuarded(
      () => runApp(
            ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (BuildContext context, Widget? child) => MyApp(),
            ),
          ), (error, stack) {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stack);
  });
}

CustomTransitionPage buildPageWithDefaultTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 100),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return NavigationScreen(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              child: const GameScreen(),
              context: context,
              state: state,
            ),
          ),
          GoRoute(
            path: '/shop_screen',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              child: const ShopScreen(),
              context: context,
              state: state,
            ),
            routes: [
              GoRoute(
                path: "backgroundSkins",
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: const BackgroundSkinsScreen(),
                ),
              ),
              GoRoute(
                path: 'player_skins_screen',
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  child: const PlayerSkinsScreen(),
                  context: context,
                  state: state,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/settings_screen',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              child: SettingsScreen(),
              context: context,
              state: state,
            ),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PreferenceService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return ConfigBloc(
                RepositoryProvider.of(context),
              )..add(
                  InitConfigEvent(),
                );
            },
          ),
          BlocProvider(
            create: (context) {
              return GameBloc(BlocProvider.of(context))
                ..add(
                  InitGameEvent(),
                );
            },
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
        ),
      ),
    );
  }
}
