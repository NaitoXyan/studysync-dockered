import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class StudyTimerScreen extends StatefulWidget {
  const StudyTimerScreen({super.key});

  @override
  State<StudyTimerScreen> createState() => _StudyTimerScreenState();
}

class _StudyTimerScreenState extends State<StudyTimerScreen> {
  String startAndStop = 'START';
  int workTime = 25;
  int breakTime = 5;
  int _start = 0;
  Timer? _timer;
  bool isRunning = false;
  bool isWorkTime = true;

  void _showNotification(String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
    );
  }

  void startTimer() {
    _start = isWorkTime ? (workTime * 60) : (breakTime * 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          isWorkTime = !isWorkTime;

          _start = isWorkTime ? (workTime * 60) : (breakTime * 60);

          _showNotification(
            isWorkTime ? 'Work Time' : 'Break Time',
            isWorkTime ? 'Every moment invested now paves the way for future success. Embrace the challenge and make each minute count toward your goals! :>' : 'Take a break! Keep hydrated by drinking water, and engage in other healthy activities after your study session! :>',
          );

        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        isRunning = false;
        _start = isWorkTime ? (workTime * 60) : (breakTime * 60);
        if (!isWorkTime) {
          isWorkTime = true;
          _start = workTime * 60; // Reset to initial work time when stopping during break
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    // double sW =  MediaQuery.of(context).size.width;
    // double sH =  MediaQuery.of(context).size.height;
    return Container(
      color: const Color.fromRGBO(17, 24, 100, 1.0),
      child:  Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: 50,
          right: 50,
        ),
        child: Column(
          children: [
            Container(
              decoration:
              BoxDecoration(
                  boxShadow: const [BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.5254901960784314),
                      offset: Offset(0,2),
                      blurRadius: 5
                  )
                  ],
                  color: const Color.fromRGBO(13, 16, 54, 1.0),
                  borderRadius: BorderRadius.circular(20)
              ),
              height: 380,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:40, right: 40, top: 40,bottom: 20),
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        decoration:BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        height: 150,
                        width: 230,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Center(
                            child:Text('${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.w900
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 155,
                        child: Column(
                          children: [
                            const Text('Work Time',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20
                              ),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: isRunning ? null : () => changeWorkTime(-1),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2195f2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              )
                            ),
                            Text('$workTime minutes',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),
                            ),
                            ElevatedButton(
                              onPressed: isRunning ? null : () => changeWorkTime(1),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2195f2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              )
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 155,
                        child: Column(
                          children: [
                            const Text('Break Time',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20
                              ),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: isRunning ? null : () => changeBreakTime(-1),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2195f2),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  )
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              )
                            ),
                            Text('$breakTime minutes',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),
                            ),
                            ElevatedButton(
                              onPressed: isRunning ? null : () => changeBreakTime(1),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2195f2),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  )
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(
                    color: Color.fromRGBO(
                        0, 0, 0, 0.5254901960784314),
                    offset: Offset(0,1),
                    blurRadius: 10,
                  )
                  ],
                ),
                height: 70,
                child: ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(64, 211, 72, 1.0),
                    shape:const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    )
                ),
                  onPressed: (){
                    if(startAndStop == 'START'){
                      startAndStop = 'STOP';
                      startTimer();
                    }
                    else{
                      startAndStop = 'START';
                      stopTimer();
                    }
                  },
                  child: Text(startAndStop,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void changeWorkTime(int change) {
    if (workTime + change > 0) {
      setState(() {
        workTime += change;
        if (isWorkTime) {
          _start = workTime * 60;
        }
      });
    }
  }

  void changeBreakTime(int change) {
    if (breakTime + change > 0) {
      setState(() {
        breakTime += change;
        if (!isWorkTime) {
          _start = breakTime * 60;
        }
      });
    }
  }
}

