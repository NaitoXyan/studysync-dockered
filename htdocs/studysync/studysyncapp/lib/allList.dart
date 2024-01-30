import 'dart:convert';
import 'package:http/http.dart' as http;

//user creds
late var userId;
late var email;
late var password;

// list for days
List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

// list for activities
List<dynamic> activitiesList = [];

List<dynamic> scheduleList = [];

List<dynamic> subjectList = [];

