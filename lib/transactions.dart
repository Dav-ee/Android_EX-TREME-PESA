import 'package:flutter/material.dart';
import 'package:flutter_auth/t_page/constant.dart';
import 'package:flutter_auth/t_page/round_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/models/usermodel.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  late String from;
  late String to;
  late String  type ;
  late String date ;
  late int amount ;
  late String receiver_phone ;

  UserModel loggedInUser = UserModel();

  bool showAllTransactions = false;
  bool isLoading = true;
  //for sent
  late Map<String, dynamic> userMap = {};
  List collectionElements = [];

  //for received
  late Map<String, dynamic> userMapR = {};
  List collectionElementsR = [];


  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
      if (loggedInUser.phone != null) {
        setState(() {
          isLoading = false;
        });
      }
    });




    //get transactions for received
    // FirebaseFirestore.instance.collection("transfers").where("receiver_phone",
    //     isEqualTo: loggedInUser.phone ).orderBy("date",descending: true).get().then((value2) {
    //   for (int r = 0; r < value2.docs.length; r++) {
    //     userMapR = value2.docs[r].data();
    //     collectionElementsR.add(userMapR);
    //   }
    // });
  }








  @override
  Widget build(BuildContext context) {
    setState(() {
      FirebaseFirestore.instance.collection("transfers").where("sender_name",
          isEqualTo : loggedInUser.name ).get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          userMap = value.docs[i].data();
           collectionElements.add(userMap);
           print(collectionElements[i]);
        }

      });
    });


    // print(loggedInUser.phone);

    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
        child:  (isLoading)
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
            : SingleChildScrollView(
        child: Column(
        children: [
    RoundContainer(
    totalExpense: int.parse(loggedInUser.sent.toString()), totalIncome: int.parse(loggedInUser.received.toString())),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           showAllTransactions = false;
          //         });
          //       },
          //       child: Text(
          //         "SENT",
          //         style:showAllTransactions
          //             ? kInactiveTextStyle
          //             : kActiveTextStyle,
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           showAllTransactions = true;
          //         });
          //       },
          //       child: Text(
          //         "RECEIVED",
          //         style: showAllTransactions
          //             ? kActiveTextStyle
          //             : kInactiveTextStyle,
          //       ),
          //     ),
          //   ],
          // ),

            Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom + 100),
            height: deviceHeight * 0.55,
            child: ListView.builder(
              // shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, i) {
                return Card(
                  elevation: 1.0,
                  margin: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 5,
                    left: 20.0,
                    right: 20.0,
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                        Colors.green,
                        radius: 20.0,
                        child: Icon(
                           Icons.add_shopping_cart,
                            color: Colors.white),
                      ),
                      title: Text(
                        userMap['type'].toString() + " to " + userMap['receiver_name'].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        " Receiver's Number " + userMap['receiver_phone'].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "KES " + userMap["amount"].toString(),
                            style: TextStyle(
                              color:Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            userMap['date'].toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),


            Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewPadding.bottom + 100),
              height: deviceHeight * 0.55,
              child: ListView.builder(
                // shrinkWrap: true,
                itemCount: collectionElementsR.length,
                itemBuilder: (BuildContext context, r) {
                  return Card(
                    elevation: 1.0,
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 5,
                      left: 20.0,
                      right: 20.0,
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                          Colors.green,
                          radius: 20.0,
                          child: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white),
                        ),
                        title: Text(
                          "Received Money From " + collectionElementsR[r]["sender_name"],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          " Sender's Number " + collectionElements[r]["from"],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "KES " + collectionElements[r]["amount"].toString(),
                              style: TextStyle(
                                color:Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              collectionElements[r]["date"],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
  ]
    ),
    ),
    ),
    );
  }
}