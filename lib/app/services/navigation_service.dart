import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext getContext() => navigatorKey.currentState!.overlay!.context;
}

getSized() {
  return MediaQuery.of(GetIt.I.get<NavigationService>().getContext()).size;
}

