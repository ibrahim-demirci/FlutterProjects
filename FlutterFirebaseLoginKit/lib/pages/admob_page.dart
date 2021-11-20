import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_firebaselogin/constants/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String testDevice = '33BE2250B43518CCDA7DE426D04EE231'; //your device id

class AdmobPage extends StatefulWidget {
  @override
  _AdmobPageState createState() => _AdmobPageState();
}

class _AdmobPageState extends State<AdmobPage> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      testDevices: testDevice != null ? <String>[testDevice] : null,
      nonPersonalizedAds: true,
      keywords: <String>['result', 'exam', 'scholarship', 'student visa']);
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-3940256099942544/6300978111', //your banner ad unit id
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print('BannerAd $event');
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712', //your interstial ad unit id
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print('InterstitialAd $event');
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-4846931245614453~7687050969'); //your app id
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    //_interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        dispose();
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              BackgroundWidget(size: size),
              Positioned(
                child: AppBar(
                  title: Text(" "),
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 150.0,
              ),
              Container(
                alignment: Alignment.center,
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'admob',
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Icon(
                            FontAwesomeIcons.googleWallet,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'ADMOB',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            _interstitialAd = createInterstitialAd()
                              ..load()
                              ..show();
                          },
                          child: Text(
                            'Interstial Ads - Click here',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Banner Ads will show automatically',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
