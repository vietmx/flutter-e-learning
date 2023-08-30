import 'package:elearning/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:elearning/ui/pages/navmenu/menu_dashboard_layout.dart';
import 'package:elearning/ui/pages/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiServiceLogin apiService =
      ApiServiceLogin(); // Instantiate the ApiService
  bool _showPassword = false; // Track password visibility
  String _errorMessage = ''; // Error message holder
  String _emptyFieldErrorMessage = 'This field is required';

  Future<void> _loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    setState(() {
      _errorMessage = ''; // Clear previous error message
    });

    bool _validateFields() {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      return email.isNotEmpty && password.isNotEmpty;
    }

    // Inside the _loginUser() function:
    if (!_validateFields()) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Logging In'),
          content: CupertinoActivityIndicator(),
        );
      },
    );

    try {
      final response =
          await apiService.loginUser(email: email, password: password);
      Navigator.pop(context); // Close the loading indicator dialog

      if (response.containsKey('token')) {
        // Store the token using shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', response['token']);

        final token = response['token']; // Use the correct variable here

        // Navigate to MenuDashboardLayout on successful login
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => MenuDashboardLayout(userToken: token),
          ),
        );
      } else if (response.containsKey('message')) {
        if (response['message'] == 'Wait for admin approval.') {
          // Navigate to waiting screen
          Navigator.pushReplacementNamed(context, '/waiting');
        } else {
          setState(() {
            _errorMessage = response['message'];
          });
        }
      } else {
        // Handle login error
        setState(() {
          _errorMessage = 'Login Error: ${response['error']}';
        });
      }
    } catch (e) {
      // Handle API call error
      print('Error: $e');
      Navigator.pop(context); // Close the loading indicator dialog
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
      print('Error Message: $_errorMessage'); // Add this print
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CupertinoColors.systemBlue,
                  CupertinoColors.systemIndigo,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/images/wave.png'),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/logo.png'),
                  SizedBox(
                    height: 30.0,
                  ),
                  CupertinoTextField(
                    controller: _emailController,
                    placeholder: 'Email',
                    style: TextStyle(
                      color: CupertinoTheme.brightnessOf(context) ==
                              Brightness.light
                          ? CupertinoColors.black
                          : CupertinoColors.white,
                    ),
                  ),
                  if (_errorMessage.isNotEmpty && _emailController.text.isEmpty)
                    Text(
                      _emptyFieldErrorMessage,
                      style: TextStyle(
                        color: CupertinoColors.destructiveRed,
                        fontSize: 12.0,
                      ),
                    ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CupertinoTextField(
                    controller: _passwordController,
                    placeholder: 'Password',
                    obscureText: !_showPassword,
                    style: TextStyle(
                      color: CupertinoTheme.brightnessOf(context) ==
                              Brightness.light
                          ? CupertinoColors.black
                          : CupertinoColors.white,
                    ),
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        child: Icon(
                          _showPassword
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          color: CupertinoTheme.brightnessOf(context) ==
                                  Brightness.light
                              ? CupertinoColors.black
                              : CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty &&
                      _passwordController.text.isEmpty)
                    Text(
                      _emptyFieldErrorMessage,
                      style: TextStyle(
                        color: CupertinoColors.destructiveRed,
                        fontSize: 12.0,
                      ),
                    ),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(
                        color: CupertinoColors.destructiveRed,
                        fontSize: 14.0,
                      ),
                    ),
                  SizedBox(
                    height: 30.0,
                  ),
                  CupertinoButton(
                    color: CupertinoColors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Sign in ➡",
                          style: TextStyle(
                            fontFamily: 'Red Hat Display',
                            fontSize: 16,
                            color: CupertinoColors.systemBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: _loginUser,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  CupertinoButton(
                    child: Text(
                      "Don't have an account? Sign up!",
                      style: TextStyle(
                        fontFamily: 'Red Hat Display',
                        fontSize: 14,
                        color: CupertinoColors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => RegistrationPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
