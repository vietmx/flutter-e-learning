import 'package:elearning/ui/pages/login.dart'; // Import the LoginPage
import 'package:flutter/cupertino.dart';

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/waiting.png'), // Waiting image
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Wait for Admin Approval",
              style: TextStyle(
                fontFamily: 'Red Hat Display',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            CupertinoButton(
              color: CupertinoColors.systemBlue,
              child: Text(
                "Login",
                style: TextStyle(
                  fontFamily: 'Red Hat Display',
                  fontSize: 16,
                  color: CupertinoColors.white,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => LoginPage(), // Navigate to the LoginPage
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
