import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:viidieo_call/screens/token_update.dart';
import 'package:viidieo_call/styles/style_sheet.dart';


class CallPage extends StatefulWidget {

  final String channelName;
  final ClientRole role;
  final String img ;
  final String name ;


   CallPage({Key key, this.channelName, this.role , this.name , this.img}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in token_update.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(Token, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  // Widget _toolbar() {
  //   if (widget.role == ClientRole.Audience) return Container();
  //   return Container(
  //     alignment: Alignment.bottomCenter,
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         RawMaterialButton(
  //           onPressed: _onToggleMute,
  //           child: Icon(
  //             muted ? Icons.mic_off : Icons.mic,
  //             color: muted ? Colors.white : Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: muted ? Colors.blueAccent : Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: () => _onCallEnd(context),
  //           child: Icon(
  //             Icons.call_end,
  //             color: Colors.white,
  //             size: 35.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.redAccent,
  //           padding: const EdgeInsets.all(15.0),
  //         ),
  //         RawMaterialButton(
  //           onPressed: _onSwitchCamera,
  //           child: Icon(
  //             Icons.switch_camera,
  //             color: Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         )
  //       ],
  //     ),
  //   );
  // }

  /// Info panel to show logs
  // Widget _panel() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     alignment: Alignment.bottomCenter,
  //     child: FractionallySizedBox(
  //       heightFactor: 0.5,
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 48),
  //         child: ListView.builder(
  //           reverse: true,
  //           itemCount: _infoStrings.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             if (_infoStrings.isEmpty) {
  //               return null;
  //             }
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(
  //                 vertical: 3,
  //                 horizontal: 10,
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Flexible(
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         vertical: 2,
  //                         horizontal: 5,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: Colors.yellowAccent,
  //                         borderRadius: BorderRadius.circular(5),
  //                       ),
  //                       child: Text(
  //                         _infoStrings[index],
  //                         style: TextStyle(color: Colors.blueGrey),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Stack(
            children: <Widget>[

              InkWell(onDoubleTap: _onSwitchCamera,
                  child: _viewRows()),

              Align(

                   alignment: Alignment.topCenter,
                   child: Container(
                     padding: EdgeInsets.symmetric(vertical: 40 , horizontal: 40),
                     child: Column(
                       children: [
                         CircleAvatar(
                           radius: 50,
                           backgroundColor: Colors.black12,
                           child: CircleAvatar(
                               radius: 48,
                               backgroundImage: AssetImage(widget.img ,)),
                         ),
                     SizedBox(height: 10,),
                     Text(widget.name, style: TextStyle(color: Colors.white ,

                         fontWeight: FontWeight.bold,fontSize: 24),   overflow: TextOverflow.ellipsis  , maxLines: 1,),
                         SizedBox(height: 6,),
                       Text("Incoming video call", style: callTextStyle),
                       ],
                     ),
                   ),
                 ),
              Positioned(
                bottom: 0,

                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 100 , horizontal: 120),

                  child: Column(

                    children: [
                      Text("Swipe up to answer call",style: callTextStyle
                      ),
                      SizedBox(height: 14,),
                      CircleAvatar(
                        radius: 50,

                        backgroundImage: AssetImage("img/gif1.gif"),
                      ),
                      SizedBox(height: 14,),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text("Swipe down to decline call",style: callTextStyle
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // _panel(),
              // _toolbar(),
            ],
          ),
        ),
      ),
    );
  }
}