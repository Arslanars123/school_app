// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// class VideoApp extends StatefulWidget {
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }
//
//
//
// class _VideoAppState extends State<VideoApp> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();
//     // Create a VideoPlayerController.
//     _controller = VideoPlayerController.asset(
//       'assets/images/mobile animationv2.mp4',
//     )..initialize().then((_) {
//       setState(() {

//       });
//     });

//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     // Ensure disposing of the VideoPlayerController to free up resources.
//     _controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           // If the VideoPlayerController has finished initialization, use it to display the video.
//           return AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           );
//         } else {
//           // If the VideoPlayerController is still initializing, show a loading spinner.
//           return Center(child: CircularProgressIndicator());
//         }
//       },

//     );
//   }
// }
