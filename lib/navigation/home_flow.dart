import 'package:blood_glucose_monitor/controllers/chat_controller.dart';
import 'package:blood_glucose_monitor/navigation/routes.dart';
import 'package:blood_glucose_monitor/pages/home/chat.dart';
import 'package:blood_glucose_monitor/pages/home/home.dart';
import 'package:blood_glucose_monitor/pages/home/tests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeFlow extends StatelessWidget {
  HomeFlow({super.key});

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      initialRoute: Routes.home,
      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == Routes.tests) {
          page = TestsPage();
        } else if (settings.name == Routes.chat) {
          page = ChangeNotifierProvider(
            create: (_) => ChatController(),
            child: ChatPage(),
          );
        } else {
          page = HomePage();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
