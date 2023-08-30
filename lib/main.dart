import 'package:elearning/ui/pages/login.dart';
import 'package:elearning/ui/pages/navmenu/menu_dashboard_layout.dart';
import 'package:elearning/ui/pages/onboarding1.dart';
import 'package:elearning/ui/pages/undefinedScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elearning/routes/router.dart' as router;
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  if (showOnboarding) {
    await prefs.setBool('showOnboarding', false);
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
            RestartWidget(
              child: MyApp(showOnboarding: showOnboarding),
            ),
          ));
}


class MyApp extends StatelessWidget {
  final bool showOnboarding;

  MyApp({required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: router.generateRoute,
      onUnknownRoute: (settings) => CupertinoPageRoute(
        builder: (context) => UndefinedScreen(
          name: settings.name,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String>(
        future: SharedPreferences.getInstance().then((prefs) {
          return prefs.getString('token') ?? ''; // Get the stored token
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Future is still loading
            return CupertinoActivityIndicator();
          } else {
            // Future has completed
            final token = snapshot.data ?? '';

            // Based on the token, decide which screen to show
            if (token.isNotEmpty) {
              // User is logged in, show MenuDashboardLayout
              return MenuDashboardLayout(userToken: token);
            } else {
              // User is not logged in, show LoginPage
              return showOnboarding ? Onboarding() : LoginPage();
            }
          }
        },
      ),
    );
  }
}



class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}
