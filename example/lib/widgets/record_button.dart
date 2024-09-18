import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:record/record.dart';

import 'flow_shader.dart';
import 'globals.dart';
import 'lottie_animation.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    super.key,
    required this.controller,
    this.isLoading = false,
  });

  final AnimationController controller;
  final bool isLoading;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  static const double size = 24;

  final double lockerHeight = 200;
  double timerWidth = 0;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  DateTime? startTime;
  Timer? timer;
  String recordDuration = '00:00';
  late Record record;

  bool isLocked = false;
  bool showLottie = false;

  @override
  void initState() {
    super.initState();
    buttonScaleAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth =
        MediaQuery.of(context).size.width - 2 * Globals.defaultPadding - 4;
    timerAnimation =
        Tween<double>(begin: timerWidth + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation =
        Tween<double>(begin: lockerHeight + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    record.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsetsDirectional.fromSTEB(
          0,
          0,
          8,
          0,
        ),
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            lockSlider(),
            cancelSlider(),
            audioButton(),
            if (isLocked) timerLocked(),
          ],
        ),
      );

  Widget lockSlider() => Positioned(
        bottom: -lockerAnimation.value,
        child: Container(
          height: lockerHeight,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Globals.borderRadius),
            color: Colors.black,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              FlowShader(
                direction: Axis.vertical,
                child: const Column(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget cancelSlider() => Positioned(
        right: -timerAnimation.value,
        child: Container(
          height: size,
          width: timerWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Globals.borderRadius),
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                showLottie ? const LottieAnimation() : Text(recordDuration),
                const SizedBox(width: size),
                FlowShader(
                  duration: const Duration(seconds: 3),
                  flowColors: const [Colors.white, Colors.grey],
                  child: const Row(
                    children: [
                      Icon(Icons.keyboard_arrow_left),
                      Text(
                        'Slide to cancel',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: size),
              ],
            ),
          ),
        ),
      );

  Widget timerLocked() => Positioned(
        right: 0,
        child: Container(
          height: size,
          width: timerWidth,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Globals.borderRadius),
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 25),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                Vibrate.feedback(FeedbackType.success);
                timer?.cancel();
                timer = null;
                startTime = null;
                recordDuration = '00:00';

                final filePath = await Record().stop();

                debugPrint(filePath);
                setState(() {
                  isLocked = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(recordDuration,
                      style: const TextStyle(color: Colors.white)),
                  FlowShader(
                    duration: const Duration(seconds: 3),
                    flowColors: const [Colors.white, Colors.grey],
                    child: const Text(
                      'Tap lock to stop',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.lock,
                      size: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget audioButton() => GestureDetector(
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 24,
            minWidth: 24,
          ),
          child: const Icon(
            Icons.mic,
            color: Colors.white,
          ),
        ),
        onLongPressDown: (_) {
          debugPrint('onLongPressDown');
          widget.controller.forward();
        },
        onLongPressEnd: (details) async {
          debugPrint('onLongPressEnd');

          if (isCancelled(details.localPosition, context)) {
            Vibrate.feedback(FeedbackType.heavy);

            timer?.cancel();
            timer = null;
            startTime = null;
            recordDuration = '00:00';

            setState(() {
              showLottie = true;
            });

            Timer(const Duration(milliseconds: 1440), () async {
              widget.controller.reverse();
              debugPrint('Cancelled recording');
              final filePath = await record.stop();
              debugPrint(filePath);
              File(filePath!).delete();
              debugPrint('Deleted $filePath');
              showLottie = false;
            });
          } else if (checkIsLocked(details.localPosition)) {
            widget.controller.reverse();

            Vibrate.feedback(FeedbackType.heavy);
            debugPrint('Locked recording');
            debugPrint(details.localPosition.dy.toString());
            setState(() {
              isLocked = true;
            });
          } else {
            widget.controller.reverse();

            Vibrate.feedback(FeedbackType.success);

            timer?.cancel();
            timer = null;
            startTime = null;
            recordDuration = '00:00';

            final filePath = await Record().stop();

            debugPrint(filePath);
          }
        },
        onLongPressCancel: () {
          debugPrint('onLongPressCancel');
          widget.controller.reverse();
        },
        onLongPress: () async {
          debugPrint('onLongPress');
          Vibrate.feedback(FeedbackType.success);
          if (await Record().hasPermission()) {
            record = Record();
            await record.start(
              path:
                  '${Globals.documentPath}audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
              encoder: AudioEncoder.AAC,
              bitRate: 128000,
              samplingRate: 44100,
            );
            startTime = DateTime.now();
            timer = Timer.periodic(const Duration(seconds: 1), (_) {
              final minDur = DateTime.now().difference(startTime!).inMinutes;
              final secDur =
                  DateTime.now().difference(startTime!).inSeconds % 60;
              final min = minDur < 10 ? '0$minDur' : minDur.toString();
              final sec = secDur < 10 ? '0$secDur' : secDur.toString();
              setState(() {
                recordDuration = '$min:$sec';
              });
            });
          }
        },
      );

  bool checkIsLocked(Offset offset) => (offset.dy < -35);

  bool isCancelled(Offset offset, BuildContext context) =>
      (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
}
