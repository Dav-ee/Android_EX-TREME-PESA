import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'profile.dart';
import 'settings.dart';
import 'transactions.dart';
import 'e-wallet.dart';
import 'withdrawals.dart';
import 'transfer.dart';
import 'login.dart';
import 'tools_about.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/models/usermodel.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
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



  int _currentIndex = 0;
  final List<Widget> _children = [
    Dashboard(),
    //interchanged my codes such that walletpage is transaction page
    //real messed up
    TransactionsPage(),
    WalletPage(),
    ProfilePage(),
    SettingsPage(),
  ];
  int _selectedIndex = 0;
  static  List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    TransactionsPage(),
    WalletPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  int _selectedPage = 0;
  static  List<String> _widgetOptions2 = <String>[
    'EX-TREME PESA',
    'DEPOSIT',
    'TRANSACTIONS',
    'PROFILE',
    'SETTINGS',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedPage = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: _children[_currentIndex],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(_widgetOptions2.elementAt(_selectedPage),
            style: TextStyle(fontSize: 19),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffbf360c),
          elevation: 10,
          shadowColor: Color(0xff3f51b5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: Icon(Icons.account_circle, color: Colors.white,size: 40,),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 6,
                    child:  (isLoading)
                        ? Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                        :Text(
                      '${loggedInUser.name} \n\n${loggedInUser.phone}\n\n${loggedInUser.email} ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),

                  ),
                ],
              ),
            ),
            ),
            ListTile(
              title: const Text('Home'),
              leading: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => StartPage()));
                },
              ),
              onTap: ()
              {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => StartPage()));
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: const Text('Deposit'),
              leading: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => TransactionsPage()));
                },
              ),
              onTap: ()
              {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TransactionsPage()));
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: const Text('Withdraw'),
              leading: IconButton(
                icon: Icon(Icons.download_sharp),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => WithdrawalsPage()));
                },
              ),
              onTap: ()
              {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => WithdrawalsPage()));
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: const Text('Transfer Funds'),
              leading: IconButton(
                icon: Icon(Icons.send_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => TransferPage()));
                },
              ),
              onTap: ()
              {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TransferPage()));
              },
            ),
            Divider(
              color: Colors.grey,
            ),

            ListTile(
              title: const Text('Tools & About'),
              leading: IconButton(
                icon: Icon(Icons.settings_applications_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ToolAboutPage()));
                },
              ),
              onTap: ()
              {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ToolAboutPage()));
              },
            ),
            Divider(
              color: Colors.grey,
            ),

            ListTile(
              title: const Text('Logout'),
              leading: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              onTap: ()
              {
           _signOut();
           Navigator.pop(context);
           Navigator.pop(context);
           Navigator.of(context).push(
               MaterialPageRoute(builder: (_) => LoginPage()));

              },
            ),

          ],
        ),

      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.orangeAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'E-Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}