import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_auth/profile.dart';
class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {

  List<Panel> panels = [
    Panel(
        'Personal Data',
        'While using Our Service, We may ask You to provide Us with '
            'certain personally identifiable information that can be used to contact or '
            'identify You. Personally identifiable information may include, '
            'but is not limited to:'
            'Email address'
            'First name and last name Phone number'
            'Usage Data',
        false),
    Panel(
        'Usage Data',
        'Usage Data is collected automatically when using the '
            'Service.'

            'Usage Data may include information such as Your Device '
            'Internet Protocol address (e.g. IP address), browser type, browser version,'
            ' the pages of our Service that You visit, the time and date of Your visit,'
            ' the time spent on those pages, unique device identifiers and other diagnostic data.'

            'When You access the Service by or through a mobile device, We may collect certain'
            ' information automatically, including, but not limited to, the type of mobile device '
            'You use, Your mobile device unique ID, the IP address of Your mobile device, '
            'Your mobile operating system, the type of mobile Internet browser You use, unique '
            'device identifiers and other diagnostic data.'

            'We may also collect information that Your browser sends whenever You visit our Service '
            'or when You access the Service by or through a mobile device.',
        false),
    Panel(
        'Use of Your Personal Data',
        'The Company may use Personal Data for the following purposes:'
            'To provide and maintain our Service, including to monitor the usage of our Service.'
            'To manage Your Account: to manage Your registration as a user of the Service. '
            'The Personal Data You provide can give You access to different functionalities of the Service'
            ' that are available to You as a registered user.'
            'For the performance of a contract: the development, compliance and undertaking of the purchase '
            'contract for the products, items or services You have purchased or of any other contract with'
            'Us through the Service.'
            ' To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic'
            ' communication, such as a mobile applications push notifications regarding updates '
            'or informative communications related to the functionalities, products or contracted services, '
            'including the security updates, when necessary or reasonable for their implementation.'
            'To provide You with news, special offers and general information about other goods, '
            'services and events which we offer that are similar to those that you have already'
            ' purchased or enquired about unless You have opted not to receive such information.'
            'To manage Your requests: To attend and manage Your requests to Us.',
        false),
    Panel(
        'Retention of Your Personal Data',
        'The Company will retain Your Personal Data only for as long as is necessary for the purposes'
            'set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to '
            'comply with our legal obligations (for example, if we are required to retain your data to comply '
            'with applicable laws), resolve disputes, and enforce our legal agreements and policies.'
            'The Company will also retain Usage Data for internal analysis purposes. '
            'Usage Data is generally retained for a shorter period of time, except when this data is used'
            ' to strengthen the security or to improve the functionality of Our Service,'
            'or We are legally obligated to retain this data for longer time periods.',
        false),
    Panel(
        'Transfer of Your Personal Data',
        'Your information, including Personal Data, is processed at the Companys operating offices and in any'
            ' other places where the parties involved in the processing are located. '
            'It means that this information may be transferred to — and maintained on'
            '— computers located outside of Your state, province, country or other governmental jurisdiction'
            ' where the data protection laws may differ than those from Your jurisdiction.'
            'Your consent to this Privacy Policy followed by Your submission of such information represents '
            'Your agreement to that transfer.'
            'The Company will take all steps reasonably necessary to ensure that'
            ' Your data is treated securely and in accordance with this Privacy Policy and no transfer of '
            'Your Personal Data will take place to an organization or a country unless there are adequate '
            'controls in place including the security of Your data and other personal information.',
        false),
    Panel(
        'Contact Developer',
        'email: info@davee.co.ke \n'
            'Call: 0745682815',
        true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'SUPPORT AND FAQ',
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
    body: SafeArea(
    bottom: true,
    child: Padding(
    padding: const EdgeInsets.only(top: 24.0),
    child: ListView(
    children: <Widget>[
    Padding(
    padding: const EdgeInsets.only(left:24.0,right:24.0,bottom: 16.0),
    child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'FAQ',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          IconButton(
            iconSize: 40,
            color: Colors.red, icon: Icon(Icons.close), onPressed: () {

            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));

          },
          ),
        ],
      ),

    ),... panels.map((panel)=>ExpansionTile(
    title: Text(
    panel.title,
    style: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.grey[600]),
    ),

    children: [Container(
    padding: EdgeInsets.all(16.0),
    color: Color(0xffFAF1E2),
    child: Text(
    panel.content,
    style:
    TextStyle(color: Colors.grey, fontSize: 13)))])).toList(),

    ],
    ),
    ),
    ),
    );
  }
}

class Panel {
  String title;
  String content;
  bool expanded;

  Panel(this.title, this.content, this.expanded);
}
