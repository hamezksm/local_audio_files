import 'dart:io';
import 'package:flutter/material.dart';
import 'package:local_audio_files/database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioRecordingScreen extends StatefulWidget {
  const AudioRecordingScreen({super.key});

  @override
  State<AudioRecordingScreen> createState() => _AudioRecordingScreenState();
}

class _AudioRecordingScreenState extends State<AudioRecordingScreen> {
  String? _audioPath;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isRecording = false;
  bool isPlaying = false;
  AudioRecorder audioRecorder = AudioRecorder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isRecording
                ? const Text('Recording...')
                : ElevatedButton(
                    onPressed: () => _startRecording(),
                    child: const Text('Start Recording'),
                  ),
            _isRecording
                ? ElevatedButton(
                    onPressed: () => _stopRecording(),
                    child: const Text('Stop Recording'),
                  )
                : const SizedBox(),
            ElevatedButton(
              onPressed: () => isPlaying ? _pauseRecording() : _playRecording(),
              child: const Text('Play Recording'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/audioList');
        },
        tooltip: 'Go to Audio List',
        child: const Icon(Icons.list),
      ),
    );
  }


  Future<void> _startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      _audioPath = '${appDocDir.path}/recording.mp3';

      if (await audioRecorder.isRecording()) {
        // Do nothing if already recording.
        return;
      }

      await audioRecorder.start(
        const RecordConfig(),
        path: _audioPath!,
        // audioOutputFormat: AudioOutputFormat.AAC_ADTS,
      );
      // final stream = await audioRecorder
      //     .startStream(const RecordConfig(udioEncoder.pcm16bits));

      setState(() {
        _isRecording = true;
      });
    } else {
      // Handle permission denied.
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecording) {
      await audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      // Save audio path and date in the database.
      if (_audioPath != null) {
        Map<String, dynamic> audioData = {
          'path': _audioPath,
          'date': DateTime.now().toIso8601String(),
        };
        await _databaseHelper.insertAudio(audioData);
      }
    }
  }

  Future<void> _playRecording() async {
    if (_audioPath != null) {
      Source urlSource = UrlSource(_audioPath!);
      await _audioPlayer.play(urlSource);
      isPlaying = true;
    }
  }

  Future<void> _pauseRecording() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
