import 'package:flutter/material.dart';
import 'package:flutter_auth/login.dart';
import 'package:flutter_auth/change_password.dart';
//import 'package:flutter_auth/about_dev.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'StartPage.dart';
//widgets
import 'package:flutter_auth/constants/app_properties.dart';
import 'package:flutter_auth/constants/custom_background.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        body: SafeArea(
          bottom: true,
          child: LayoutBuilder(
              builder:(builder,constraints)=> SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'General',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              IconButton(
                                iconSize: 35,
                                color: Colors.red, icon: Icon(Icons.close), onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => StartPage()));
                              },
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text('Change Password'),
                          leading: Image.asset('assets/icons/change_pass.png'),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ChangePassword())),
                        ),
                        ListTile(
                          title: Text('Sign out'),
                          leading: Image.asset('assets/icons/sign_out.png'),
                          onTap: () {
                            _signOut();
                            Navigator.pop(context);
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => LoginPage()));
                          },
                        ),],
                    ),
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
