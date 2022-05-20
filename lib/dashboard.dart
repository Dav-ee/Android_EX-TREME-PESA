import 'package:flutter/material.dart';
import 'package:flutter_auth/e-wallet.dart';
import 'package:flutter_auth/withdrawals.dart';
import 'package:flutter_auth/transfer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/models/usermodel.dart';
//widgets
import 'package:flutter_auth/constants/app_properties.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  UserModel loggedInUser = UserModel();
  bool isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;

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
      if (loggedInUser.email != null) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  CalculateExpense() {
    late int Expenses =  int.parse(loggedInUser.received.toString()) + int.parse(loggedInUser.sent.toString());
    return Expenses;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
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
          child: Padding(
            padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'WELCOME ${loggedInUser.name}!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      color: Colors.green[400],
                      boxShadow: [
                        BoxShadow(
                            color: transparentYellow,
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  height: 150,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Image.asset('assets/icons/wallet.png'),
                              onPressed:() {}
                            ),
                            Text(
                              'WALLET BALANCE',
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'KES ${loggedInUser.balance}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            WithdrawalsPage()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        color: Colors.purple[400],
                        boxShadow: [
                          BoxShadow(
                              color: transparentYellow,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 1))
                        ]),
                    height: 150,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/icons/denied_wallet.png'),
                                  onPressed:() {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            WithdrawalsPage()));

                                  }
                              ),
                              Text(
                                'WITHDRAWALS',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'KES ${loggedInUser.withdrawals}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            TransactionsPage()));
                  } ,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        color: Colors.red[400],
                        boxShadow: [
                          BoxShadow(
                              color: transparentYellow,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 1))
                        ]),
                    height: 150,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Image.asset('assets/icons/denied_wallet.png'),
                                  iconSize: 30,
                                  onPressed:() {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            TransactionsPage()));
                                  }
                              ),
                              Text(
                                'DEPOSITS',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'KES ${loggedInUser.deposit}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            TransferPage()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        color: Colors.orangeAccent[400],
                        boxShadow: [
                          BoxShadow(
                              color: transparentYellow,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 1))
                        ]),
                    height: 150,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset('assets/icons/card.png'),
                                onPressed:() {},
                              ),
                              Text(
                                'TRANSFERS',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'KES ${CalculateExpense()}',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),

                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

