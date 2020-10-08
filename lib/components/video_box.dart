import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBox extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  VideoBox({@required this.videoPlayerController});
  @override
  _VideoBoxState createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    print("sssssss");
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        // aspectRatio: 3 / 2,
        // autoPlay: true,
        looping: true,
        // showControlsOnInitialize: true,
        // autoInitialize: true,
        // showControls: true,
        // autoPlay: true,
        // looping: true,
        // allowedScreenSleep: false,
        errorBuilder: (context, errorMessage) {
          print("hello mo:$errorMessage");
          return Container(
            child: Text(
              "error",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  void dispose() {
    _chewieController.pause();
    _chewieController.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Chewie(
      controller: _chewieController,
    ));
  }
}
