import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
import 'package:squid_game/globals.dart';

enum TtsState { playing, stopped }

FlutterTts flutterTts;
dynamic languages;
String language;
double volume = 1.0;
double pitch = 1.0;
double rate = 0.3;

TtsState ttsState = TtsState.stopped;

get isPlaying => ttsState == TtsState.playing;
get isStopped => ttsState == TtsState.stopped;

initTts() {
  print('Initializing TTS');
  flutterTts = FlutterTts();

  getLanguages();

  if (Platform.isAndroid) {
    rate = 0.6;
  } else {
    rate = 0.48;
  }

  flutterTts.setStartHandler;
  {
    print("playing");
    ttsState = TtsState.playing;
  }

  flutterTts.setCompletionHandler;
  {
    print("Complete");
    ttsState = TtsState.stopped;
  }

  flutterTts.setErrorHandler(
    (msg) {
      print("error: $msg");
      ttsState = TtsState.stopped;
    },
  );
}

Future getLanguages() async {
  languages = await flutterTts.getLanguages;
  print("These are the available $languages");
  //  if (languages != null) setState(() => languages);
}

Future speak(String text) async {
  await flutterTts.setVolume(volume);
  await flutterTts.setSpeechRate(rate);
  await flutterTts.setPitch(pitch);

  print(defaultLocale);

  if (text != null) {
    if (text.isNotEmpty) {
      flutterTts.setLanguage(defaultLocale); // Not hardcoded language
      var result = await flutterTts.speak(text);
      if (result == 1) ttsState = TtsState.playing;
    }
  }
}

Future stop() async {
  var result = await flutterTts.stop();
  if (result == 1) ttsState = TtsState.stopped;
}

@override
void dispose() {
  // super.dispose();
  flutterTts.stop();
}

List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
  var items = List<DropdownMenuItem<String>>();
  for (String type in languages) {
    items.add(DropdownMenuItem(value: type, child: Text(type)));
  }
  return items;
}

void changedLanguageDropDownItem(String selectedType) {
  language = selectedType;
  flutterTts.setLanguage('en-US');
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
