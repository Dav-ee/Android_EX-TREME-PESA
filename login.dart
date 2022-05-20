import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register.dart';
import 'resetpassword.dart';
import 'StartPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/models/usermodel.dart';
//widgets
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants/argon_theme.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    if(user != null){
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
        if (loggedInUser.phone != null) {
          takeMeDashboard();
        }
      });
    }
  }

  takeMeDashboard(){
    Navigator.pop(context);
    Navigator.push(context,
    MaterialPageRoute(builder: (context) =>
    StartPage()));
  }


  late String _email;
  late String _password;
  final formkey = GlobalKey<FormState>();

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address')
  ]);
  final requiredValidator =
  RequiredValidator(errorText: 'This field is required');
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText:
        'Passwords must have at least one special character i.e /*&%%(')
  ]);


  checkFields() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  inputfomart_email_pwd(){
      FilteringTextInputFormatter.deny(
          RegExp(r'\s'));
  }

  loginUser() {
    if (checkFields()) {
       Fluttertoast.showToast(msg: "${_email}");
      Fluttertoast.showToast(msg: "Authenticating..");
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((uid) {
        Fluttertoast.showToast(
            msg: "Login  successful ${_email}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_LEFT,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StartPage()));
      }).catchError((e) {
        Fluttertoast.showToast(
            msg: e!.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_LEFT,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }


    Future<void> _googleSignIn() async {
       Fluttertoast.showToast(msg: "Google HTTP 400");
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          try {
            final authResult = await   FirebaseAuth.instance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken),
            );
            // var date = DateTime.now().toString();
            var date = authResult.user!.metadata.creationTime.toString();
            var dateParse = DateTime.parse(date);
            var formattedDate =
                '${dateParse.day}-${dateParse.month}-${dateParse.year}';
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'uid': authResult.user!.uid,
              'name': authResult.user!.displayName,
              'email': authResult.user!.email,
              'phone': authResult.user!.phoneNumber,
              'imageUrl': authResult.user!.photoURL,
              'joinedAt': formattedDate,
              'createdAt': date,
              'balance': 0,
              'deposit': 0,
              'received': 0,
              'sent': 0,
              'transfer': 0,
              'withdrawals': 0,
            });

            Fluttertoast.showToast(
                msg: "Login  successful ${authResult.user!.email}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER_LEFT,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => StartPage()));

          }
          catch (error) {
            print('error occurred ${error.toString()}');
          }
        }
      }
    }

  _githubSignIn(){
    Fluttertoast.showToast(msg: "Github coming soon>>>>");
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/register-bg.png"),
                      fit: BoxFit.cover)),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 50, left: 24.0, right: 24.0, bottom: 32),
                  child: Card(
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  color: ArgonColors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.5, color: ArgonColors.muted))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text("Login  with",
                                            style: TextStyle(
                                                color: ArgonColors.text,
                                                fontSize: 16.0)),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          // width: 0,
                                          height: 36,
                                          child: RaisedButton(
                                              textColor: ArgonColors.primary,
                                              color: ArgonColors.secondary,
                                              onPressed: () {
                                                _googleSignIn();
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(4)),
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10,
                                                      top: 10,
                                                      left: 14,
                                                      right: 14),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                    children: [
                                                      Icon(FontAwesomeIcons.google,
                                                          size: 13),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("GOOGLE",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 13))
                                                    ],
                                                  ))),
                                        ),
                                        Container(
                                          // width: 0,
                                          height: 36,
                                          child: RaisedButton(
                                              textColor: ArgonColors.primary,
                                              color: ArgonColors.secondary,
                                              onPressed: () {
                                                _githubSignIn();
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(4)),
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10,
                                                      top: 10,
                                                      left: 8,
                                                      right: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                    children: [
                                                      Icon(
                                                          FontAwesomeIcons.github,
                                                          size: 13),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("GITHUB",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 13))
                                                    ],
                                                  ))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Divider()
                                ],
                              )),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.43,
                              color: Color.fromRGBO(244, 245, 247, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Form(
                                        key: formkey,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                    inputFormatters:  [
                                                      FilteringTextInputFormatter.deny(
                                                          RegExp(r'\s'))
                                                    ],
                                                    cursorColor: ArgonColors.muted,
                                                    autofocus: false,
                                                    validator: emailValidator,
                                                    onChanged: (val) =>
                                                    _email = val,
                                                    style: TextStyle(
                                                        height: 0.85,
                                                        fontSize: 14.0,
                                                        color: ArgonColors.initial),
                                                    textAlignVertical:
                                                    TextAlignVertical(y: 0.6),
                                                    decoration: InputDecoration(
                                                        labelText: 'Email Address',
                                                        filled: true,
                                                        fillColor:
                                                        ArgonColors.white,
                                                        hintStyle: TextStyle(
                                                          color: ArgonColors.muted,
                                                        ),
                                                        prefixIcon:
                                                        Icon(Icons.email),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                4.0),
                                                            borderSide: BorderSide(
                                                                color: ArgonColors
                                                                    .border,
                                                                width: 1.0,
                                                                style: BorderStyle
                                                                    .solid)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                4.0),
                                                            borderSide: BorderSide(
                                                                color: ArgonColors
                                                                    .border,
                                                                width: 1.0,
                                                                style: BorderStyle
                                                                    .solid)),
                                                        hintText: "Enter email address")),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                    inputFormatters:  [
                                                      FilteringTextInputFormatter.deny(
                                                          RegExp(r'\s'))
                                                    ],
                                                    obscureText: true,
                                                    cursorColor: ArgonColors.muted,
                                                    autofocus: false,
                                                    validator: passwordValidator,
                                                    onChanged: (val) =>
                                                    _password = val,
                                                    style: TextStyle(
                                                        height: 0.85,
                                                        fontSize: 14.0,
                                                        color: ArgonColors.initial),
                                                    textAlignVertical:
                                                    TextAlignVertical(y: 0.6),
                                                    decoration: InputDecoration(
                                                        labelText: 'Password',
                                                        filled: true,
                                                        fillColor:
                                                        ArgonColors.white,
                                                        hintStyle: TextStyle(
                                                          color: ArgonColors.muted,
                                                        ),
                                                        // suffixIcon:
                                                        // Icon(Icons.password),
                                                        prefixIcon:
                                                        Icon(Icons.lock),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                4.0),
                                                            borderSide: BorderSide(
                                                                color: ArgonColors
                                                                    .border,
                                                                width: 1.0,
                                                                style: BorderStyle
                                                                    .solid)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                4.0),
                                                            borderSide: BorderSide(
                                                                color: ArgonColors
                                                                    .border,
                                                                width: 1.0,
                                                                style: BorderStyle
                                                                    .solid)),
                                                        hintText: "Enter password")),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 10),
                                              child: Center(
                                                child: FlatButton(
                                                  textColor: ArgonColors.white,
                                                  color: ArgonColors.primary,
                                                  onPressed: () {
                                                    loginUser();
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(4.0),
                                                  ),
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16.0,
                                                          top: 12,
                                                          bottom: 12),
                                                      child: Text("LOGIN",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 16.0))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 0, bottom: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text("Don\'t have an account?",
                                                style: TextStyle(
                                                    color: ArgonColors.muted,
                                                    fontWeight: FontWeight.w200)),
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RegisterPage()));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 5),
                                                  child: Text("REGISTER NOW",
                                                      style: TextStyle(
                                                          color:
                                                          ArgonColors.primary)),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 0, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text("Forgot your password?",
                                                style: TextStyle(
                                                    color: ArgonColors.muted,
                                                    fontWeight: FontWeight.w200)),
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ResetPasswordPage()));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 5),
                                                  child: Text("RESET NOW",
                                                      style: TextStyle(
                                                          color:
                                                          ArgonColors.primary)),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      )),
                ),
              ]),
            )
          ],
        ));
  }
  tap() {}
  controller() {}
}

