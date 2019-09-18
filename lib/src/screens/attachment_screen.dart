
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class AttachmentScreen extends StatefulWidget {
  final String _vidUrl;
  static VideoPlayerController _videoPlayerController;
  static var _chewieController;

  AttachmentScreen(this._vidUrl);

  @override
  _AttachmentScreenState createState() => _AttachmentScreenState();
}

class _AttachmentScreenState extends State<AttachmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildAttachmentScreen(),
    );
  }

  Widget _buildAttachmentScreen(){
    _getVideoPlayerController();
    _getChewieController();
    return _createChewieVideoPlayer();
  }

  void _getVideoPlayerController(){
    AttachmentScreen._videoPlayerController = VideoPlayerController.network(widget._vidUrl);
  }

  void _getChewieController(){
    AttachmentScreen._chewieController = ChewieController(
      videoPlayerController: AttachmentScreen._videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );
  }

  Widget _createChewieVideoPlayer(){
    return Chewie(
      controller: AttachmentScreen._chewieController,
    );
  }
}