import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:studysync/editSchedule.dart';
import 'package:http/http.dart' as http;
import 'allList.dart';

class AllSchedules extends StatefulWidget {
  const AllSchedules({super.key});

  @override
  State<AllSchedules> createState() => _AllSchedulesState();
}

class _AllSchedulesState extends State<AllSchedules> {

  bool buttonColor = false;
  late Future scheduleFuture;

  editButtonColor() {
    if (!buttonColor) {
      return 0x80FFF7DE;
    }
    else {
      return 0xFFFFF7DE;
    }
  }

  removeButtonColor() {
    if (!buttonColor) {
      return 0x80FFF7DE;
    }
    else {
      return 0xFFFF7676;
    }
  }

  @override
  void initState() {
    super.initState();
    scheduleFuture = getSchedule();
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
    return Scaffold(
      backgroundColor: const Color(0xFF1E213D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E213D),
        title: const Text('Schedules',
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // select button
          const Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 30, left: 15, right: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('all schedules',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
                ],
              ),
            ),
          ),

          // list of scheds
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: FutureBuilder(
                  future: scheduleFuture,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return ListView.builder(
                        itemCount: scheduleList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(scheduleList[index]['subject_title'] ?? 'No Subject'),
                              trailing: Text(
                                //splits it into two lines = \n
                                  '${scheduleList[index]['day'] ?? 'No Day'}\n${scheduleList[index]['time_in'] ?? 'No TimeIn'} - ${scheduleList[index]['time_out'] ?? 'No TimeOut'}'
                              ),
                              onTap: () async {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditSchedule(scheduleId: scheduleList[index]['schedule_id'], subjectId: scheduleList[index]['subject_id'], subjectTitle: scheduleList[index]['subject_title'], day: scheduleList[index]['day'], timeIn: scheduleList[index]['time_in'], timeOut: scheduleList[index]['time_out'])
                                    )
                                );

                                if (result != null) {
                                  setState(() {
                                    scheduleFuture = getSchedule();
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
            ),
          ),

          // finish edit button
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 350,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                      child: const Text('Finish Edit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}