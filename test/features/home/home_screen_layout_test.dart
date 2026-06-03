import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_template/l10n/app_localizations.dart';
import 'package:my_flutter_template/pages/home/views/home_page/home_page.dart'; 

void main() {
  final kichikEkran = const Size(320, 568);
  final kattaEkran = const Size(430, 932);

  // Har bir testda MaterialAppni takrorlamaslik uchun universal helper vidjet
  Widget createHomeScreenForTest() {
    return MaterialApp(
      // 1. Test muhitiga tarjima delegatlarini beramiz
      localizationsDelegates: const [
        AppLocalizations.delegate, // Biz yaratgan JSON loader delegate
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uz'),
        Locale('ru'),
        Locale('en'),
      ],
      locale: const Locale('uz'), // Test qaysi tilda tekshirilishini belgilaymiz
      home: const HomeScreen(),
    );
  }

  group('Home Screen ekran sig\'uvchanligi testlari', () {
    
    testWidgets('Kichik ekranda (320x568) hech qanday Overflow xatoligi bo\'lmasligi kerak', (WidgetTester tester) async {
      tester.view.physicalSize = kichikEkran;
      tester.view.devicePixelRatio = 1.0;

      // Boyagi narsani o'rniga helper funksiyamizni chaqiramiz
      await tester.pumpWidget(createHomeScreenForTest());
      await tester.pumpAndSettle();
    });

    testWidgets('Katta ekranda (430x932) dizayn to\'g\'ri chizilishi kerak', (WidgetTester tester) async {
      tester.view.physicalSize = kattaEkran;
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createHomeScreenForTest());
      await tester.pumpAndSettle();
    });
  });
}