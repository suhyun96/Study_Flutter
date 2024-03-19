import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  // 선택한 동영상 저장 변수
  // XFile은 ImagePicker로 영상 또는 이미지 선택시 반환되는 타입
  final XFile video;

  // 새 동영상 선택 시 실행되는 함수
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    super.key,
    required this.video,
    required this.onNewVideoPressed,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  // 동영상 조작용
  VideoPlayerController? videoController;

  bool showControls = false;

  @override
  void initState() {
    super.initState();

    initializeController(); // 초기 랜더링 시 컨트롤 초기화용
  }

  // 비디오 컨트롤러 선언용
  initializeController() async {
    final videoController = VideoPlayerController.file(
      // 네임드 생성자를 사용해서 만듦
      File(widget.video.path),
    );

    // 비디오 컨트롤러를 위에서 생성자로 만든 다음 여기서 초기화
    await videoController.initialize();

    // 비디오 컨트롤러에 동작이 있을 때마다 videoControllerListner 메서드 동작
    videoController.addListener(videoControllerListner);

    setState(() {
      // 위에서 만들어둔 컨트롤러를 대입
      this.videoController = videoController;
    });
  }

  // 컨트롤러가 움직일 때마다 화면을 새롭게 빌드하도록 세팅
  void videoControllerListner() {
    setState(() {});
  }

  @override
  // covariant 키워드는 CustomVideoPlayer 클래스의 상속된 값도 허가해줌
  // 위젯은 매개변수값이 변경될 때 폐기되고 새로 생성됨 그 때 폐기되는 위젯이 oldWidget
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  void dispose() {
    // 위젯 종료시 리스너 삭제
    videoController?.removeListener(videoControllerListner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 동영상 컨트롤러가 준비중일 때 로딩
    if (videoController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        // 동영상 비율에 화면 랜더링용으로 AspectRatio 위젯 사용
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          // 기본적으로 위젯을 정중앙에 배치
          children: [
            VideoPlayer(
              videoController!,
            ),
            if (showControls)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            Positioned(
              // Stack 하위에서 위치 지정할 때 사용
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      renderTimeTextFromDuration(
                        videoController!.value.position,
                      ),
                      Expanded(
                        child: Slider(
                          onChanged: (double val) {
                            videoController!
                                .seekTo(Duration(seconds: val.toInt()));
                          },
                          value: videoController!.value.position.inSeconds
                              .toDouble(),
                          // 동영상의 현재 위치를 대입
                          min: 0,
                          max: videoController!.value.duration.inSeconds
                              .toDouble(), // 동영상의 총 재생 길이
                        ),
                      ),
                      renderTimeTextFromDuration(
                        videoController!.value.duration,
                      ),
                    ],
                  )),
            ),
            if (showControls)
              Align(
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  onPressed: widget.onNewVideoPressed,
                  iconData: Icons.photo_camera_back,
                ),
              ),
            if (showControls)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      iconData: Icons.rotate_left,
                      onPressed: onReversePressed,
                    ),
                    CustomIconButton(
                      // 현재 비디오가 재생되는지 확인후 아이콘 변경
                      iconData: videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      onPressed: onPlayPressed,
                    ),
                    CustomIconButton(
                      iconData: Icons.rotate_right,
                      onPressed: onForwardPressed,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;

    Duration position = Duration();

    // 현재 비디오 재생된 시간이 3초 이상인 경우 위치를 3초전으로 되돌리기
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onForwardPressed() {
    // 비디오 총 재생시간
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;

    Duration position = maxPosition;

    // 지금까지 재생된 시간보다 총 재생시간이 3초 이상 길다면 3초 앞으로 위치 변경
    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  // 비디오가 재생 중인지 정지중인지 확인후 동작
  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}
