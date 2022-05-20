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
  }

  @override
  Widget build(BuildContext context) {


    // FirebaseFirestore.instance.collection('transfers').doc(
    //     loggedInUser.uid).collection('sent').where(
    //     "initiator", isEqualTo: loggedInUser.phone).get().then((value) {
    //   for (int r = 0; r < value.docs.length; r++) {
    //     userMap = value.docs[r].data();
    //     print(userMap.length);
    //     collectionElements.add(userMap);
    //
    //
    //   }
    // });

//saved
    // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
    //   builder: (_, snapshot) {
    //     if (snapshot.hasError) return Text('Error = ${snapshot.error}');
    //
    //     if (snapshot.hasData) {
    //       final docs = snapshot.data!.docs;
    //       return ListView.builder(
    //         itemCount: docs.length,
    //         itemBuilder: (_, i) {
    //           final data = docs[i].data();
    //           return ListTile(
    //             title: Text(data['name']),
    //             subtitle: Text(data['phone']),
    //           );
    //         },
    //       );
    //     }
    //
    //     return Center(child: CircularProgressIndicator());
    //   },
    // ),

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

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAllTransactions = false;
                  });
                },
                child: Text(
                  "SENT",
                  style: showAllTransactions
                      ? kInactiveTextStyle
                      : kActiveTextStyle,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAllTransactions = true;
                  });
                },
                child: Text(
                  "RECEIVED",
                  style: showAllTransactions
                      ? kActiveTextStyle
                      : kInactiveTextStyle,
                ),
              ),
            ],
          ),

          // Categories transactions
          if (!showAllTransactions)
          // ignore: sized_box_for_whitespace
                Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom + 100),
                  height: deviceHeight * 0.55,
                  child:  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection('transfers').doc(
                         loggedInUser.uid).collection('sent').where(
                        "sender_phone", isEqualTo: loggedInUser.phone).snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasError) return Text('Error = ${snapshot.error}');

                      if (snapshot.hasData) {
                        final docs = snapshot.data!.docs;
                        return  docs.length == 0
                            ? Text("No Records Found",   style: TextStyle(
                          color:Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,

                        ),)
                            : ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (_, i) {
                            final data = docs[i].data();
                            return  Card(
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
                                        Icons.send,
                                        color: Colors.white),
                                  ),
                                  title: Text(
                                    "TRANSFERED FUNDS TO " + data['receiver_name'].toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  subtitle: Text(
                                    " Receiver's Number " +  data['receiver_phone'].toString() ,
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
                                        "KES " +  data['amount'].toString(),
                                        style: TextStyle(
                                          color:Colors.green,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        data['date'].toString(),
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
                        );
                      }
else
                      return Center(child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                        strokeWidth: 2,
                      ));
                    },
                  ),
                ),

          // all the transactions
          if (showAllTransactions)
            Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewPadding.bottom + 100),
              height: deviceHeight * 0.55,
              child:   StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: FirebaseFirestore.instance.collection('transfers').doc(
    loggedInUser.uid).collection('received').where(
    "receiver_phone", isEqualTo: loggedInUser.phone).snapshots(),
    builder: (_, snapshot_r) {
    if (snapshot_r.hasError) return Text('Error = ${snapshot_r.error}');
    if (snapshot_r.hasData) {
    final docs = snapshot_r.data!.docs;
    return docs.length == 0
        ? Text("No Records Found",   style: TextStyle(
      color:Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 16.0,

    ),)
        :   ListView.builder(
    itemCount: docs.length,
    itemBuilder: (_, i) {
    final data_received = docs[i].data();
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
                              Icons.verified_outlined,
                              color: Colors.white),
                        ),
                        title: Text(
                          "RECEIVED FUNDS FROM "+ data_received['sender_name'].toString() ,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          " Sender's Number " + data_received['sender_phone'].toString(),
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
                              "KES " + data_received['amount'].toString() ,
                              style: TextStyle(
                                color:Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              data_received['date'].toString(),
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
    );
    }
else
    return Center(child: CircularProgressIndicator(
      color: Colors.blueAccent,
      strokeWidth: 2,
    ));
    },
              ),
            ),



],
    ),
    ),
    ),
    );


  }
}