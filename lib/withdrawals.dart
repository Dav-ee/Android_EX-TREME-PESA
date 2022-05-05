import 'package:flutter/material.dart';
import 'StartPage.dart';
import 'package:flutter_auth/constants/app_properties.dart';
import 'package:flutter_auth/constants/color_list.dart';
import 'package:flutter_auth/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

class WithdrawalsPage extends StatefulWidget {
  const WithdrawalsPage({Key? key}) : super(key: key);

  @override
  State<WithdrawalsPage> createState() => _WithdrawalsPageState();
}

class _WithdrawalsPageState extends State<WithdrawalsPage> {
  final requiredValidator =
  RequiredValidator(errorText: 'This field is required. Kindly enter amount!');
  final formkey = GlobalKey<FormState>();
  late int _amount;

  Color active = Colors.purple;
  TextEditingController cardNumber = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController cvc = TextEditingController();
  TextEditingController cardHolder = TextEditingController();
  ScrollController scrollController = ScrollController();


  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection.index == 1) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });

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

  checkFields() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  MakeWithdrawals(){
    if (checkFields()) {
          int? getBAL = loggedInUser.balance;
          if(getBAL! < _amount ){
            Fluttertoast.showToast(msg: "Error! You have Low balance. Withdrawal failed");
          }
          else if(getBAL > _amount ){
            //  withdraw B2C here
          }
    }
  }



  @override
  Widget build(BuildContext context) {
    TextEditingController phone = TextEditingController()..text = "${loggedInUser.phone}";
    Widget addThisCard = InkWell(
      onTap: () {
        MakeWithdrawals();
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width / 1.5,
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
          child: Text("WITHDRAW FUNDS",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (_, constraints) => GestureDetector(
          onPanDown: (val) {},
          behavior: HitTestBehavior.opaque,
          child:   (isLoading)
              ? Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeWidth: 3,
              ),
            ),
          )
              :SingleChildScrollView(
            controller: scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: kToolbarHeight),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'MAKE WITHDRAWALS',
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 20,
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
                    SizedBox(height:25.0),
                    Container(
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                          color: active,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'X-TREME PESA',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),

                          SizedBox(height: 5.0),
                          Text(
                            'BALANCE : KES ${loggedInUser.balance}',
                            style: TextStyle(color: Colors.white,fontSize: 12),
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: <Widget>[
                              Container(
                                height: 5,
                                width: 180,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                          Text(cardHolder.text,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Colors.red,
                          Colors.blue,
                          Colors.purple[700],
                          Colors.green[700],
                          Colors.lightBlueAccent
                        ]
                            .map((c) => InkWell(
                          onTap: () {
                            setState(() {
                              active = c ?? Colors.red;
                            });
                          },
                          child: Transform.scale(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ColorOption(c ?? Colors.red),
                              ),
                              scale: active == c ? 1.2 : 1),
                        ))
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: shadow,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: Form(
                        key: formkey,
                        child: Column(

                          children: <Widget>[
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                      'Funds will be sent to your registered mobile number [ ${loggedInUser.phone} ]\n'
                                          'Upon successful withdrawal your account will be credited instantly \n',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  iconSize: 30,
                                  color: Colors.red, icon: Icon(Icons.info_outline_rounded), onPressed: () {
                                },
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 16.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                color: Colors.grey[200],
                              ),
                              child: TextFormField(
                                validator: requiredValidator,
                                controller: phone,
                                readOnly: true,
                                onChanged: (val) {
                                },
                                decoration: InputDecoration(
                                    labelText: 'Funds to will be credited to this number',
                                    border: InputBorder.none,
                                    hintText: 'Mobile Number'),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 16.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                      color: Colors.grey[200],
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Amount to withdraw',
                                          border: InputBorder.none,
                                          hintText: 'Enter Amount'),
                                      validator: requiredValidator,
                                      onChanged: (val) =>
                                      _amount = int.parse(val),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: addThisCard,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

