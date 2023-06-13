import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';


class CachedNetworkFile extends StatelessWidget {
  final String imageUrl;

  CachedNetworkFile({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultCacheManager().getSingleFile(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading file');
        } else if (snapshot.hasData) {
          File file = snapshot.data as File;
          if (file.path.toLowerCase().endsWith('.mp4') || file.path.toLowerCase().endsWith('.wav')) {
            return VideoPlayerWidget(file: file);
          } else {
            return Image.file(file, fit: BoxFit.cover);
          }
        } else {
          return Text('No file available');
        }
      },
    );
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

