import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_slider/video_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'VideoSlider Demo',
      home: PickerPage(),
    );
  }
}

class PickerPage extends StatefulWidget {
  const PickerPage({Key? key}) : super(key: key);

  @override
  _PickerPageState createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final assets =
                await FilePicker.platform.pickFiles(type: FileType.video);
            if (assets != null) {
              final controller =
                  VideoEditorController.file(File(assets.files.single.path!));
              await Navigator.push(
                context,
                MaterialPageRoute<bool>(
                  builder: (_) => AppPage(controller),
                ),
              );
            }
          },
          child: const Text('Pick Video From Gallery'),
        ),
      ),
    );
  }
}

class AppPage extends StatefulWidget {
  AppPage(this.controller, {Key? key}) : super(key: key);

  final VideoEditorController controller;
  bool isPlaying = true;

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  String _positionText = 'Start: \nEnd: ';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await widget.controller.initialize();
    await widget.controller.video.play();
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: widget.controller.video.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: widget.controller.video.value.aspectRatio,
                        child: VideoPlayer(widget.controller.video),
                      )
                    : const Center(
                        child: Text('Loading...'),
                      ),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: const Text(
                      'Print start position time and end position time.'),
                  onPressed: () {
                    final duration =
                        widget.controller.video.value.duration.inSeconds;
                    final start = widget.controller.minTrim * duration;
                    final end = widget.controller.maxTrim * duration;
                    setState(() {
                      _positionText = 'Start: $start\nEnd: $end';
                    });
                  },
                ),
              ),
              if (widget.controller.video.value.isInitialized)
                Positioned(
                  bottom: 100,
                  child: Column(
                    children: [
                      Text(
                        _positionText,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(12),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                widget.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              onPressed: () {
                                widget.isPlaying
                                    ? widget.controller.video.pause()
                                    : widget.controller.video.play();
                                setState(() {
                                  widget.isPlaying = !widget.isPlaying;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 60,
                            child: VideoSlider(
                              controller: widget.controller,
                              height: 60,
                              maxDuration: const Duration(seconds: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
