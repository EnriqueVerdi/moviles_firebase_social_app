import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'CachedNetworkFile.dart';



Widget profileWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Image.asset(
        'assets/profile_default.png',
        fit: BoxFit.cover,
      );
    } else {
      return CachedNetworkFile(
        imageUrl: imageUrl,
      );
    }
  } else if (image.path.toLowerCase().endsWith('.mp4') || image.path.toLowerCase().endsWith('.wav')) {
    return VideoPlayerWidget(file: image);
  } else {
    return Image.file(image, fit: BoxFit.cover);
  }
}


class VideoPlayerWidget extends StatefulWidget {
  final File file;

  const VideoPlayerWidget({required this.file});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  late AudioPlayer _audioPlayer;
  bool _isAudioPlaying = false;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(widget.file);
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      setState(() {});
    });

    _audioPlayer = AudioPlayer();
    _audioPlayer.stop(); // Detener la reproducción de audio si se está reproduciendo algún audio previo
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.stop(); // Detener la reproducción de audio antes de liberar el recurso
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading video');
        } else {
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
              IconButton(
                icon: Icon(
                  _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: _toggleVideoPlayback,
              ),
            ],
          );
        }
      },
    );
  }

  void _toggleVideoPlayback() {
    setState(() {
      _isVideoPlaying = !_isVideoPlaying;
      if (_isVideoPlaying) {
        _videoController.play();
      } else {
        _videoController.pause();
      }
    });
  }

  void _toggleAudioPlayback(String audioPath) async {
    if (_isAudioPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(audioPath, isLocal: true);
    }
    setState(() {
      _isAudioPlaying = !_isAudioPlaying;
    });
  }

  Widget _buildAudioPlayer(String audioPath) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            _isAudioPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: () => _toggleAudioPlayback(audioPath),
        ),
        Text(
          _isAudioPlaying ? 'Playing Audio' : 'Paused Audio',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.file.path.toLowerCase().endsWith('.mp4')) {
      return _buildVideoPlayer();
    } else if (widget.file.path.toLowerCase().endsWith('.wav')) {
      return _buildAudioPlayer(widget.file.path);
    } else {
      return Image.file(widget.file, fit: BoxFit.cover);
    }
  }
}

