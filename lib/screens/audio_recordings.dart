import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:local_audio_files/database/database.dart';

class AudioListScreen extends StatefulWidget {
  const AudioListScreen({super.key});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool isPlaying = false;

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
                  onTap: () => isPlaying
                      ? _pauseAudio
                      : _playAudio(audioList[index]['path']),
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
    isPlaying = true;
  }

  Future<void> _pauseAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.pause();
    isPlaying = false;
  }
}
