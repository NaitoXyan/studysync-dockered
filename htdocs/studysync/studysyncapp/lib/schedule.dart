import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studysync/addSchedule.dart';
import 'package:studysync/allList.dart';
import 'package:studysync/allSchedule.dart';
import 'package:http/http.dart' as http;

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {

  var date = DateTime.now();
  late var result;
  late Future scheduleFuture;

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
    result = '';
    scheduleFuture = getSchedule();
    repeatOnce();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> getSchedule() async {
    var url = Uri.parse('http://studysync-api:8000/api/user/$userId/schedules');
    var response = await http.get(url);

    scheduleList = jsonDecode(response.body);

    print(scheduleList);
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
                      )]),
                child: Column(
                  children: [
                    scheduleDay(),
                    scheduleListBuilder()
                  ],
                ),
              ),
            )
        ),

        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 90,
                  child: ElevatedButton(
                    onPressed: () async {
                      result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddSchedule())
                      );

                      if (result != null) {
                        setState(() {
                          scheduleFuture = getSchedule();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff000000),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        )
                    ),

                    child: const Text('Add Schedule',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 90,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllSchedules())
                      );
                      setState(() {
                        scheduleFuture = getSchedule();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(buttonColor()),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        )
                    ),

                    child: Text('Edit Schedule',
                      style: TextStyle(
                          color: Color(textColor()),
                          fontSize: 19,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ],
    );
  }

  textColor() {
    if (scheduleList.isEmpty) {
      return 0x80FFFFFF;
    }
    else {
      return 0xFFFFFFFF;
    }
  }

  buttonColor() {
    if (scheduleList.isEmpty) {
      return 0x80FFF7DE;
    }
    else {
      return 0xFF212761;
    }
  }

  Widget scheduleDay() {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFCC72C),
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ]
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(DateFormat('EEEE').format(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 21
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget scheduleListBuilder() {
    String dayNow = DateFormat('EEEE').format(date);

    return Expanded(
      flex: 9,
      child: FutureBuilder(
        future: scheduleFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
               if (snapshot.data.length > 0) {
                 if (snapshot.data[index]["day"] == dayNow) {
                   return Card(
                     child: ListTile(
                       title: Text('${snapshot.data[index]["subject_title"] ?? 'No Subject'}'),
                       trailing: Text(
                         //splits it into two lines = \n
                           '${snapshot.data[index]["time_in"] ?? 'No TimeIn'} - ${snapshot.data[index]["time_out"] ?? 'No TimeOut'}'
                       ),
                       onTap: () {

                       },
                     ),
                   );
                 }
                 else {
                   return Container();
                 }
               }
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
    );
  }
}