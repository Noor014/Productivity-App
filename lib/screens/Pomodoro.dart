import 'dart:async';

import 'package:flutter/material.dart';
import 'package:productivity_app/utils/constants.dart';
import 'package:productivity_app/utils/progressIcons.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:audioplayers/audioplayers.dart';

import '../navbar.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key? key}) : super(key: key);

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

const _btnTextStart = 'START POMODORO';
const _btnTextResumePomodoro = 'RESUME POMODORO';
const _btntextResumeBreak = 'RESUME BREAK';
const _btnTextStartShortBreak = 'TAKE SHORT BREAK';
const _btnTextStartLongBreak = 'TAKE LONG BREAK';
const _btnTextStartNewSet = 'START NEW SET';
const _btnTextPause = 'PAUSE';

class _PomodoroState extends State<Pomodoro> {
  final player = AudioPlayer();
  String mainBtnText = _btnTextStart;

  int remainingTime = pomodoroTotalTime;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;

  Timer? _timer;
  int pomodoroNum = 0;
  int setNum = 0;

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4b39ba),
      ),
      backgroundColor: Color(0xFF988DDC),
      drawer: NavDrawer(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'No. of Pomodoro cycles done: $pomodoroNum',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'No. of Sets done: $setNum',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      backgroundColor: Colors.indigo.shade800,
                      radius: 100.0,
                      lineWidth: 15.0,
                      percent: _getPomodoroPercentage(),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        _secondsToFormatedString(remainingTime),
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      progressColor: statusColor[pomodoroStatus],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ProgressIcons(
                      total: pomodoriPerSet,
                      done: pomodoroNum - (setNum * pomodoriPerSet),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      statusDescription[pomodoroStatus]!,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ButtonTheme(
                      minWidth: 200,
                      child: ElevatedButton(
                        onPressed: _mainButtonPressed,
                        child: Text(
                          mainBtnText,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ButtonTheme(
                        minWidth: 200,
                        child: ElevatedButton(
                          onPressed: _resetButtonPressed,
                          child: Text(
                            "RESET",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
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
  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;

    if (remainingSeconds < 10) {
      remainingSecondsFormated = '0$remainingSeconds';
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }

    return '$roundedMinutes:$remainingSecondsFormated';
  }

  _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.runingPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTotalTime;
        break;
    }

    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  _mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runingPomodoro:
        _pausePomodoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreak();
        break;
      case PomodoroStatus.setFinished:
        setNum++;
        _startPomodoroCountdown();
        break;
    }
  }

  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runingPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) => {
          if (remainingTime > 0)
            {
              setState(() {
                remainingTime--;
                mainBtnText = _btnTextPause;
              })
            }
          else
            {
              _playSound(),
              pomodoroNum++,
              _cancelTimer(),
              if (pomodoroNum % pomodoriPerSet == 0)
                {
                  pomodoroStatus = PomodoroStatus.pausedLongBreak,
                  setState(() {
                    remainingTime = longBreakTime;
                    mainBtnText = _btnTextStartLongBreak;
                  }),
                }
              else
                {
                  pomodoroStatus = PomodoroStatus.pausedShortBreak,
                  setState(() {
                    remainingTime = shortBreakTime;
                    mainBtnText = _btnTextStartShortBreak;
                  }),
                }
            }
        });
  }

  _startShortBreak() {
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) => {
          if (remainingTime > 0)
            {
              setState(() {
                remainingTime--;
              }),
            }
          else
            {
              _playSound(),
              remainingTime = pomodoroTotalTime,
              _cancelTimer(),
              pomodoroStatus = PomodoroStatus.pausedPomodoro,
              setState(() {
                mainBtnText = _btnTextStart;
              }),
            }
        });
  }

  _startLongBreak() {
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) => {
          if (remainingTime > 0)
            {
              setState(() {
                remainingTime--;
              }),
            }
          else
            {
              _playSound(),
              remainingTime = pomodoroTotalTime,
              _cancelTimer(),
              pomodoroStatus = PomodoroStatus.setFinished,
              setState(() {
                mainBtnText = _btnTextStartNewSet;
              }),
            }
        });
  }

  _pausePomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumePomodoro;
    });
  }

  _resetButtonPressed() {
    pomodoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountdown();
  }

  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = pomodoroTotalTime;
    });
  }

  _pauseShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pauseBreakCountdown();
  }

  _pauseLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnText = _btntextResumeBreak;
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  _playSound() {
    //player.play(AssetSource('assets/audio/clock.mp3'));
  }


}

