import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studysync/subjects.dart';
import 'package:studysync/allList.dart';
import 'package:http/http.dart' as http;

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

class EditSchedule extends StatefulWidget {
  int scheduleId;
  int subjectId;
  String subjectTitle;
  String day;
  String timeIn;
  String timeOut;

  EditSchedule({
    required this.scheduleId,
    required this.subjectId,
    required this.subjectTitle,
    required this.day,
    required this.timeIn,
    required this.timeOut,
    Key? key
}): super(key: key);

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectController;
  late final TextEditingController _dayController;
  late final TextEditingController _timeInController;
  late final TextEditingController _timeOutController;
  String dropdownValue = days.first;
  late var result;

  @override
  void initState() {
    _subjectController = TextEditingController(text: widget.subjectTitle);
    _dayController = TextEditingController(text: widget.day);
    _timeInController = TextEditingController(text: widget.timeIn);
    _timeOutController = TextEditingController(text: widget.timeOut);
    super.initState();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _dayController.dispose();
    _timeInController.dispose();
    _timeOutController.dispose();
    super.dispose();
  }
  
  Future<Album> updateSchedule(int schedule_id, int subject_id, String day, String time_in, String time_out) async {
    var url = Uri.parse('http://studysync-api:8000/api/schedule/${widget.scheduleId}');
    final response = await http.put(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'schedule_id': schedule_id,
        'subject_id': subject_id,
        'day': day,
        'time_in': time_in,
        'time_out': time_out,
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

  Future<Album> deleteSchedule(int scheduleId) async {
    var url = Uri.parse('http://studysync-api:8000/api/deleteSchedule/$scheduleId');

    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Schedule deleted successfully.');

      setState(() {
        // Remove the deleted schedule from the scheduleList
        scheduleList.removeWhere((schedule) => schedule['schedule_id'] == scheduleId);
      });

      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    else {
      print('Failed to delete schedule. Status code: ${response.statusCode}');
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
          title: const Text('Edit Schedule',
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

                //day dropdown-button
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Day',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)
                        ),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                                _dayController.text = dropdownValue;
                              });
                            },
                            items: days.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 12),
                  child: Text('Time',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white
                    ),
                  ),
                ),

                //boxes para sa time
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              readOnly: true,
                              onTap: selectTimeIn,
                              controller: _timeInController,
                              decoration: const InputDecoration(
                                hintText: 'Time in',
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

                      Expanded(
                        child:  Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            readOnly: true,
                            onTap: selectTimeOut,
                            controller: _timeOutController,
                            decoration: const InputDecoration(
                              hintText: 'Time Out',
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

                //edit schedule button
                SizedBox(
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
                            child:  SizedBox(
                              width: 180,
                              height: 80,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    // Update the schedule and get the result
                                    var sendItTo = await updateSchedule(widget.scheduleId, result['id'], _dayController.text, _timeInController.text, _timeOutController.text);

                                    // Return the result to the calling screen
                                    Navigator.pop(context, sendItTo);

                                  } catch (e) {
                                    // Handle errors if needed
                                    print('Error: $e');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightGreenAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    )
                                ),

                                child: const Text('Finish Edit',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),

                      // remove button
                      Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
                            child: SizedBox(
                              width: 180,
                              height: 80,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    var sendItTo = await deleteSchedule(widget.scheduleId);
                                    Navigator.pop(context, sendItTo);
                                  }
                                  catch (e) {
                                    // Handle errors if needed
                                    print('Error: $e');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF7676),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    )
                                ),

                                child: const Text('Remove Schedule',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectTimeIn() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (pickedTime != null) {
      setState(() {
        _timeInController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> selectTimeOut() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (pickedTime != null) {
      setState(() {
        _timeOutController.text = pickedTime.format(context);
      });
    }
  }
}

