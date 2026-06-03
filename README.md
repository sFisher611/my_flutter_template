# My template
EscF12 2020©
## 📦 5. Ishlatilgan Paketlar (Dependencies) va Ularning Vazifalari

Shablonning poydevori mustahkam, tez va xavfsiz bo‘lishi uchun eng ishonchli va jamiyat (community) tomonidan tan olingan paketlar tanlab olindi:

### 🌟 State Management & DI (Holatni boshqarish)
* **`flutter_bloc` & `bloc`**: Ilovaning arxitekturasini interfeysdan (UI) butunlay ajratish, holatlarni (Theme, Locale, Ma'lumotlar oqimi) toza va oson boshqarish uchun markaziy tizim.
* **`get_it`**: Servislarni (`ApiProvider`, `NavigationService`) global ro‘yxatdan o‘tkazish va ilovaning istalgan joyida ularni chaqirib ishlatish (Dependency Injection) uchun xizmat qiladi.

### 🌐 Network & Debugging (Tarmoq va Kuzatuv)
* **`dio`**: HTTP so‘rovlar (`GET`, `POST`, `PUT`, `DELETE`) yuborish, interceptorlar qo‘shish, fayllarni progress bar bilan yuklash va xavfsiz Stream oqimlarini boshqarish uchun eng qudratli tarmoq paketi.
* **`flutter_alice`**: Faqat *Debug* rejimida ishlovchi, barcha tarmoq so‘rovlari va server javoblarini (API Logs) bevosita telefon ekranida chiroyli ko‘rinishda kuzatish uchun tarmoq inspektori.

### 💾 Local Storage (Mahalliy xotira)
* **`hive` & `hive_flutter`**: Ilova sozlamalari (Tungi rejim holati, tanlangan til) va foydalanuvchi tokenini (`Auth Token`) telefonda xavfsiz va juda tez (NoSQL formatida) saqlash uchun ishlatiladi.

### 🗺️ Navigation & UI Enhancements (Navigatsiya va Vizual)
* **`go_router`**: Deklarativ navigatsiya tizimi. Sahifalararo o‘tishlar, chuqur havolalar (`Deep Linking`) va `BottomNavigationBar` ichidagi vkladkalarni xavfsiz boshqarishni ta'minlaydi.
* **`shimmer`**: Serverdan ma'lumotlar yuklanayotgan vaqtda kulrang chiroyli skelet yuklagichlarni (`Skeleton Loader`) hosil qilish orqali UI jozibadorligini oshiradi.

---

## 🚀 6. Ushbu Shablon Sizga Qanday Imkoniyatlar Beradi?

1.  **Noldan boshlash daxshatidan qutulish:** Yangi g‘oya kelganda, sozlamalarni (til, mavzu, network, router) noldan yozishga 2-3 kun sarflamaysiz. Loyihani yuklab, srazu biznes logikani yozishni boshlaysiz.
2.  **Universal Dizayn Tizimi (Dark/Light):** Ranglar va stillar markaziy `ThemeData`ga bog‘langanligi sababli, dizayn o‘zgarishi butun ilova bo‘ylab bir lahzada aks etadi.
3.  **Tayyor Tarjima Poydevori:** Yangi til qo‘shish shunchaki `l10n/` papkasiga yangi JSON fayl (masalan, `zh.json`) qo‘shish bilan hal bo‘ladi.
4.  **AI Loyihalariga To‘liq Moslik:** `ApiProvider` ichidagi bufferli stream tizimi tufayli loyihaga ChatGPT yoki sizning shaxsiy *Hunter AI* kabi LLM modellarini ulash va javoblarni ekranda silliq chizish imkoniyati 100% tayyor.

```
.
├── android
├── assets
│   ├── fonts
│   ├── icons
│   └── images
├── ios
├── lib
│   ├── app
│   │   ├── bloc
│   │   │   ├── locale_bloc.dart
│   │   │   └── theme_bloc.dart
│   │   ├── services
│   │   │   └── navigation_service.dart
│   │   ├── routes.dart
│   │   └── theme.dart
│   ├── l10n
│   │   ├── app_en.arb
│   │   ├── app_localizations.dart
│   │   ├── app_ru.arb
│   │   └── app_uz.arb
│   ├── pages
│   │   ├── home
│   │   │   └── home_page.dart
│   │   └── splash
│   │       └── splash_page.dart
│   └── main.dart
├── pubspec.lock
├── pubspec.yaml
└── README.md
```

## IOS refresh
```
flutter clean
flutter pub get
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf Runner.xcworkspace

pod deintegrate
pod cache clean --all
pod install
cd ..
```

```
flutter build apk --release --target-platform android-arm64
```