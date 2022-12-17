import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:music_player/Music.dart';

class MusicDetay extends StatefulWidget {
  List<Music> musicListesi;
  int index;
  MusicDetay({required this.musicListesi, required this.index});

  @override
  State<MusicDetay> createState() => _MusicDetayState();
}

class _MusicDetayState extends State<MusicDetay> {
  bool isPlaying = false;
  double value = 0;
  final player = AudioPlayer();
  Duration? duration = const Duration(seconds: 0);

  void initPlayer() async {
    await player.setSource(
        AssetSource("../assets/${widget.musicListesi[widget.index].Url}"));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.stop();
  }

  void playMusic() async {
    if (isPlaying) {
      await player.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      await player.resume();
      setState(() {
        isPlaying = true;
      });
      player.onPositionChanged.listen((position) {
        setState(() {
          value = position.inSeconds.toDouble();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(title: Text(widget.musicListesi[widget.index].music_adi)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 300,
                height: 300,
                child: Image.asset(
                    "assets/${widget.musicListesi[widget.index].music_resim}")),
            Text(
              "${widget.musicListesi[widget.index].music_adi}",
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${(value / 60).floor()} : ${(value % 60).floor()}",
                  style: TextStyle(color: Colors.black),
                ),
                Container(
                  child: Slider(
                    min: 0.0,
                    max: duration!.inSeconds.toDouble() > 0
                        ? duration!.inSeconds.toDouble()
                        : 250,
                    onChanged: (v) {
                      setState(() {
                        value = v;
                      });
                    },
                    onChangeStart: (v) async {
                      await player.stop();
                    },
                    onChangeEnd: (value) async {
                      await player.seek(Duration(seconds: value.toInt()));
                      await player.resume();
                    },
                    value: value,
                    activeColor: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await player.stop();
                      duration = Duration(seconds: 0);
                      value = 0;
                      setState(() {
                        if (widget.index < 1) {
                          widget.index = widget.musicListesi.length - 1;
                        } else {
                          widget.index--;
                        }
                        isPlaying = false;
                        initPlayer();
                      });
                      await player.resume();
                      setState(() {
                        isPlaying = true;
                      });
                      await player.onPositionChanged.listen((position) {
                        setState(() {
                          value = position.inSeconds.toDouble();
                        });
                      });
                      await player.resume();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.fast_rewind_rounded, // sonraki şarkıya git
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: InkWell(
                      onTap: () => playMusic(),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await player.stop();
                      duration = Duration(seconds: 0);
                      value = 0;
                      setState(() {
                        if (widget.index > widget.musicListesi.length - 2) {
                          widget.index = 0;
                        } else {
                          widget.index++;
                        }
                        isPlaying = false;
                        initPlayer();
                      });
                      await player.resume();
                      setState(() {
                        isPlaying = true;
                      });
                      await player.onPositionChanged.listen((position) {
                        setState(() {
                          value = position.inSeconds.toDouble();
                        });
                      });
                      await player.resume();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.fast_forward_rounded, // sonraki şarkıya git
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Arc(
              edge: Edge.TOP,
              arcType: ArcType.CONVEY,
              height: 30,
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade900,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        top: 50,
                        bottom: 35,
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
