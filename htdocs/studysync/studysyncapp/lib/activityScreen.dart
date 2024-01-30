import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studysync/activityDetails.dart';
import 'package:studysync/addActivityScreen.dart';
import 'package:studysync/allList.dart';
import 'package:http/http.dart' as http;

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

// uses the SingleTickerProvider Mixin
class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {

  DateTime currentTime = DateTime.now();
  Timer? timer;
  late Future activitiesFuture;

  // defining the Animation Controller
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );

  // defining the Offset of the animation
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: const Offset(0.0, 0.0),
  ).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    )
  );

  //make animation perform once and stop
  void repeatOnce() async {
    await _animationController.forward();
  }

  @override
  void initState() {
    // repeat one animation
    repeatOnce();
    // timer to  update activities' color
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
    activitiesFuture = getActivity();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  //change color depende sa deadline
  deadline(index) {
    String? stringDate = activitiesList[index]['deadline_day'];
    String? stringTime = activitiesList[index]['deadline_time'];

    //combine the two
    String stringDateTime = '$stringDate $stringTime';

    //covert from String to DateTime
    DateTime deadlineDateTime = DateFormat('d MMMM y HH:mm a').parse(stringDateTime);

    final differenceDates = DateTime.now().difference(deadlineDateTime).inSeconds;

    //wala pa deadline
    if (differenceDates < 0 && differenceDates < -86400) {
      return 0xFFFFEDB8;
    }

    //under 24 hours na deadline
    else if(differenceDates < 0 && differenceDates >= -86400) {
      return 0xFFFFAE63;
    }

    //lapas na deadline
    else if (differenceDates >= 0) {
      return 0xFFFF6258;
    }
  }

  Future<List<dynamic>> getActivity() async {
    var url = Uri.parse('http://studysync-api:8000/api/user/$userId/activities');
    var response = await http.get(url);

    activitiesList = jsonDecode(response.body);

    print(activitiesList);
    return scheduleList;
  }

  @override
  Widget build (BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: SlideTransition(
            // the offset which we define above
            position: _offsetAnimation,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7DE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  )
                ]
              ),

              child: FutureBuilder(
                future: activitiesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: activitiesList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(deadline(index)),
                          child: ListTile(
                            title: Text(activitiesList[index]['activity_title'] ?? 'No Subject'),
                            subtitle: Text(activitiesList[index]['subject_title'] ?? 'No Title'),
                            trailing: Text(
                              //splits it into two lines = \n
                                '${activitiesList[index]['deadline_day'] ?? 'No Date'} \n${activitiesList[index]['deadline_time'] ?? 'No Time'}'
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ActivityDetails(
                                  title: activitiesList[index]['activity_title'] ?? 'null',
                                  subject: activitiesList[index]['subject_title']  ?? 'null',
                                  description: activitiesList[index]['description']  ?? 'null',
                                  date: activitiesList[index]['deadline_day']  ?? 'null',
                                  time: activitiesList[index]['deadline_time']  ?? 'null',
                                  id: activitiesList[index]['activity_id'] ?? 'null',
                                )),
                              );

                              if (result != null) {
                                setState(() {
                                  activitiesFuture = getActivity();
                                });
                              }
                            },
                          ),
                        );
                      },
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  else {
                    return const Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              )

            ),
          )
        ),

        Expanded(
          flex: 3,
          child: Center(
            child: SizedBox(
              width: 330,
              height: 90,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return const AddActivities();
                      },
                      settings: const RouteSettings(name: 'AddActivities'),
                    )
                  );

                  if (result != null) {
                    setState(() {
                      activitiesFuture = getActivity();
                    });
                  }

                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff000000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    )
                ),

                child: const Text('Add Activity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}