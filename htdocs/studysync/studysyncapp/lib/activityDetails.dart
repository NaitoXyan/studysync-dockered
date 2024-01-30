import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:studysync/editActivity.dart';

import 'allList.dart';

class ActivityDetails extends StatefulWidget {
  String title;
  String subject;
  String description;
  String date;
  String time;
  int id;

  ActivityDetails({
    required this.title,
    required this.subject,
    required this.description,
    required this.date,
    required this.time,
    required this.id,
    Key?  key
  }) : super(key: key);

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class Album {
  late bool success;
  late String message;

  Album({
    required this.success,
    required this.message
  });

  // json to album convert thingie
  factory Album.fromJson(Map<String, dynamic> json) {
    // using pattern matching
    return switch (json) {
      {
      'success': bool success,
      'message': String message
      } => Album(success: success, message: message),
      _ => throw const FormatException('Failed to load album')
    };
  }
}

class _ActivityDetailsState extends State<ActivityDetails> {

  late var result;
  late Future activitiesFuture;

  Future<List<dynamic>> getActivity() async {
    var url = Uri.parse('http://studysync-api:8000/api/user/$userId/activities');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      activitiesList = jsonDecode(response.body) as List<dynamic>;
      print(activitiesList);
      return activitiesList;
    }

    else {
      print('Failed to get activities. Status code: ${response.statusCode}');
      throw Exception('Failed to update album.');
    }
  }

  Future<Album> deleteActivity(int activityId) async {
    var url = Uri.parse('http://studysync-api:8000/api/deleteActivity/$activityId');

    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Schedule deleted successfully.');
      getActivity();

      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    else {
      print('Failed to delete schedule. Status code: ${response.statusCode}');
      throw Exception('Failed to update album.');
    }
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E213D),
      appBar: AppBar(
        backgroundColor: const Color(0xff1E213D),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600
              ),
            ),
            subtitle: Text(
              widget.subject,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w100
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 35.0),
            child: Text(
              'Description',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Text(widget.description),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 12),
            child: Text('Deadline',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white
              ),
            ),
          ),

          SizedBox(
            height: 100,
            child: Row(
              children: [

                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: ListTile(
                          title: Text(widget.date),
                        ),
                      )
                    )
                ),

                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text(widget.time),
                          ),
                        )
                    )
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 65,
                        width: 135,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFFCC72C),
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                            )
                          ),
                          onPressed: () async {
                            // expects Map<String, String> type
                            result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditActivity(title: widget.title, subject: widget.subject, description: widget.description, date: widget.date, time: widget.time, id: widget.id,))
                            );

                            // update info displayed
                            if(result != null && result is Map<String, dynamic>) {
                              setState(() {
                                print(result);
                                activitiesFuture = getActivity();
                                widget.title = result['activity_title'];
                                widget.subject = result['subject_title'];
                                widget.description = result['description'];
                                widget.date = result['deadline_day'];
                                widget.time = result['deadline_time'];
                              });
                            }

                          },
                          child: const Text('Edit Activity',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 65,
                        width: 135,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF4CB648),
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                            )
                          ),
                          onPressed: () {
                            setState(() {
                              activitiesFuture = deleteActivity(widget.id);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Mark as Done',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}