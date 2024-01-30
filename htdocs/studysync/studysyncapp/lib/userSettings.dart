import 'package:flutter/material.dart';
import 'package:studysync/openingScreen.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String generateRandomCode() => 'ABC123';

  TextEditingController enterCodeController = TextEditingController();
  bool scheduleToggle = true;
  bool activitiesToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'StudySync',
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF1E213D),
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFFFCC72C),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text('Menu Bar', style: TextStyle(fontFamily: 'Lato')),
              ),
              buildDrawerItem('Item 1'),
              buildDrawerItem('Item 2'),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFFADDAD),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildEditProfileButton(),
          buildUserProfile(),
          buildSharedSpaceHeader(),
          buildChooseToShare(),
          buildToggleSwitch('Schedule', scheduleToggle, (value) {
            setState(() {
              scheduleToggle = value;
            });
          }),
          buildToggleSwitch('Activities', activitiesToggle, (value) {
            setState(() {
              activitiesToggle = value;
            });
          }),
          buildInviteOrJoinPeople(),
          SizedBox(height: 16),
          buildShareCodeSection(),
          SizedBox(height: 16),
          buildDoneButton(),
          SizedBox(height: 16),
          buildJoinSharedSpaceSection(),
          SizedBox(height: 16),
          buildLogoutButton(),
        ],
      ),
    );
  }

  Widget buildDrawerItem(String title) {
    return ListTile(
      title: Text(title, style: TextStyle(fontFamily: 'Lato')),
      onTap: () {
        // Handle item click
      },
    );
  }

  Widget buildEditProfileButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
          },
          child: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.blue, fontFamily: 'Lato'),
          ),
        ),
      ],
    );
  }

  Widget buildUserProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          // backgroundImage: AssetImage('assets/profile_image.jpg'),
        ),
        SizedBox(height: 16),
        Text(
          'Username',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lato'),
        ),
      ],
    );
  }

  Widget buildSharedSpaceHeader() {
    return Container(
      color: Color(0xFF212761),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      child: Text(
        'Shared Space',
        style: TextStyle(color: Color(0xFFFCC72C), fontWeight: FontWeight.bold, fontFamily: 'Lato'),
      ),
    );
  }

  Widget buildChooseToShare() {
    return Container(
      color: Color(0xFFFCC72C),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      child: Center(
        child: Text(
          'Choose what to share',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Lato'),
        ),
      ),
    );
  }

  Widget buildToggleSwitch(String text, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF1F255D),
        ),
        Text(text, style: TextStyle(fontFamily: 'Lato')),
      ],
    );
  }

  Widget buildInviteOrJoinPeople() {
    return Container(
      color: Color(0xFFFCC72C),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      child: Center(
        child: Text(
          'Invite or Join people',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Lato'),
        ),
      ),
    );
  }

  Widget buildShareCodeSection() {
    return Column(
      children: [
        Text('Share Code', style: TextStyle(fontFamily: 'Lato')),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildRandomCode(),
            SizedBox(width: 8),
            buildCopyButton(),
          ],
        ),
      ],
    );
  }

  Widget buildRandomCode() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF212761),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(
          generateRandomCode(),
          style: TextStyle(color: Color(0xFFFCC72C), fontWeight: FontWeight.bold, fontFamily: 'Lato'),
        ),
      ),
    );
  }

  Widget buildCopyButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle copy button click
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF21C713),
      ),
      child: Text('Copy', style: TextStyle(color: Colors.white, fontFamily: 'Lato')),
    );
  }

  Widget buildDoneButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle done button click
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF21C713),
      ),
      child: Text('Done', style: TextStyle(color: Colors.white, fontFamily: 'Lato')),
    );
  }

  Widget buildJoinSharedSpaceSection() {
    return Column(
      children: [
        Text('Join a shared space', style: TextStyle(fontFamily: 'Lato')),
        SizedBox(height: 8),
        buildEnterCodeTextField(),
        SizedBox(height: 8),
        buildJoinButton(),
      ],
    );
  }

  Widget buildEnterCodeTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1D2256),
        borderRadius: BorderRadius.circular(10),
      ),
      width: 200, // Adjust the width as needed
      child: TextField(
        controller: enterCodeController,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter Code',
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildJoinButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle join button click
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF21C713),
      ),
      child: Text('Join', style: TextStyle(color: Colors.white, fontFamily: 'Lato')),
    );
  }

  Widget buildLogoutButton() {
    return Container(
      width: double.infinity,
      color: Color(0xFFFCC72C),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => OpeningScreen())
          );
        },
        style: ElevatedButton.styleFrom(primary: Color(0xFFFCC72C)),
        child: Text('Log-Out', style: TextStyle(fontFamily: 'Lato', color: Colors.black)),
      ),
    );
  }
}
