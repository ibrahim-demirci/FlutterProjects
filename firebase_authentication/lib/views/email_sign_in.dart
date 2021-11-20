import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

enum FormStatus {
  signIn,
  register,
  reset,
}

class EmailSignInPage extends StatefulWidget {
  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  // bir değişken değerine göre iki formdan birisi yüklenecek.
  // enum kullanabiliriz
  // bir değişken farklı değerler alabiliyorsa ve buna göre kontrol yapılıyorsa enum kullanılır
  FormStatus _formStatus = FormStatus.signIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _formStatus == FormStatus.signIn
            ? buildSignInForm()
            : _formStatus == FormStatus.reset
                ? buildResetForm()
                : buildRegisterForm(),
      ),
    );
  }

  // State içinde kaldı çünkü extract metot dedik
  // Extract widget deseydik setstate elemanına erişemezdik
  Widget buildSignInForm() {
    final _signInFromKey = GlobalKey<FormState>();

    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),

      // Form içine alma sebebi form elemanlarının durumlaını kontrol edebiliriz.
      // Her form için formkey oluşturulur

      child: Form(
        key: _signInFromKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lütfen Giriş Yapınız',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                // email kontrolü için
                if (!EmailValidator.validate(value)) {
                  return 'Geçerli bir adres giriniz.';
                } else
                  return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value.length < 6) {
                  return 'En az 6 karakterden oluşan bir şifre giriniz';
                } else
                  return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Şifre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                // validate() true ise her şey yolunda demektir.
                if (_signInFromKey.currentState.validate()) {
                  final user = await Provider.of<Auth>(context, listen: false)
                      .signInWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                  if (!user.emailVerified) {
                    // email gönderdiğinde aslında kullanıcı giriş yapmış durumundadır.
                    // biz bunu engellemek istiyoruz.

                    await _showMyDialog();
                    await Provider.of<Auth>(context, listen: false).singOut();
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Giriş'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.register;
                });
              },
              child: Text('Zaten Üye Misiniz'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.reset;
                });
              },
              child: Text('Şifremi Unuttum'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResetForm() {
    final _resetFromKey = GlobalKey<FormState>();

    TextEditingController _emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),

      // Form içine alma sebebi form elemanlarının durumlaını kontrol edebiliriz.
      // Her form için formkey oluşturulur

      child: Form(
        key: _resetFromKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Şifre Yenileme',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                // email kontrolü için
                if (!EmailValidator.validate(value)) {
                  return 'Geçerli bir adres giriniz.';
                } else
                  return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                // validate() true ise her şey yolunda demektir.
                if (_resetFromKey.currentState.validate()) {
                  // Provider ile çağırıyoruz.
                  await Provider.of<Auth>(context, listen: false)
                      .sendPassworkResetEmail(_emailController.text);
                  await _showResetPasswordDialog();
                  Navigator.pop(context);
                }
              },
              child: Text('E-mail Gönder'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.signIn;
                });
              },
              child: Text('Vazgeç ve Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRegisterForm() {
    // Form durumunu kontrol için kullanılır.
    final _registerFormKey = GlobalKey<FormState>();

    // Text form alanları için kontrol
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kayıt Formu',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (!EmailValidator.validate(value)) {
                  return 'Geçerli bir adres giriniz';
                } else
                  return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value.length < 6) {
                  return 'En az 6 karakterden oluşan bir şifre giriniz';
                } else
                  return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Şifre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Şifreler uyuşmuyor';
                } else {
                  return null;
                }
              },
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Şifreyi onaylayın',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_registerFormKey.currentState.validate()) {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .createUserWithEmailAndPassword(
                            _emailController.text, _passwordController.text);
                    if (!user.emailVerified) {
                      await user.sendEmailVerification();
                    }

                    // Asenkron olmasının sebebi Future olmalıdır.
                    // Kapanırken bir kendisinin kapatıldığını bildirir.
                    await _showMyDialog();

                    // sign out ediyoruz çünkü tekrar giriş yapmasını istiyoruz.
                    await Provider.of<Auth>(context, listen: false).singOut();

                    setState(() {
                      _formStatus = FormStatus.signIn;
                    });
                  }
                } on FirebaseAuthException catch (e) {
                  print('Kayıt Formu İçerisinde Hata Yakalandı ${e.message}');
                }
              },
              child: Text('Kayıt'),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _formStatus = FormStatus.signIn;
                  });
                },
                child: Text('Zaten Üye Misiniz'))
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('E-posta Onayı'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Lütfen e-mail adresinize gelen mailden'),
                Text('onaylama işlemini gerçekleştiriniz.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Şifre Sıfırlama'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Lütfen e-mail adresinize gelen mailden'),
                Text('şifre sıfırlama işlemini gerçekleştiriniz.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
