import 'package:flutter/material.dart';
import 'package:strix/business_logic/classes/call.dart';
import 'package:strix/business_logic/classes/room.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:strix/business_logic/logic/next_milestone_logic.dart';

class CallScreen extends StatefulWidget {
  static const String route_id = 'call_screen';

  final Room room;
  CallScreen({required this.room});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late VideoPlayerController _controller;
  late Call call;
  late String roomID;

  @override
  void initState() {
    // get roomID
    roomID = widget.room.roomID;
    // find current progress entry
    AvailableAssetEntry currentEntry = widget.room.availableAssets
        .singleWhere((element) => element.entryName == widget.room.gameProgress);
    // get call of current entry
    call = currentEntry.call!; //has been null checked on main screen
    _controller = VideoPlayerController.asset('assets/calls/${call.callFile}')
      ..initialize().then((_) {
        _controller.setVolume(1.0);
        // once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.addListener(() async {
          if (_controller.value.isPlaying == false) {
            // move to next milestone in database
            await NextMilestoneLogic().moveToNextMilestone(roomID: roomID);
            // pop screen when call has been finished
            Navigator.of(context).pop();
          }
        });
        // ensure the first frame is shown after the video is initialized
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    // disable wakelock again
    Wakelock.disable();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
