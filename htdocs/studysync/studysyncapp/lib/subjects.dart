import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'allList.dart';

// serves as a data model that represents the structure of an album object.
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

class Subjects extends StatefulWidget {
  const Subjects({super.key});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  //main subject screen
  final subjectController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? subjectIndex;
  String subjectCardKey = '';
  late int subjectIdKey;
  late Future subjectFuture;

  // variable with Future<Album> type
  Future<Album>? futureAlbum;

  @override
  void initState() {
    subjectFuture = getSubject();
    super.initState();
    // subjectListGet();
  }

  @override
  void dispose () {
    subjectController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> getSubject() async {
    var url = Uri.parse('http://studysync-api:8000/api/subject/$userId');
    var response = await http.get(url);

    print(jsonDecode(response.body));
    subjectList = jsonDecode(response.body);

    print(subjectList);
    return subjectList;
  }

  Future<void> refreshSubjectList() async {
    // Call getSubject to refresh the subjectList
    var updatedSubjectList = await getSubject();
    setState(() {
      subjectList = updatedSubjectList;
    });
  }

  Future<Album> createSubject(String subject_title, int user_id) async {
    var url = Uri.parse('http://studysync-api:8000/api/addSubject');
    final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic> {
          'subject_title': subject_title,
          'user_id': userId
        })
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // Call refreshSubjectList to update the UI
      await refreshSubjectList();
      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<void> deleteSubject(int subjectId) async {
    var url = Uri.parse('http://studysync-api:8000/api/subject/$subjectId');

    try {
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Subject deleted successfully.');
        setState(() {
          // Remove the deleted subject from the subjectList
          subjectList.removeWhere((subject) => subject['id'] == subjectId);
        });
      } else {
        print('Failed to delete subject. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff1E213D),
        appBar: AppBar(
          backgroundColor: const Color(0xff1E213D),
          title: const Text('Subjects',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
          ),
          leading: BackButton(
            onPressed: () {
              Map<String, dynamic> passValues = {
                'id': subjectIdKey,
                'title': subjectCardKey
              };
              // String sendSubjectToPrevScreen = subjectCardKey;
              Navigator.pop(context, passValues);
            },
          ),
        ),

        body: Column(
          children: [
            Flexible(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: subjectListBuilder()
                ),
              ),
            ),

            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> passValues = {
                          'id': subjectIdKey,
                          'title': subjectCardKey
                        };
                        // String sendSubjectToPrevScreen = subjectCardKey;
                        Navigator.pop(context, passValues);
                      },
                      child: const Text('choose subject',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600
                        ),
                      )
                  ),
                ),
              ),
            ),

            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
                child: addSubjectFillUp(),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget subjectListBuilder() {
    return FutureBuilder(
      future: subjectFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: subjectList.length,

            itemBuilder: (context, index) {
              return Card(
                color: subjectIndex == index ? Colors.blue: null,
                child: ListTile(
                  onTap: () {
                    setState(() {
                      subjectIndex = index;
                      subjectCardKey = subjectList[index]['title'];
                      subjectIdKey = subjectList[index]['id'];
                    });
                  },

                  leading: const Icon(Icons.book_rounded),
                  title: Text(subjectList[index]['title']),
                  trailing: trailingButton(index),
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
      }
    );
  }

  ListTileTitleAlignment? titleAlignment;
  Widget trailingButton(int index) {
    return PopupMenuButton<ListTileTitleAlignment>(
        onSelected: (ListTileTitleAlignment? value) {
          setState(() {
            titleAlignment = value;
          });
        },

        itemBuilder: (BuildContext context) =>
        <PopupMenuEntry<ListTileTitleAlignment>>[
          PopupMenuItem<ListTileTitleAlignment>(
            onTap:() {
              setState(() {
                deleteSubject(subjectList[index]['id']);
              });
            },
            value: ListTileTitleAlignment.center,
            child: const Text("delete"),

          )
        ]
    );
  }

  Widget addSubjectFillUp() {
    return Column(
      children: [
        TextFormField(
          controller: subjectController,
          focusNode: _focusNode,
          style: const TextStyle(
            color: Colors.white
          ),
          decoration: const InputDecoration(
            labelText: 'Enter subject Title',
            labelStyle: TextStyle(
              color: Colors.white
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white
              )
            )
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: SizedBox(
            width: 250,
            height: 70,
            child: ElevatedButton(
                onPressed: () {

                  setState(() {
                    futureAlbum = createSubject(subjectController.text, userId);
                    // Clear the text field
                    subjectController.clear();
                  });

                },
                child: const Text('add new subject',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w600
                  ),
                )
            ),
          ),
        )
      ],
    );
  }
}