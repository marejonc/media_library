import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:media_library/ui/library_page.dart';
import 'package:media_library/ui/search_page.dart';

class MainLibraryScreen extends StatefulWidget {
  const MainLibraryScreen({Key? key}) : super(key: key);

  static const String routeID = '/main_library';

  @override
  State<MainLibraryScreen> createState() => _MainLibraryScreenState();
}

class _MainLibraryScreenState extends State<MainLibraryScreen> {
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _loggedInUser;

  List pages = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _loggedInUser = user;
        pages = [
          SearchPage(loggedInUser: _loggedInUser),
          LibraryPage(loggedInUser: _loggedInUser),
        ];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onWillPop() async {
    _auth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Library'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueAccent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          iconSize: 30,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'My Library',
              backgroundColor: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
