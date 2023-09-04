import 'package:elearning/services/user_details_api_client.dart';
import 'package:elearning/theme/config.dart' as config;
import 'package:elearning/ui/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:elearning/ui/pages/navmenu/dashboard.dart';

import 'menu.dart';

final Color backgroundColor = Colors.lightBlue;

class MenuDashboardLayout extends StatefulWidget {
  final String userToken; // Pass the user token to this screen
  MenuDashboardLayout({required this.userToken});
  @override
  _MenuDashboardLayoutState createState() => _MenuDashboardLayoutState();
}

const String baseURL = "http://10.0.2.2:8000/api";

class _MenuDashboardLayoutState extends State<MenuDashboardLayout>
    with SingleTickerProviderStateMixin {
  User? user; // Define the variable to hold user details
  bool isCollapsed = true;
  double? screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 200);
  late AnimationController _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _menuScaleAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.75).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    // Fetch user details here
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    try {
      final userDetails = await UserDetailsApiClient(baseUrl: baseURL)
          .getUserDetails(widget.userToken);
      if (userDetails.containsKey('user') && userDetails['user'] != null) {
        print('User JSON: ${userDetails['user']}');
        user =
            User.fromJson(userDetails['user']); // Assign fetched user details
      } else {
        print('User JSON is null or not present.');
      }

      print('User Details Response: $userDetails'); // Log the response details

      // Print the entire userDetails map
      print('User Details Map: $userDetails');

      setState(() {
        user =
            User.fromJson(userDetails['user']); // Assign fetched user details
      });
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onMenuTap() {
    setState(() {
      if (isCollapsed)
        _controller.forward();
      else
        _controller.reverse();

      isCollapsed = !isCollapsed;
    });
  }

  void onMenuItemClicked() {
    setState(() {
      _controller.reverse();
    });

    isCollapsed = !isCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: config.Colors().waves,
            ),
          ),
          Menu(
              onMenuTap: onMenuTap,
              slideAnimation: _slideAnimation,
              menuAnimation: _menuScaleAnimation,
              onMenuItemClicked: onMenuItemClicked),
          Dashboard(
            duration: duration,
            onMenuTap: onMenuTap,
            scaleAnimation: _scaleAnimation,
            isCollapsed: isCollapsed,
            screenWidth: screenWidth,
            child: user != null
                ? Home(
                    onMenuTap: onMenuTap,
                    user: user!,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
