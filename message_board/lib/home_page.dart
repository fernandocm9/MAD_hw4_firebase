import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'chat_room_screen.dart';

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
              leading: Icon(Icons.home),
              title: Text('Message Board'),
              onTap: () {
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
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop(); 
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                });
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChatRoomScreen(roomName: 'Games'),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.red),
              child: const Text('Games', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChatRoomScreen(roomName: 'Business'),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Text('Business', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChatRoomScreen(roomName: 'Public Health'),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.pink),
              child: const Text('Public Health', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChatRoomScreen(roomName: 'Study'),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.purple),
              child: const Text('Study', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ),
        ]
      )
    );
  }
}
