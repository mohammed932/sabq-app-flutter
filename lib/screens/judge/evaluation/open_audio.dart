import 'package:Sabq/blocs/competition_bloc.dart';
import 'package:Sabq/blocs/evaluation_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef void OnError(Exception exception);

class LocalAudio extends StatefulWidget {
  final playerUrl;
  final double borderRadius;
  final double marginBottom;
  final Stopwatch stopwatch;
  final bool isHaveDuration;
  LocalAudio(
      {this.playerUrl,
      this.borderRadius,
      this.marginBottom,
      this.stopwatch,
      this.isHaveDuration = true});

  @override
  _LocalAudio createState() => _LocalAudio();
}

class _LocalAudio extends State<LocalAudio> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  bool playing = false;
  EvaluationBloc evaluationBloc;

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

    await Future.delayed(Duration(milliseconds: 100));
    evaluationBloc = Provider.of<EvaluationBloc>(context);
  }

  String localFilePath;

  slider() {
    return Slider(
        activeColor: Colors.blueAccent,
        inactiveColor: Colors.white,
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
        Container(
          height: 201,
          margin: EdgeInsets.only(bottom: widget.marginBottom),
        ),
        SizedBox(height: 50),
        Row(
          children: <Widget>[
            IconButton(
              icon: playing
                  ? Icon(
                      Icons.pause,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
              onPressed: () {
                if (!playing) {
                  //////
                  advancedPlayer.play(widget.playerUrl,
                      position: _position > _duration ? Duration() : _position);
                  evaluationBloc.startTimer();
                  evaluationBloc.startStopWatch();
                  setState(() {
                    playing = true;
                  });
                } else {
                  if (widget.isHaveDuration) {
                    evaluationBloc.pauseStopWatch();
                  }
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(child: UrlAudio()),
          ),
          Positioned(
            right: 30,
            top: 60,
            child: IconButton(
              icon: Icon(Icons.clear),
              iconSize: 24,
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    evaluationBloc.pauseStopWatch();
    advancedPlayer.pause();
    super.dispose();
  }
}
