import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = _auth.currentUser?.email ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: Text('Select A Room'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Message Board'),
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => HomePage(),
                //   ),
                // );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).pop(); 
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings
                Navigator.of(context).pop();
              },
            ),
          ]
        )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the selected room
            },
            child: Container(
              child: Text('Games', style: TextStyle(fontSize: 24 ,color: Colors.white)),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to the selected room
            },
            child: Container(
              child: Text('Business', style: TextStyle(fontSize: 24 ,color: Colors.white)),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to the selected room
            },
            child: Container(
              child: Text('Public Health', style: TextStyle(fontSize: 24 ,color: Colors.white)),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to the selected room
            },
            child: Container(
              child: Text('Study', style: TextStyle(fontSize: 24 ,color: Colors.white)),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
            ),
          ),
        ]
      )
    );
  }
}
