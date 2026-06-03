import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_template/pages/home/views/home_page/home_page.dart';


void main() {
  // Ekran o'lchamlarini belgilab olamiz
  final kichikEkran = const Size(320, 568); // iPhone SE 1st gen (Juda kichik ekran)
  final kattaEkran = const Size(430, 932);  // iPhone 16 Pro Max / Zamonaviy Android

  group("Home Screen ekran sig'uvchanligi testlari", () {
    
    testWidgets("Kichik ekranda (320x568) hech qanday Overflow (sig'may qolish) xatoligi bo'lmasligi kerak", (WidgetTester tester) async {
      // 1. Test muhitidagi ekran o'lchamini kichik ekranga majburlab moslaymiz
      tester.view.physicalSize = kichikEkran;
      tester.view.devicePixelRatio = 1.0; // Piksellar nisbati

      // 2. Vidjetni yurgizamiz
      await tester.pumpWidget(const MaterialApp(
        home: HomeScreen(),
      ));

      // 3. To'liq chizilishini kutamiz
      await tester.pumpAndSettle();

      // Flutter test motori agar ekranda sariq-qora chiziqli "Overflow" xatosi chiqsa,
      // ushbu testni avtomatik ravishda yikitadi (FAIL qiladi).
      // Agar xato chiqmasa, test muvaffaqiyatli o'tadi (PASS).
    });

    testWidgets("Katta ekranda (430x932) dizayn to'g'ri chizilishi kerak", (WidgetTester tester) async {
      // Katta ekran uchun ham xuddi shunday tekshiruv
      tester.view.physicalSize = kattaEkran;
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
    });
  });
}