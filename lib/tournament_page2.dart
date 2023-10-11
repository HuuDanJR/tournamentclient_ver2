import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/widget/loading_indicator.dart';
import 'package:tournament_client/widget/loadingbackground.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class TournamentPage extends StatefulWidget {
  const TournamentPage({Key? key}) : super(key: key);

  @override
  State<TournamentPage> createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage> {
  late final Future<LottieComposition> _composition;
  final String lottiePath = 'asset/video.json';
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    // _composition = AssetLottie(lottiePath).load();
    // _videoPlayerController =
    //     VideoPlayerController.asset('asset/video_reduce.mp4');
    // _chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController,
    //   autoPlay: true,
    //   showControls: false,
    //   allowFullScreen: true,
    //   overlay: null,
    //   aspectRatio: 16 / 9, // Set the aspect ratio (optional)
    //   // autoInitialize: true, // Auto-initialize video (optional)
    //   looping: true, // Loop the video (optional)
    // );
  }

  @override
  void dispose() {
    super.dispose();
    // _videoPlayerController.dispose();
    // _chewieController.dispose();
  }

//  Future<LottieComposition> _loadComposition() async {
//   var assetData = await rootBundle.load('assets/video_fix10.json');
//   return await  LottieComposition.fromByteData(assetData);
// }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width:width,height:height,
        color:MyColor.bedge,
        child: Stack(
          children: [
            // Background Lottie
            // loadingbackground(composition: _composition,width:width,height:height)
            //Background video
            // Container(
            //   padding: const EdgeInsets.all(0),
            //   width: width,
            //   height: height,
            //   color: MyColor.white,
            //   child: Chewie(
            //     controller: _chewieController,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
