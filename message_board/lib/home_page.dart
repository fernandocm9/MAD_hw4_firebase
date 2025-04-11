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

  void _navigateToRoom(String roomName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(roomName: roomName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = _auth.currentUser?.email ?? "User";
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight;
    final containerHeight = screenHeight / 4;


    final List<Map<String, dynamic>> rooms = [
      {'name': 'Games', 'color': Colors.red, 'image': Icons.videogame_asset},
      {'name': 'Business', 'color': Colors.blue, 'image': Icons.business_center},
      {'name': 'Public Health', 'color': Colors.pink, 'image': Icons.health_and_safety},
      {'name': 'Study', 'color': Colors.purple, 'image': Icons.menu_book},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select A Room'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Message Board'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
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
          ],
        ),
      ),
      body: Column(
        children: List.generate(rooms.length, (index) {
          final room = rooms[index];
          final isTextLeft = index % 2 == 0;

          return GestureDetector(
            onTap: () => _navigateToRoom(room['name']),
            child: Container(
              height: containerHeight,
              color: room['color'],
              child: Row(
                children: isTextLeft ? [_roomText(room['name']), _roomIcon(room['image']),] : [_roomIcon(room['image']), _roomText(room['name']),],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _roomText(String name) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _roomIcon(IconData iconData) {
    return Expanded(
      child: Icon(
        iconData,
        size: 60,
        color: Colors.white70,
      ),
    );
  }
}
