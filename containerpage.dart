import 'package:flutter/material.dart';
import 'package:tournament_client/home.dart';
import 'package:tournament_client/home_mongo.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/widget/loadingbackground.dart';
import 'package:video_player/video_player.dart';

class ContainerPage extends StatefulWidget {
  String url;
  int selectedIndex;

  ContainerPage({key, required this.url, required this.selectedIndex});
  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  // late final Future<LottieComposition> _composition;
  VideoPlayerController? _controller;

  // final String lottiePath = 'asset/lottie3.json';
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    print('url: ${widget.url}');
    print('index: ${widget.selectedIndex}');
    //lottie using here
    // _composition = AssetLottie(lottiePath).load();
    _controller = VideoPlayerController.asset('asset/video_full.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown and set it to loop.
        setState(() {
          _controller!.setLooping(true);
          _controller!.play();
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        // alignment: Alignment.center,
        children: [
          Container(width: width, height: height, color: MyColor.black_text),
          // loadingbackground(composition: )
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width ?? width,
                height: _controller!.value.size.height ?? height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
          // loadingbackground(composition: _composition,height:height,width:width),
          // Lottie.asset(lottiePath,width: width,height:height),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //list from mongo
              SizedBox(
                width: width / 2.1,
                height: height,
                child: MyHomePageMongo(
                    // url: "http://localhost:8090",
                    title: 'Tournament Client',
                    url: widget.url,
                    selectedIndex: widget.selectedIndex
                    // selectedIndex: 1111111
                    ),
              ),
              SizedBox(
                width: width / 2.1,
                height: height,
                child: MyHomePage(
                  url: widget.url,
                  selectedIndex: widget.selectedIndex,
                  // url: "http://localhost:8090",
                  // selectedIndex: 5,
                  title: 'Tournament Client',
                ),
              )
              //list realtime
            ],
          ),

          // loadingbackground(composition: _composition,width:width,height:height),
        ],
      ),
    );
  }
}
