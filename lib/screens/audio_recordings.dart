import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:local_audio_files/database/database.dart';

class AudioListScreen extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  AudioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio List'),
      ),
      body: FutureBuilder(
        future: _databaseHelper.getAudioList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> audioList = snapshot.data!;
            return ListView.builder(
              itemCount: audioList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(audioList[index]['date']),
                  onTap: () => _playAudio(audioList[index]['path']),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _playAudio(String path) async {
    AudioPlayer audioPlayer = AudioPlayer();
    Source urlSource = UrlSource(path);
    await audioPlayer.play(urlSource);
  }
}
