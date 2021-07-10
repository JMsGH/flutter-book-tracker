import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/widgets/create_account_form.dart';
import 'package:flutter_book_tracker_app/widgets/login_form.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isCreateAccountClicked = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextControler = TextEditingController();
  final TextEditingController _passwordTextControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: HexColor('#b9c2d1'),
              ),
            ),
            Text(
              isCreateAccountClicked ? 'アカウントを作成' : 'ログイン',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(
                    children: [
                      !isCreateAccountClicked
                          ? LoginForm(
                              formKey: _formKey,
                              emailTextControler: _emailTextControler,
                              passwordTextControler: _passwordTextControler,
                            )
                          : CreateAccountForm(
                              formKey: _formKey,
                              emailTextControler: _emailTextControler,
                              passwordTextControler: _passwordTextControler,
                            ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isCreateAccountClicked = !isCreateAccountClicked;
                    });
                  },
                  icon: Icon(Icons.portrait_rounded),
                  style: TextButton.styleFrom(
                    primary: HexColor('#fd5b28'),
                    textStyle:
                        TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  label: Text(
                      isCreateAccountClicked ? 'アカウントをお持ちですか？' : 'アカウントを作成'),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: HexColor('#b9c2d1'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
