import 'package:flutter/material.dart';
import 'package:flutter_auth/settings.dart';
import 'package:flutter_auth/support.dart';
import 'package:flutter_auth/StartPage.dart';
import 'package:flutter_auth/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avatars/avatars.dart';
//widgets
import 'package:flutter_auth/constants/app_properties.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
      if(loggedInUser.name != null){
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController()..text = "${loggedInUser.email}";
    TextEditingController _uid = TextEditingController()..text = "${loggedInUser.uid}";
    TextEditingController _fname = TextEditingController()..text = "${loggedInUser.name}";
    TextEditingController _phone = TextEditingController()..text = "${loggedInUser.phone}";
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        top: true,
        child:   (isLoading)
            ? Center(
          child:
          SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
              strokeWidth: 2,
            ),
          ),
        )
            :SingleChildScrollView(
          child: Padding(
            padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Your saved info are displayed here.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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
                CircleAvatar(
                  radius: 50,
                  child: Text(
                    '${loggedInUser.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 10
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${loggedInUser.name}',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(16.0),
                  height: 340,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: shadow,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Container(
                          padding: EdgeInsets.only(left: 16.0),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey[200],
                          ),
                          child: TextField(
                            readOnly: true,
                            controller: _fname,
                            onChanged: (val) {
                            },
                            decoration: InputDecoration(
                                labelText: 'Full Name',
                                border: InputBorder.none,
                                hintText: 'Full Name'),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child:  Container(
                                padding: EdgeInsets.only(left: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  color: Colors.grey[200],
                                ),
                                child: TextField(
                                  readOnly: true,
                                  controller: _email,
                                  onChanged: (val) {
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Email Address',
                                      border: InputBorder.none,
                                      hintText: 'Email Address'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child:  Container(
                                padding: EdgeInsets.only(left: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  color: Colors.grey[200],
                                ),
                                child: TextField(
                                  readOnly: true,
                                  controller: _phone,
                                  onChanged: (val) {
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      border: InputBorder.none,
                                      hintText: 'Phone Number'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child:  Container(
                                padding: EdgeInsets.only(left: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  color: Colors.grey[200],
                                ),
                                child: TextField(
                                  readOnly: true,
                                  controller: _uid,
                                  onChanged: (val) {
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'My Unique ID',
                                      border: InputBorder.none,
                                      hintText: 'Unique ID'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ),

                SizedBox(height: 15.0),

                ListTile(
                  title: Text('Settings'),
                  subtitle: Text('Privacy and logout'),
                  leading: Image.asset('assets/icons/settings_icon.png', fit: BoxFit.scaleDown, width: 30, height: 30,),
                  trailing: Icon(Icons.chevron_right, color: yellow),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SettingsPage())),
                ),
                Divider(),
                ListTile(
                  title: Text('Help & Support'),
                  subtitle: Text('Help center and legal support'),
                  leading: Image.asset('assets/icons/support.png'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: yellow,
                  ),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SupportPage())),
                ),
                Divider(),
                // ListTile(
                //   title: Text('FAQ'),
                //   subtitle: Text('Questions and Answer'),
                //   leading: Image.asset('assets/icons/faq.png'),
                //   trailing: Icon(Icons.chevron_right, color: yellow),
                //   onTap: () => Navigator.of(context).push(
                //       MaterialPageRoute(builder: (_) => FaqPage())),
                // ),
                // Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

