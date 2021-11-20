import 'package:flutter/material.dart';
import 'package:flutterx_firebaselogin/constants/size_config.dart';
import 'package:flutterx_firebaselogin/pages/chat/chat_login.dart';
import 'package:flutterx_firebaselogin/pages/login_screen.dart';
import 'package:flutterx_firebaselogin/pages/admob_page.dart';
import 'package:flutterx_firebaselogin/services/auth.dart';
import 'package:flutterx_firebaselogin/pages/crud_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Center(
              child: new Image.asset('assets/images/bg.jpg',
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.fill,
                  color: Color.fromRGBO(50, 50, 50, 0.9),
                  colorBlendMode: BlendMode.modulate),
            ),
            SizedBox(
              height: 80.0,
            ),
            Container(
              width: size.width,
              height: size.height,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 50.0,
                ),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag:'intro',
                      child: Image(
                        image: AssetImage('assets/images/google_firebase.png'),
                        height: SizeConfig.blockSizeVertical * 20,
                      ),
                    ),
                    Text(
                      'Flutter Firebase All in One',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: <Widget>[
                        ReusableCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                        auth: new Auth(),
                                      )),
                            );
                          },
                          heroTag: 'login',
                          title: 'LOGIN',
                          icon: FontAwesomeIcons.user,
                        ),
                        ReusableCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FireStoreCrud()),
                            );
                          },
                          heroTag: 'crud',
                          title: 'CRUD',
                          icon: Icons.border_color,
                        ),
                        ReusableCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdmobPage()),
                            );
                          },
                          heroTag: 'admob',
                          title: 'ADMOB',
                          icon: FontAwesomeIcons.googleWallet,
                        ),
                        ReusableCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatLogin()),
                            );
                          },
                          heroTag: 'chat',
                          title: 'CHAT',
                          icon: FontAwesomeIcons.paperPlane,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  ReusableCard({this.title, this.icon, this.color, this.onTap, this.heroTag});

  final String title;
  final IconData icon;
  final MaterialColor color;
  final Function onTap;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.blueGrey,
        child: Center(
          child: Column(
            children: <Widget>[
              Hero(
                tag: heroTag,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(
                    icon,
                    size: SizeConfig.blockSizeVertical * 10,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
