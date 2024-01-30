import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studysync/subjects.dart';
import 'package:studysync/allList.dart';

class AddSchedule extends StatelessWidget {
  const AddSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xff1E213D),
        appBar: AppBar(
          backgroundColor: const Color(0xff1E213D),
          title: const Text('Add Schedule',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        //SingleChildScrollView para dili mag pixel OVERFLOW
        body: const SingleChildScrollView(
          reverse: true,
          child: InputSchedule(),
        ),
      ),
    );
  }
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

class InputSchedule extends StatefulWidget {
  const InputSchedule({super.key});

  @override
  State<InputSchedule> createState() => _InputScheduleState();
}

class _InputScheduleState extends State<InputSchedule> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeInController = TextEditingController();
  final TextEditingController _timeOutController = TextEditingController();
  String dropdownValue = days.first;
  late Map<String, dynamic> result;

  // variable with Future<Album> type
  Future<Album>? futureAlbum;

  @override
  void dispose() {
    _subjectController.dispose();
    _dayController.dispose();
    _timeInController.dispose();
    _timeOutController.dispose();
    super.dispose();
  }

  Future<Album> createSchedule(String day, String time_in, String time_out, int subject_id) async {
    try {
      // Fetch existing schedules for the selected day
      var url = Uri.parse('http://studysync-api:8000/api/user/$userId/schedules');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Parse JSON response
        List<dynamic> schedules = jsonDecode(response.body);

        // Check for conflicts
        bool hasConflict = schedules.any((schedule) {
          // Parse the time strings into DateTime objects
          DateTime existingTimeIn = DateFormat('hh:mm a').parse(schedule['time_in']);
          DateTime existingTimeOut = DateFormat('hh:mm a').parse(schedule['time_out']);
          DateTime newTimeIn = DateFormat('hh:mm a').parse(time_in);
          DateTime newTimeOut = DateFormat('hh:mm a').parse(time_out);

          // Check if the new schedule overlaps with any existing schedule
          return (existingTimeIn.isBefore(newTimeOut) && existingTimeOut.isAfter(newTimeIn));
        });

        // If there's a conflict, return an error message
        if (hasConflict) {
          createAndShowSnackbar(context, 'Schedule conflicts with existing schedule.');
          return Album(success: false, message: 'Schedule conflicts with existing schedule.');
        } else {
          // If no conflict, proceed to create the schedule
          url = Uri.parse('http://studysync-api:8000/api/addSchedule');
          final response = await http.post(
              url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic> {
                'day': day,
                'time_in': time_in,
                'time_out': time_out,
                'subject_id': subject_id
              })
          );

          if (response.statusCode == 200) {
            // If the server did return a 200 OK response,
            // then parse the JSON.
            return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
          } else {
            // If the server did not return a 200 OK response,
            // throw an exception with the status code and response body.
            throw Exception('Failed to create album. Status code: ${response.statusCode}, Response body: ${response.body}');
          }
        }
      } else {
        // Handle HTTP error response
        throw Exception('Failed to fetch existing schedules. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur during the process.
      print('Error in createSchedule: $e');
      // Re-throw the exception to propagate it further.
      throw e;
    }
  }

  Future<void> createAndShowSnackbar(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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

          //add schedule button
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: ElevatedButton(

                //balik sa activity screen
                onPressed: () async {
                  // Map<String, dynamic> scheduleMap = {
                  //   'subject': _subjectController.text,
                  //   'day': _dayController.text,
                  //   'timeIn': _timeInController.text,
                  //   'timeOut': _timeOutController.text,
                  //   'selected': false,
                  // };

                  // Navigator.pop(context, scheduleMap);

                  try {
                    futureAlbum = createSchedule(_dayController.text, _timeInController.text, _timeOutController.text, result['id']);
                    Album? album = await futureAlbum;

                    if (album!.success) {
                      // If success is true, pop the navigator
                      Navigator.pop(context, result['id']);
                    }
                    else {
                      // Handle the case when success is false
                      print('Failed to create schedule. Message: ${album.message}');
                      // You can show an error message or take other actions if needed
                    }
                  }
                  catch (e) {
                    print('Error in onPressed: $e');
                    // Handle other exceptions that might occur during the process
                  }
                },

                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFCC72C),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    )
                ),
                child: const Text('Add Schedule',
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

