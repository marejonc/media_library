import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:media_library/ui/widgets/rounded_panel_button.dart';
import '../utilities/constants.dart';
import 'main_library_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const String routeID = '/registration';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showSpinner = false;
  String _email = '';
  String _password = '';

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'lightning_logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset('assets/images/movie-frame.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) => _email = value,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) => _password = value,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                RoundedPanelButton(
                  text: 'Register',
                  color: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      _showSpinner = true;
                    });
                    try {
                      await _auth.createUserWithEmailAndPassword(
                          email: _email, password: _password);
                      if (!mounted) return;
                      Navigator.pushNamed(context, MainLibraryScreen.routeID);
                      _passwordController.clear();
                      _emailController.clear();
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                      _showSpinner = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
