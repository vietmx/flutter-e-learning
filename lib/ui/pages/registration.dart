import 'package:elearning/services/api_service.dart';
import 'package:elearning/ui/pages/login.dart';
import 'package:flutter/cupertino.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final ApiServiceRegister apiService =
      ApiServiceRegister(); // Define apiService instance
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _errorText;
  bool _passwordVisible = false;

  void _registerUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorText = 'All fields are required';
      });
      return;
    }
    if (!_isPasswordMatching()) {
      setState(() {
        _errorText = 'Passwords do not match';
      });
      return;
    }
    // Show loading indicator
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Registering User'),
          content: CupertinoActivityIndicator(),
        );
      },
    );
    try {
      final response = await apiService.registerUser(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
      );

      Navigator.pop(context); // Close the loading indicator dialog

      if (response.containsKey('error')) {
        if (response['error']['email'] != null) {
          setState(() {
            _errorText = response['error']['email'][0];
          });
        } else {
          setState(() {
            _errorText = 'Registration failed. Please check your inputs.';
          });
        }
      } else {
        Navigator.pushReplacementNamed(context, '/waiting');
      }
    } catch (e) {
      Navigator.pop(context); // Close the loading indicator dialog
      print('Error: $e');
      setState(() {
        _errorText = 'An error occurred. Please try again later.';
      });
    }
  }

  bool _isPasswordMatching() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false, // Prevent keyboard overlap
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
                    height: 20.0,
                  ),
                  CupertinoTextField(
                    controller: _nameController,
                    placeholder: 'Name',
                    style: TextStyle(
                      color: CupertinoTheme.brightnessOf(context) ==
                              Brightness.light
                          ? CupertinoColors.black
                          : CupertinoColors.white,
                    ),
                    onChanged: (value) {
                      // Validate the name field
                      setState(() {
                        _errorText = value.isEmpty ? 'Name is required' : null;
                      });
                    },
                  ),
                  SizedBox(
                    height: 16.0,
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
                  SizedBox(
                    height: 16.0,
                  ),
                  CupertinoTextField(
                    controller: _phoneController,
                    placeholder: 'Phone Number',
                    style: TextStyle(
                      color: CupertinoTheme.brightnessOf(context) ==
                              Brightness.light
                          ? CupertinoColors.black
                          : CupertinoColors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CupertinoTextField(
                    controller: _addressController,
                    placeholder: 'User Address',
                    style: TextStyle(
                      color: CupertinoTheme.brightnessOf(context) ==
                              Brightness.light
                          ? CupertinoColors.black
                          : CupertinoColors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CupertinoTextField(
                    controller: _passwordController,
                    placeholder: 'Password',
                    obscureText: !_passwordVisible,
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
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        child: Icon(
                          _passwordVisible
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
                  SizedBox(
                    height: 16.0,
                  ),
                  CupertinoTextField(
                    controller: _confirmPasswordController,
                    placeholder: 'Confirm Password',
                    obscureText: !_passwordVisible,
                    style: TextStyle(
                      color: CupertinoTheme.brightnessOf(context) ==
                              Brightness.light
                          ? CupertinoColors.black
                          : CupertinoColors.white,
                    ),
                  ),
                  // SizedBox(
                  //   height: 10.0,
                  // ),
                  // if (!_isPasswordMatching())
                  //   Text(
                  //     'Passwords do not match',
                  //     style: TextStyle(color: CupertinoColors.systemRed),
                  //   ),
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
                          "Register ➡",
                          style: TextStyle(
                            fontFamily: 'Red Hat Display',
                            fontSize: 16,
                            color: CupertinoColors.systemBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: _registerUser,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (_errorText != null)
                    Text(
                      _errorText!,
                      style: TextStyle(color: CupertinoColors.systemRed),
                    ),
                  SizedBox(
                    height: 10.0,
                  ),
                  CupertinoButton(
                    child: Text(
                      "I have an account? Sign in!",
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
                          builder: (context) => LoginPage(),
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
