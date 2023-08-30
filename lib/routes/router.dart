import 'package:elearning/routes/routing_constants.dart';
// import 'package:elearning/ui/pages/home.dart';
import 'package:elearning/ui/pages/registration.dart';
import 'package:elearning/ui/pages/undefinedScreen.dart';
import 'package:elearning/ui/pages/waiting_page.dart';
import 'package:flutter/cupertino.dart';

List<String> navStack = ["Home"];

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
  //   case HomeRoute:
  // navStack.add("Home");
  // print(navStack);
  // return CupertinoPageRoute(builder: (context) => Home(
  //   onMenuTap: /* Your onMenuTap function */,
  //   user: /* Your User object */, // Pass the user object here
  // ));


    case RegistrationRoute:
      return CupertinoPageRoute(builder: (_) => RegistrationPage());

    case WaitingRoute:
      return CupertinoPageRoute(builder: (_) => WaitingPage());

    // Add more cases for other routes here

    default:
      navStack.add("undefined");
      print(navStack);
      return CupertinoPageRoute(
        builder: (context) => UndefinedScreen(
          name: settings.name,
        ),
      );
  }
}
