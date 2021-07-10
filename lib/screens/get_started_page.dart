import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'login_screen.dart';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: HexColor('#f5f6f8'),
        child: Column(
          children: [
            Spacer(),
            Text(
              'BookTracker',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 10,
            ),
            Text('読書して新しい自分に',
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: 29,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 50,
            ),
            TextButton.icon(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: HexColor('#69639f'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                  child: Icon(Icons.login_rounded),
                ),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ログインして始める'),
                )),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
