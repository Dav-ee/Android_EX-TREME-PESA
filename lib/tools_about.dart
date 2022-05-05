import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/app_properties.dart';
class ToolAboutPage extends StatefulWidget {
  const ToolAboutPage({Key? key}) : super(key: key);

  @override
  State<ToolAboutPage> createState() => _ToolAboutPageState();
}

class _ToolAboutPageState extends State<ToolAboutPage> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      // body: _children[_currentIndex],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text('Tools & About',
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
      body: Center(
    child:  Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

      child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('Home'),
                leading: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                onTap: ()
                {
                },
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: const Text('LOAN CALCULATOR'),
                subtitle:  const Text('Estimate loan monthly payments'),
                leading: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                onTap: ()
                {

                },
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: const Text('Terms of service'),
                subtitle:  const Text('View our terms of service.'),
                leading: IconButton(
                  icon: Icon(Icons.download_sharp),
                  onPressed: () {
                  },
                ),
                onTap: ()
                {

                },
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: const Text('SPREAD THE CHEER'),
                subtitle:  const Text('Like the app experience? Please refer a friend.'),
                leading: IconButton(
                  icon: Icon(Icons.send_outlined),
                  onPressed: () {

                  },
                ),
                onTap: ()
                {

                },
              ),
              Divider(
                color: Colors.grey,
                height: 0,
              ),

              ListTile(
                title: const Text('RATE US'),
                subtitle:  const Text('Please take afew minutes to rate us'),
                leading: IconButton(
                  icon: Icon(Icons.settings_applications_outlined),
                  onPressed: () {
                  },
                ),
                onTap: ()
                {

                },
              ),
              Divider(
                color: Colors.grey,
                height: 50,
              ),

              Container(
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
                  child: Text("UPDATE APP",
                      style: const TextStyle(
                          color: const Color(0xfffefefe),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0)),
                ),
              ),
            ],
          ),
    ),
      ),
      backgroundColor: Colors.white,
    );
  }
}