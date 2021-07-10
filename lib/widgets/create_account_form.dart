import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/screens/main_screen_page.dart';
import 'package:flutter_book_tracker_app/services/create_user.dart';

import 'input_decoration.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
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
          Text(
            '有効なメールアドレスと\n6文字以上のパスワードを入力してください',
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(
            height: 10,
          ),
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
                  String email = _emailTextControler.text;
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: _passwordTextControler.text,
                  )
                      .then((value) {
                    if (value.user != null) {
                      String displayName = email.toString().split('@')[0];
                      createUser(displayName, context).then((value) {
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
                        });
                      });
                    }
                  });
                }
              },
              child: Text('アカウントを作成')),
        ],
      ),
    );
  }
}
