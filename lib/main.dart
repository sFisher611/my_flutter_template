import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_flutter_template/app/bloc/locale_bloc.dart';
import 'package:my_flutter_template/app/bloc/theme_bloc.dart';
import 'package:my_flutter_template/app/routes.dart';
import 'package:my_flutter_template/app/services/navigation_service.dart';
import 'package:my_flutter_template/app/theme.dart';

import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  Box box = await Hive.openBox('db');
  GetIt.I.registerSingleton<Box>(box);
  GetIt.I.registerSingleton<NavigationService>(NavigationService());
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 840),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => LocaleBloc()),
            BlocProvider(create: (context) => ThemeBloc()),
          ],
          child: BlocBuilder<LocaleBloc, Locale>(
            builder: (context, currentLocale) {
              return BlocBuilder<ThemeBloc, ThemeMode>(
                builder: (context, currentThemeMode) {
                  return MaterialApp.router(
                    title: 'Universal Template',
                    debugShowCheckedModeBanner: false,

                    locale: currentLocale,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('uz'),
                      Locale('ru'),
                      Locale('en'),
                    ],
                    routerConfig: AppRouter.appRouter,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: currentThemeMode,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
