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

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {

  final requiredValidator =
  RequiredValidator(errorText: 'This field is required');
  final formkey = GlobalKey<FormState>();
  late String _amount;

  Color active = Colors.red;
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


  Future<dynamic> startTransaction() async {
    if (checkFields()) {
      Fluttertoast.showToast(msg: "STK PUSH INITIATED");
      Fluttertoast.showToast(msg: "${_amount}");

      dynamic transactionInitialization;
      //Wrap it with a try-catch
      try {
        //Run it
        transactionInitialization =
        await MpesaFlutterPlugin.initializeMpesaSTKPush(
            businessShortCode:
            "4081251",
            //use your store number if the transaction type is CustomerBuyGoodsOnline
            transactionType: TransactionType
                .CustomerPayBillOnline,
            //or CustomerBuyGoodsOnline for till numbers
            amount: 5.0,
            partyA: "${loggedInUser.phone}",
            partyB: "4081251",
            callBackURL: Uri(
                scheme: "https",
                host: "1234.1234.co.ke",
                path: "/1234.php"),
            accountReference: "DAV_EE",
            phoneNumber: "${loggedInUser.phone}",
            baseUri: Uri(scheme: "https", host: "api.safaricom.co.ke"),
            transactionDesc: "MIRAALINK",
            passKey:
            "45397b2f504c82758834ece538f16ca307a43f07e80a3a25fedc266f13aaa34e");

        var result = transactionInitialization as Map<String, dynamic>;

        if (result.keys.contains("ResponseCode")) {
          String mResponseCode = result["ResponseCode"];
          print("Resulting Code: " + mResponseCode);
          // if (mResponseCode == '0') {
          //   updateAccount(result["CheckoutRequestID"]);
          // }
        }
        print("RESULT: " + transactionInitialization.toString());
      } catch (e) {
        //you can implement your exception handling here.
        //Network Reachability is a sure exception.
        print("Err");
        print("Exception Caught: " + e.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController phone = TextEditingController()..text = "${loggedInUser.phone}";
    Widget addThisCard = InkWell(
      onTap: () {
        MpesaFlutterPlugin.setConsumerKey('Vygc5jZmezkbruu2bPbpG3ZUxEGALwJ9');
        MpesaFlutterPlugin.setConsumerSecret('0zH5P2j1kS73JlF2');
        startTransaction();
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
          child: Text("DEPOSIT",
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
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
                backgroundColor: Colors.blueAccent,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
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
                          'MAKE DEPOSIT',
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
                                  'You will receive an STK push on your registered \nmobile number[ ${loggedInUser.phone} ].\n'
                                      'Enter M-PESA PIN to complete the transactions.\n'
                                      'Your account will be credited instantly \n',
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
                                readOnly: true,
                                controller: phone,
                                onChanged: (val) {
                                },
                                decoration: InputDecoration(
                                    labelText: 'Initiating number',
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
                                          labelText: 'Amount to deposit',
                                          border: InputBorder.none,
                                          hintText: 'Enter Amount'),
                                      validator: requiredValidator,
                                      onChanged: (val) =>
                                      _amount = val,
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

