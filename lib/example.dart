import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  VideoPlayerController? _controller;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller!.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset('asset/video_fixed_short.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller!.setLooping(true);
          _controller!.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
      children: <Widget>[
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width ?? 0,
              height: _controller!.value.size.height ?? 0,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
        // Add your other widgets on top of the video background here.
        // For example, you can use a Column or any other widget.
         const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Your content widgets go here
            Text(
              'Your App Content',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ],
        ),
      ],
    ),
    );
  }
}