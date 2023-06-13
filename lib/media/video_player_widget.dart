
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;
  final File? file;

  const VideoPlayerWidget({Key? key, this.videoUrl, this.file}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl!);
      _initializeVideoPlayerFuture = _videoPlayerController!.initialize();
    } else if (widget.file != null) {
      _videoPlayerController = VideoPlayerController.file(widget.file!);
      _initializeVideoPlayerFuture = _videoPlayerController!.initialize();
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoPlayerController != null) {
      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController!),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      );
    } else {
      return Container(); // Widget vacío si no se proporciona videoUrl ni file
    }
  }
}