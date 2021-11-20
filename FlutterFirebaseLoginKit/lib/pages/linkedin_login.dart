import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';

// @TODO IMPORTANT - you need to change variable values below
// You need to add your own data from LinkedIn application
// From: https://www.linkedin.com/developers/
// Please read step 1 from this link https://developer.linkedin.com/docs/oauth2
final String redirectUrl = 'http://codesolutions101.com/';
final String clientId = '81mlizvcfawe7u';
final String clientSecret = 'SiUkzZnz1GwN6S4L';

class LinkedInLogin extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Profile',
                ),
                Tab(icon: Icon(Icons.text_fields), text: 'Auth code')
              ],
            ),
            title: Text('Linkedin Login'),
          ),
          body: TabBarView(
            children: [
              LinkedInProfilePage(),
              LinkedInAuthCodePage(),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkedInProfilePage extends StatefulWidget {
  @override
  State createState() => _LinkedInProfilePageState();
}

class _LinkedInProfilePageState extends State<LinkedInProfilePage> {
  UserObject user;
  bool logoutUser = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          LinkedInButtonStandardWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LinkedInUserWidget(
                    appBar: AppBar(
                      title: Text('OAuth User'),
                    ),
                    destroySession: logoutUser,
                    redirectUrl: redirectUrl,
                    clientId: clientId,
                    clientSecret: clientSecret,
                    onGetUserProfile: (LinkedInUserModel linkedInUser) {
                      print('Access token ${linkedInUser.token.accessToken}');

                      print('User id: ${linkedInUser.userId}');

                      user = UserObject(
                        firstName: linkedInUser.firstName.localized.label,
                        lastName: linkedInUser.lastName.localized.label,
                        email: linkedInUser
                            .email.elements[0].handleDeep.emailAddress,
                      );
                      setState(() {
                        logoutUser = false;
                      });

                      Navigator.pop(context);
                    },
                    catchError: (LinkedInErrorObject error) {
                      print('Error description: ${error.description},'
                          ' Error code: ${error.statusCode.toString()}');
                      Navigator.pop(context);
                    },
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          LinkedInButtonStandardWidget(
            onTap: () {
              setState(() {
                user = null;
                logoutUser = true;
              });
            },
            buttonText: 'Logout',
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('First: ${user?.firstName} '),
                Text('Last: ${user?.lastName} '),
                Text('Email: ${user?.email}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LinkedInAuthCodePage extends StatefulWidget {
  @override
  State createState() => _LinkedInAuthCodePageState();
}

class _LinkedInAuthCodePageState extends State<LinkedInAuthCodePage> {
  AuthCodeObject authorizationCode;
  bool logoutUser = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        LinkedInButtonStandardWidget(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LinkedInAuthCodeWidget(
                  destroySession: logoutUser,
                  redirectUrl: redirectUrl,
                  clientId: clientId,
                  onGetAuthCode: (AuthorizationCodeResponse response) {
                    print('Auth code ${response.code}');

                    print('State: ${response.state}');

                    authorizationCode = AuthCodeObject(
                      code: response.code,
                      state: response.state,
                    );
                    setState(() {});

                    Navigator.pop(context);
                  },
                  catchError: (LinkedInErrorObject error) {
                    print('Error description: ${error.description},'
                        ' Error code: ${error.statusCode.toString()}');
                    Navigator.pop(context);
                  },
                ),
                fullscreenDialog: true,
              ),
            );
          },
        ),
        LinkedInButtonStandardWidget(
          onTap: () {
            setState(() {
              authorizationCode = null;
              logoutUser = true;
            });
          },
          buttonText: 'Logout user',
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Auth code: ${authorizationCode?.code} '),
              Text('State: ${authorizationCode?.state} '),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthCodeObject {
  String code, state;

  AuthCodeObject({this.code, this.state});
}

class UserObject {
  String firstName, lastName, email;

  UserObject({this.firstName, this.lastName, this.email});
}
