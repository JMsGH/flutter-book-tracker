import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/screens/main_screen_page.dart';

import 'input_decoration.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailTextControler,
    required TextEditingController passwordTextControler,
  })  : _formKey = formKey,
        _emailTextControler = emailTextControler,
        _passwordTextControler = passwordTextControler,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailTextControler;
  final TextEditingController _passwordTextControler;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) =>
                  value?.isEmpty ?? true ? 'メールアドレスを入力してください' : null,
              controller: _emailTextControler,
              decoration: buildInputDecoration(
                  label: 'メールアドレス', hintText: 'john@me.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) =>
                  value?.isEmpty ?? true ? 'パスワードを入力してください' : null,
              controller: _passwordTextControler,
              obscureText: true,
              decoration:
                  buildInputDecoration(label: 'パスワード', hintText: '6文字以上の英数記号'),
            ),
          ),
          SizedBox(height: 20),
          TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.lightGreen,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: _emailTextControler.text,
                    password: _passwordTextControler.text,
                  )
                      .then((value) {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreenPage(),
                      ),
                    );
                  }).catchError((onError) {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Oops!'),
                            content: Text('${onError.message}'),
                          );
                        });
                  });
                }
              },
              child: Text('ログイン')),
        ],
      ),
    );
  }
}
