import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('images/foto karisma.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              "Maria Karisma Pada Wangge",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Nasabah Koperasi Undiksha"),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("karisma@undiksha.ac.id"),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("0812-3695-7914"),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Jl. Kampus Undiksha, Singaraja"),
            ),
          ],
        ),
      ),
    );
  }
}
