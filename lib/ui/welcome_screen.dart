import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:media_library/ui/registration_screen.dart';
import 'package:media_library/ui/widgets/rounded_panel_button.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const String routeID = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'lightning_logo',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: SizedBox(
                      height: 60.0,
                      child: Image.asset('assets/images/movie-frame.png'),
                    ),
                  ),
                ),
                Flexible(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Movie Library',
                        textStyle: const TextStyle(
                          fontSize: 37.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedPanelButton(
              color: Colors.lightBlueAccent,
              text: 'Log In',
              onPressed: () {
                //Go to login screen.
                Navigator.pushNamed(context, LoginScreen.routeID);
              },
            ),
            RoundedPanelButton(
              color: Colors.blueAccent,
              text: 'Register',
              onPressed: () {
                //Go to login screen.
                Navigator.pushNamed(context, RegistrationScreen.routeID);
              },
            ),
          ],
        ),
      ),
    );
  }
}
