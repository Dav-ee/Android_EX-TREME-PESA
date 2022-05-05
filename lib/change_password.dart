import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/StartPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_auth/models/usermodel.dart';
import 'package:flutter_auth/settings.dart';
import 'package:form_field_validator/form_field_validator.dart';
//widgets
import 'package:flutter_auth/constants/app_properties.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
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
      if(loggedInUser.email != null){
        setState(() {
          isLoading = false;
        });
      }
    });
  }


  late String _email;
  final formkey = GlobalKey<FormState>();
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address')
  ]);



  void Resetpassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: loggedInUser.email.toString())
        .then((uid) => {
      Fluttertoast.showToast(
          msg: "E-mail has been sent successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      ),
    Navigator.pop(context),
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => StartPage())),
    })
        .catchError((e) {
      Fluttertoast.showToast(
          msg:  e!.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController()..text = "${loggedInUser.email}";

    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget changePasswordButton = InkWell(
      onTap: () {
        Resetpassword();
      },
      child: Container(
        height: 40,
        width: width / 1.7,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: Text("Request Reset",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 17.0)),
        ),
      ),
    );

    return   Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          bottom: true,
          child:    (isLoading)
              ? Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeWidth: 2,
              ),
            ),
          )
              :LayoutBuilder(
            builder: (b, constraints) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0,top:16.0),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Change Password',
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
                                      MaterialPageRoute(builder: (context) => SettingsPage()));

                                },
                                ),
                              ],
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0,top:5.0),
                            child: Text(
                              'Email containing further instructions will be sent to your registred with us email (${loggedInUser.email})',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0, top: 20),
                            child: Text(
                              'Your Email Address',
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 1.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                              child: TextField(
                                readOnly: true,
                                controller: email,
                                decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    border: InputBorder.none,
                                    hintText: 'Your email',
                                    hintStyle: TextStyle(fontSize: 12.0)),
                              ),),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 15.0,
                                  bottom: bottomPadding != 40 ? 40 : bottomPadding),
                              width: width,
                              child: Center(child: changePasswordButton),
                            ),
                          )


                        ],
                      ),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Container(
                      //     padding: EdgeInsets.only(
                      //         top: 8.0,
                      //         bottom: bottomPadding != 40 ? 40 : bottomPadding),
                      //     width: width,
                      //     child: Center(child: changePasswordButton),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
