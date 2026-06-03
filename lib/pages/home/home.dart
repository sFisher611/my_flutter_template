import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_template/l10n/app_localizations.dart';


class Home extends StatefulWidget {
  const Home({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectIndex = 0;
  DateTime? _lastPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (value) {
        if (value) {
          return;
        }
        DateTime now = DateTime.now();
        if (_lastPressed == null ||
            now.difference(_lastPressed!) > Duration(seconds: 2)) {
          _lastPressed = now;
          Fluttertoast.showToast(msg: 'Chiqish uchun yana bir marta bosing');
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: widget.navigationShell,

        bottomNavigationBar: BottomNavigationBar(
          // selectedItemColor: AppTheme.,
          type: BottomNavigationBarType.fixed,
          enableFeedback: false,
          unselectedFontSize: 10,
          selectedFontSize: 10,
          currentIndex: _selectIndex,
          onTap: (value) {
            _selectIndex = value;
            widget.navigationShell.goBranch(
              _selectIndex,
              initialLocation:
                  _selectIndex == widget.navigationShell.currentIndex,
            );
            // if (value == 1) {
            //   context.read<HomeBloc>().add(const HomeBronOrdersEvent());
            // }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: AppLocalizations.of(context)!.search,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
        ),
      ),
    );
  }
}
