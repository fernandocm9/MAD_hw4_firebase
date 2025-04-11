import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomName;

  const ChatRoomScreen({super.key, required this.roomName});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    final user = _auth.currentUser;
    if (user == null || _messageController.text.trim().isEmpty) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final displayName = userDoc.exists
        ? '${userDoc['first_name']} ${userDoc['last_name']}'
        : user.email ?? 'Anonymous';

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.roomName)
        .collection('messages')
        .add({
      'text': _messageController.text.trim(),
      'sender': displayName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.roomName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(widget.roomName)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final text = msg['text'] ?? '';
                    final sender = msg['sender'] ?? 'Unknown';
                    final time = msg['timestamp'] != null
                        ? (msg['timestamp'] as Timestamp).toDate()
                        : DateTime.now();

                    return ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: Text(text),
                      subtitle: Text('$sender • ${time.toLocal().toString().substring(0, 16)}'),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text('Send'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
