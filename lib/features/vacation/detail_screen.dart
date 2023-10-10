import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    required this.imagePath,
    required this.videoPath,
    super.key,
  });

  final String imagePath;
  final String videoPath;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late ValueNotifier<bool> isShowPlayIcon;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath);

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(false);
    isShowPlayIcon = ValueNotifier(true);
    _controller.addListener(() {
      if (_controller.value.isCompleted) {
        isShowPlayIcon.value = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Video screen',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // _controller.play();
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: GestureDetector(
                onTap: playVideo,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    ValueListenableBuilder(
                      builder: (context, value, child) => Visibility(
                        visible: value,
                        child: IconButton(
                          onPressed: playVideo,
                          icon: const Icon(
                            Icons.play_circle,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      valueListenable: isShowPlayIcon,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void playVideo() {
    _controller.value.isPlaying ? _controller.pause() : _controller.play();
    isShowPlayIcon.value = !isShowPlayIcon.value;
  }
}
