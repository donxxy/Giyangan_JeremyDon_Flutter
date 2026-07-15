import 'package:flutter/material.dart';

void main() => runApp(const ProfileApp());

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Profile')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProfileCard(),
              const SizedBox(height: 16),
              const StatsRow(),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'About Me',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ), // TextStyle
                      ), // Text
                      const SizedBox(height: 8),
                      const Text(
                        'BSSE student aspiring to be a software engineer',// u are free to write whatever you want here as desc
                      ), // Text
                    ],
                  ), // Column
                ), // Padding
              ), // Card
            ],
          ), // Column
        ), // Center
      ), // Scaffold
    ); // MaterialApp
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 40,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ), // RoundedRectangleBorder
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 30,
              child: Icon(Icons.person, size: 32),
            ), // CircleAvatar
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Jeremy Don Giyangan', //write ur name here :)
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Software Engineering',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  'jeremydon.giyangan-25@cpu.edu.ph',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ), // Column
          ], // Row children
        ), // Row
      ), // Padding
    ); // Card
  }
}

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ), // TextStyle
              ), // Text
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ), // Text
            ],
          ), // Column
        ), // Padding
      ), // Card
    ); // Expanded
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Row(
        children: [
          _statCard('90', 'Posts'),
          _statCard('2.3M', 'Followers'),
          _statCard('11', 'Following'),
        ],
      ), // Row
    ); // SizedBox
  }
}