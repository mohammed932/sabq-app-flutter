import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

typedef void OnError(Exception exception);

class AudioBox extends StatefulWidget {
  final playerUrl;
  AudioBox({
    this.playerUrl,
  });

  @override
  _AudioBox createState() => _AudioBox();
}

class _AudioBox extends State<AudioBox> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  bool playing = false;

  @override
  void initState() {
    super.initState();

    initPlayer();
  }

  void initPlayer() async {
    advancedPlayer = new AudioPlayer();

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });

    advancedPlayer.completionHandler = () => setState(() {
          playing = false;
          _position = Duration();
        });
  }

  String localFilePath;

  slider() {
    return Slider(
        activeColor: Colors.blueAccent,
        inactiveColor: Colors.black38,
        value: _position.inSeconds.toDouble() > _duration.inSeconds.toDouble()
            ? 0.0
            : _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });
        });
  }

  Widget UrlAudio() {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: playing
                  ? Icon(
                      Icons.pause,
                      color: Colors.black,
                    )
                  : Icon(Icons.play_arrow, color: Colors.black),
              onPressed: () {
                if (!playing) {
                  advancedPlayer.play(widget.playerUrl,
                      position: _position > _duration ? Duration() : _position);
                  setState(() {
                    playing = true;
                  });
                } else {
                  advancedPlayer.pause();
                  setState(() {
                    playing = false;
                  });
                }
              },
            ),
            Expanded(child: slider()),
          ],
        )
      ],
    );
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: UrlAudio());
  }

  @override
  void dispose() {
    advancedPlayer.pause();
    super.dispose();
  }
}
