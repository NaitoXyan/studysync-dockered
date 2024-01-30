import 'package:flutter/material.dart';
import 'allList.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// serves as a data model that represents the structure of an album object.
class Album {
  late bool success;
  late String message;
  late int id;

  Album({
    required this.success,
    required this.message,
  required this.id
  });

  // json to album convert thingie
  factory Album.fromJson(Map<String, dynamic> json) {
    // using pattern matching
    return switch (json) {
      {
      'success': bool success,
      'message': String message,
      'id': int id

      } => Album(success: success, message: message, id: id),
      _ => throw const FormatException('Failed to load album')
    };
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool navigate = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // variable with Future<Album> type
  Future<Album>? futureAlbum;

  loginPls() {
    return navigate = true;
  }

  Future<Album> createAlbum(String email, String password) async {
    var url = Uri.parse('http://studysync-api:8000/api/login');
    final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String> {
          'email': email,
          'password': password
        })
    );

    if (response.statusCode == 200 && jsonDecode(response.body)['success'] == true) {
      navigate = jsonDecode(response.body)['success'];
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      userId = jsonResponse['id'];
      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else {
      print('Failed to create album. Server responded with status code ${response.statusCode}');
      print('Error Message: ${response.body}');
      throw Exception('Failed to create album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF1E213D),
          title: const Text('Log In',
            style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold
            ),
          )
      ),
      backgroundColor: const Color(0xFF1E213D),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(left: 25, right: 25, top: 70),
              child: Text(
                'Email address',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),

            Padding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email address',
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

            const Padding(padding: EdgeInsets.only(left: 25, right: 25),
              child: Text(
                'Password',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),

            Padding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 55),
              child: TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: SizedBox(
                  width: 370,
                  height: 70,
                  child: ElevatedButton(
                      onPressed: () {
                        // setState(() {
                        //   futureAlbum = createAlbum(_emailController.text, _passwordController.text);
                        //   email = _emailController.text;
                        //   password = _passwordController.text;
                        // });

                        setState(() {
                          loginPls();
                        });

                        if (navigate == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage())
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF7DE),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),
                      )
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}


