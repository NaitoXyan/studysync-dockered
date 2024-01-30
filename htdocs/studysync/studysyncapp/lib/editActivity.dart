import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studysync/activityNotification.dart';
import 'package:studysync/subjects.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditActivity extends StatefulWidget {
  String title;
  String subject;
  String description;
  String date;
  String time;
  int id;

  EditActivity({
    required this.title,
    required this.subject,
    required this.description,
    required this.date,
    required this.time,
    required this.id,
    Key?  key
  }) : super(key: key);

  @override
  State<EditActivity> createState() => _EditActivityState();
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

class _EditActivityState extends State<EditActivity> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final result;

  @override
  void initState() {
    _subjectController = TextEditingController(text: widget.subject);
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _dateController = TextEditingController(text: widget.date);
    _timeController = TextEditingController(text: widget.time);
    super.initState();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<Album> updateActivity(String activity_title, String description, String deadline_day, String deadline_time, int subject_id) async {
    var url = Uri.parse('http://studysync-api:8000/api/activity/${widget.id}');
    final response = await http.put(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'activity_title': activity_title,
        'description': description,
        'deadline_day': deadline_day,
        'deadline_time': deadline_time,
        'subject_id': subject_id
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('success');
      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    else {
      // If the server did not return a 200 OK response,
      // print the error details and then throw an exception.
      print('Failed to update album. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update album.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xff1E213D),
        appBar: AppBar(
          backgroundColor: const Color(0xff1E213D),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Edit Activity',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        //SingleChildScrollView para dili mag pixel OVERFLOW
        body: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  //subject text label
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Text('Subject',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),

                  //subject button ni siya
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _subjectController,
                      readOnly: true,
                      onTap: () async {
                        result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Subjects()),
                        );

                        _subjectController.text = result['title'];
                      },
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'SUBJECT',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)
                              ),
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.white
                              )
                          )
                      ),
                    ),
                  ),

                  //title text ni siya
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Title',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),

                  //title textFormField
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)
                              ),
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.white
                              )
                          )
                      ),
                    ),
                  ),

                  //description text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Description',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),

                  //text-field for details
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)
                              ),
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.white
                              )
                          )
                      ),
                    ),
                  ),

                  //deadline text
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 12),
                    child: Text('Deadline',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white
                      ),
                    ),
                  ),

                  //box para sa date and time
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: [

                        //date entry part
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                readOnly: true,
                                onTap: selectDate,
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  hintText: 'DATE',
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)
                                      )
                                  ),
                                ),
                              ),
                            )
                        ),

                        //time entry part
                        Expanded(
                          child:  Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              readOnly: true,
                              onTap: selectTime,
                              controller: _timeController,
                              decoration: const InputDecoration(
                                hintText: 'TIME',
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.access_time),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)
                                    )
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  //add schedule button
                  SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                      child: ElevatedButton(
                        //balik sa activity screen
                        onPressed: () async {
                          //map sa tanan details
                          // Map<String, String> activityDetails = {
                          //   'subject': _subjectController.text,
                          //   'title': _titleController.text,
                          //   'description': _descriptionController.text,
                          //   'date': _dateController.text,
                          //   'time': _timeController.text,
                          //   'id': widget.id,
                          // };

                          updateActivity(_titleController.text, _descriptionController.text, _dateController.text, _timeController.text, result['id']);

                          String dateDeadline = _dateController.text;
                          String timeDeadline = _timeController.text;
                          String stringDateTime = '$dateDeadline $timeDeadline';
                          //covert from String to DateTime
                          DateTime deadlineDateTime = DateFormat('d MMMM y HH:mm a').parse(stringDateTime);

                          // delete notification
                          AwesomeNotifications().cancel(widget.id);
                          // add new notification
                          scheduleActivityNotif(deadlineDateTime, widget.id);

                          Map<String, dynamic> sendItTo = {
                            'activity_title': _titleController.text,
                            'description': _descriptionController.text,
                            'deadline_day': _dateController.text,
                            'deadline_time': _timeController.text,
                            'subject_title': _subjectController.text
                          };

                          // return screen with Map value
                          Navigator.pop(context, sendItTo);
                        },

                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFCC72C),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            )
                        ),
                        child: const Text('Apply Changes',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2100)
    );

    if (pickedDate != null) {
      setState(() {
        //convert the numbered month into words, I used intl.dart
        _dateController.text = DateFormat('d MMMM y').format(pickedDate);

        //this is old one, only outputs numbered date
        // _dateController.text = pickedDate.toString().split(" ")[0];
      });
    }
  }

  Future<void> selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (pickedTime != null) {
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
  }
}

