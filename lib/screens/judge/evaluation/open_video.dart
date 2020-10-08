import 'package:Sabq/blocs/evaluation_bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController videoPlayerController;
  final bool looping;
  VideoScreen({
    @required this.videoPlayerController,
    this.looping,
  });

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ChewieController _chewieController;
  EvaluationBloc evaluationBloc;
  bool play = true;
  @override
  void initState() {
    super.initState();
    // Wrapper on top of the videoPlayerController
    init();
  }

  init() async {
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        showControlsOnInitialize: true,
        autoPlay: play,
        // Prepare the video to be played and display the first frame
        autoInitialize: true,
        showControls: true,
        allowedScreenSleep: false,
        looping: widget.looping,
        // Errors can occur for example when trying to play a video
        // from a non-existent URL
        errorBuilder: (context, errorMessage) {
          return Container(
            child: Text(
              "video error occur",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
    await Future.delayed(Duration(milliseconds: 100));
    evaluationBloc = Provider.of<EvaluationBloc>(context);
    evaluationBloc.startTimer();
    evaluationBloc.startStopWatch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Chewie(
                  controller: _chewieController,
                ),
              )),
          Positioned(
            right: 30,
            top: 60,
            child: IconButton(
              icon: Icon(Icons.clear),
              iconSize: 24,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chewieController.pause();
    _chewieController.videoPlayerController.dispose();
    _chewieController.dispose();
    evaluationBloc.pauseStopWatch();
    super.dispose();
  }
}
