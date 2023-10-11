import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class VideoBackgroundPage extends StatefulWidget {
  const VideoBackgroundPage({super.key});

  @override
  State<VideoBackgroundPage> createState() => _VideoBackgroundPageState();
}

class _VideoBackgroundPageState extends State<VideoBackgroundPage> {
  late final Future<LottieComposition> _composition;
  @override
  void initState() {
     super.initState();
    _controller = VideoPlayerController.asset('asset/video_reduce.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      showControls: false, // Hide video controls
    );
  }
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
      width: width, // Full width
      height: height, // Full height
      child: Chewie(
        controller: _chewieController,
      ),
    )
    );
  }
}
