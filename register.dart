import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/login.dart';
import 'package:flutter_auth/StartPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/models/usermodel.dart';
//widgets
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants/argon_theme.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String _email;
  late String _password;
  late String _fname;
  late String _lname;
  late String _phone;
  final int _balance = 0;
   final int  _deposit = 0;
  final int  _withdrawals = 0;
  final int  _received = 0;
  final int  _sent = 0;


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



  RegisterUser(){
    if(checkFields()){
      // Fluttertoast.showToast(msg: "${_name}");
      // Fluttertoast.showToast(msg: "${_phone}");
      // Fluttertoast.showToast(msg: "${_email}");
      // Fluttertoast.showToast(msg: "${_password}");
      Fluttertoast.showToast(msg: "Working on your request....");
//  do this
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)
          .then((uid) => {postValuesToFirestore()}
      ).catchError((e){
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

  postValuesToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();
    // writing all the values to user db
    final String new_phone =  _phone.substring(1);
    final String _name = _fname+ " " +_lname;
    userModel.phone = '254'+new_phone;
    userModel.email = _email;
    userModel.uid = user?.uid;
    userModel.name = _name;
    userModel.balance = _balance;
    userModel.deposit = _deposit;
    userModel.withdrawals = _withdrawals;
    userModel.received = _received;
    userModel.sent = _sent;

    await firebaseFirestore.collection("users").doc(user?.uid).set(
      userModel.toMap(),
    );
    Fluttertoast.showToast(msg: "Account created successfully");
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => StartPage()));
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
    Fluttertoast.showToast(msg: "GITHUB coming soon>>>>");
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
                      top:50, left: 24.0, right: 24.0, bottom: 32),
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
                                          width: 0.5,
                                          color: ArgonColors.muted))),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text("Sign up with",
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
                                          child: ElevatedButton(
                                              onPressed: (){
                                                _googleSignIn();
                                              },
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
                                                      Icon(
                                                          FontAwesomeIcons
                                                              .google,
                                                          size: 13),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("GOOGLE",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
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
                                                          FontAwesomeIcons
                                                              .github,
                                                          size: 13),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("GITHUB",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
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
                              height: MediaQuery.of(context).size.height * 0.83,
                              color: Color.fromRGBO(244, 245, 247, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                              child: TextFormField(
                                                  inputFormatters:  [
                                                    FilteringTextInputFormatter.deny(
                                                        RegExp(r'\s'))
                                                  ],
                                                  cursorColor: ArgonColors.muted,
                                                  autofocus: false,
                                                  validator: requiredValidator,
                                                  onChanged: (val) => _fname = val,
                                                  style:
                                                  TextStyle(height: 0.85, fontSize: 14.0, color: ArgonColors.initial),
                                                  textAlignVertical: TextAlignVertical(y: 0.6),
                                                  decoration: InputDecoration(
                                                      labelText: 'First Name',
                                                      filled: true,
                                                      fillColor: ArgonColors.white,
                                                      hintStyle: TextStyle(
                                                        color: ArgonColors.muted,
                                                      ),
                                                      prefixIcon: Icon(Icons.person),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4.0),
                                                          borderSide: BorderSide(
                                                              color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4.0),
                                                          borderSide: BorderSide(
                                                              color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                      hintText: "Enter Your First Name")),

                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                  inputFormatters:  [
                                                    FilteringTextInputFormatter.deny(
                                                        RegExp(r'\s'))
                                                  ],
                                                  cursorColor: ArgonColors.muted,
                                                  autofocus: false,
                                                  validator: requiredValidator,
                                                  onChanged: (val) => _lname = val,
                                                  style:
                                                  TextStyle(height: 0.85, fontSize: 14.0, color: ArgonColors.initial),
                                                  textAlignVertical: TextAlignVertical(y: 0.6),
                                                  decoration: InputDecoration(
                                                      labelText: 'Last Name',
                                                      filled: true,
                                                      fillColor: ArgonColors.white,
                                                      hintStyle: TextStyle(
                                                        color: ArgonColors.muted,
                                                      ),
                                                      prefixIcon: Icon(Icons.person),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4.0),
                                                          borderSide: BorderSide(
                                                              color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4.0),
                                                          borderSide: BorderSide(
                                                              color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                      hintText: "Enter Your Last Name")),

                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                  inputFormatters:  <TextInputFormatter>[FilteringTextInputFormatter. digitsOnly],
                                                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                                  keyboardType: TextInputType.number,
                                                  maxLength: 10,
                                                  cursorColor: ArgonColors.muted,
                                                  autofocus: false,
                                                  validator: requiredValidator,
                                                  onChanged: (val) => _phone = val,
                                                  style:
                                                  TextStyle(height: 0.85, fontSize: 14.0, color: ArgonColors.initial),
                                                  textAlignVertical: TextAlignVertical(y: 0.6),
                                                  decoration: InputDecoration(
                                                      labelText: 'Phone Number',
                                                      filled: true,
                                                      fillColor: ArgonColors.white,
                                                      hintStyle: TextStyle(
                                                        color: ArgonColors.muted,
                                                      ),

                                                      prefixIcon: Icon(Icons.phone),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4.0),
                                                          borderSide: BorderSide(
                                                              color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4.0),
                                                          borderSide: BorderSide(
                                                              color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                      hintText: "Enter phone number i.e 07123...")),

                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                  inputFormatters:  [
                                                    FilteringTextInputFormatter.deny(
                                                        RegExp(r'\s'))
                                                  ],
                                                  cursorColor: ArgonColors.muted,
                                                  autofocus: false,
                                                  validator: emailValidator,
                                                  onChanged: (val) => _email = val,
                                                  style:
                                                  TextStyle(height: 0.85, fontSize: 14.0, color: ArgonColors.initial),
                                                  textAlignVertical: TextAlignVertical(y: 0.6),
                                                  decoration: InputDecoration(
                                                      labelText: 'Email Address',
                                                      filled: true,
                                                      fillColor: ArgonColors.white,
                                                      hintStyle: TextStyle(
                                                        color: ArgonColors.muted,
                                                      ),

                                                      prefixIcon: Icon(Icons.email),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4.0),
                                                          borderSide: BorderSide(
                                                              color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4.0),
                                                          borderSide: BorderSide(
                                                              color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                      hintText: "Enter Your email address")),

                                            ),
                                            Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                    inputFormatters:  [
                                                      FilteringTextInputFormatter.deny(
                                                          RegExp(r'\s'))
                                                    ],
                                                    cursorColor: ArgonColors.muted,
                                                    autofocus: false,
                                                    obscureText: true,
                                                    validator: passwordValidator,
                                                    onChanged: (val) => _password = val,
                                                    style:
                                                    TextStyle(height: 0.85, fontSize: 14.0, color: ArgonColors.initial),
                                                    textAlignVertical: TextAlignVertical(y: 0.6),
                                                    decoration: InputDecoration(
                                                        labelText: 'Password',
                                                        filled: true,
                                                        fillColor: ArgonColors.white,
                                                        hintStyle: TextStyle(
                                                          color: ArgonColors.muted,
                                                        ),
                                                        // suffixIcon: Icon(Icons.password),
                                                        prefixIcon: Icon(Icons.lock),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(4.0),
                                                            borderSide: BorderSide(
                                                                color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(4.0),
                                                            borderSide: BorderSide(
                                                                color: ArgonColors.border, width: 1.0, style: BorderStyle.solid)),
                                                        hintText: "Enter Your password"))
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 24.0),
                                              child: RichText(
                                                  text: TextSpan(
                                                      text: "password should be more than 4 characters long: ",
                                                      style: TextStyle(
                                                          color:
                                                          ArgonColors.muted),
                                                      children: [
                                                        TextSpan(
                                                            text: "strong",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                color: ArgonColors
                                                                    .success))
                                                      ])),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20),
                                              child: Center(
                                                child: FlatButton(
                                                  textColor: ArgonColors.white,
                                                  color: ArgonColors.primary,
                                                  onPressed:  () {
                                                    RegisterUser();
                                                    // Navigator.push(context,
                                                    //     MaterialPageRoute(builder: (context) => StartUpPage()));
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
                                                      child: Text("REGISTER NOW",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 16.0))),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 0, bottom: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            // Checkbox(
                                            //     activeColor:
                                            //     ArgonColors.primary,
                                            //     onChanged: onChanged(), value: ,
                                            // ),
                                            Text("Already have an account? ",
                                                style: TextStyle(
                                                    color: ArgonColors.muted,
                                                    fontWeight:
                                                    FontWeight.w200)),
                                            GestureDetector(
                                                onTap:  () {
                                                  Navigator.pop(context);
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) =>LoginPage()));
                                                }
                                                ,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.only(left: 5),
                                                  child: Text("LOGIN NOW",
                                                      style: TextStyle(
                                                          color: ArgonColors
                                                              .primary)),
                                                )),
                                          ],
                                        ),
                                      ),
                                      //removed reg btn here
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
  controller() {}
  tap() {}
}

