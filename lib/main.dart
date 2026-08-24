import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mini Playlist',
      home: PlaylistScreen(),
    );
  }
}

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  // Step 7a: The list of songs
  final List<String> songs = const [
    'Sunset Drive',
    'Strategy (feat. Megan Thee Stallion)',
    'Upuan by Gloc-9',
    'Kumilos (feat. Higit Sa Pag-Ibig, The Musical)',
    'Aint In LA by ADELA',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Playlist')),
      // Step 7b: The ListView.builder
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(songs[index]),
            onTap: () {
              // TODO 1 & 2: Calling Navigator.push and passing songs[index]
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(
                    songTitle: songs[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NowPlayingScreen extends StatelessWidget {
  final String songTitle;
  
  const NowPlayingScreen({super.key, required this.songTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Playing: $songTitle',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Stop and Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}