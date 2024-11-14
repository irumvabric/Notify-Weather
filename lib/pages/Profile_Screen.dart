import 'package:flutter/material.dart';
import 'package:weather/ui_settings/themes.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({super.key});

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  List<String> tempUnit = ['Celesius', 'Faranheight'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 74, 173),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('Brice Berry Irumva'),
                SizedBox(width: 20),
                Image(
                  image: AssetImage('assets/Notify.png'),
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            SizedBox(height: 50),
            Center(child: Text('Settings', style: headingTextStyle)),
            SizedBox(height: 40),
            ListView(
              children: [
                Row(
                  children: [
                    Text("Change the Temperature Unit (From Celecius)",
                        style: subheadingTextStyle),
                  ],
                ),
                Row(
                  children: [
                    Text("Change the Temperature Unit (From Celecius)"),
                  ],
                ),
                Row(
                  children: [
                    Text("Change the Temperature Unit (From Celecius)"),
                  ],
                ),
                Row(
                  children: [
                    Text("Change the Temperature Unit (From Celecius)"),
                  ],
                ),
                Row(
                  children: [
                    Text("Change the Temperature Unit (From Celecius)"),
                  ],
                ),
                Row(
                  children: [
                    Text("Change the Temperature Unit (From Celecius)"),
                  ],
                ),
                Row(
                  children: [
                    Text("Change the Temperature Unit (From Celecius)"),
                  ],
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: subheadingTextStyle),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child:
                        Text('Sign up', style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
