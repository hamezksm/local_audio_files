import 'package:flutter/material.dart';
import 'package:local_audio_files/screens/audio_recordings.dart';
import 'package:local_audio_files/screens/audio_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Audio saver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AudioRecordingScreen(),
        '/audioList': (context) => AudioListScreen(),
      },
      // home: const AudioRecordingScreen(),
    );
  }
}
