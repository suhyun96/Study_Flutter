import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine; // 아고라 엔진 저장
  int? uid; // 내 id
  int? otherUid; // 상대방 id

  // 보통 build가 먼저 실행되니까 FutureBuilder로 이거 실행시킨 다음 랜더링 하도록 세팅
  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다';
    }

    if (engine == null) {
      engine = createAgoraRtcEngine();
      await engine!.initialize(RtcEngineContext(
        appId: APP_ID,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      // rtc 이벤트 헨들러 각 이벤트에 따른 제어
      engine!.registerEventHandler(RtcEngineEventHandler(
        // 채널 입장 성공
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print(' 채널 입장 . uid : ${connection!.localUid}');
          setState(() {
            this.uid = connection.localUid;
          });
        },
        // 채널 나갔을 때 콜백함수
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          print('채널 퇴장');
          setState(() {
            uid = null;
          });
        },
        // 상대방이 채널나갔을 때
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          // ➏ 다른 사용자가 채널을 나갔을 때 실행
          print('상대가 채널에서 나갔습니다. uid : $uid');
          setState(() {
            otherUid = null;
          });
        },
      ));

      // 엔진으로 영상을 송출하겠다고 세팅합니다.
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo(); // ➐ 동영상 기능을 활성화합니다.
      await engine!.startPreview(); // 핸드폰 카메라를 이용해 동영상을 화면에 실행합니다.
      // 채널에 들어가기
      await engine!.joinChannel(
        token: TEMP_TOKEN,
        channelId: CHANNEL_NAME,
        options: ChannelMediaOptions(),
        uid: 0,
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIVE'),
      ),
      body: FutureBuilder(
        // future기반으로 랜더링
        future: init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    renderMainView(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.grey,
                        height: 160,
                        width: 120,
                        child: renderSubView(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (engine != null) {
                            await engine!.leaveChannel();
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text('채널 나가기'),
                      ),
                    )
                  ],

                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget renderSubView() {
    if (uid != null) {
      return AgoraVideoView(
          controller: VideoViewController(
              rtcEngine: engine!, canvas: const VideoCanvas(uid: 0)));
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget renderMainView() {
    if (otherUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine!,
          canvas: VideoCanvas(uid: otherUid),
          connection: const RtcConnection(channelId: CHANNEL_NAME),
        ),
      );
    } else {
      return Center(
        child: const Text(
          '다른 사용자가 입장할 때 까지 대기',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
