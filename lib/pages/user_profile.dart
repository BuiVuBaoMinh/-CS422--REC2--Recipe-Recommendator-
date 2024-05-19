import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signUserOut,
          )
        ],
      ),
      body: const Text("User Profile body"),
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
}
