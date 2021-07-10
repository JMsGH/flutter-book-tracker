import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/model/book.dart';
import 'package:flutter_book_tracker_app/model/user.dart';
import 'package:flutter_book_tracker_app/util/util.dart';
import 'package:flutter_book_tracker_app/widgets/update_user_profile.dart';
import 'package:hexcolor/hexcolor.dart';

Widget createProfileDialog(
  BuildContext context,
  MUser curUser,
  List<Book> bookList,
) {
  final TextEditingController _displayNameTextController =
      TextEditingController(text: curUser.displayName);
  final TextEditingController _professionTextController =
      TextEditingController(text: curUser.profession);
  final TextEditingController _quoteTextController =
      TextEditingController(text: curUser.quote);
  final TextEditingController _avatarUrlTextController =
      TextEditingController(text: curUser.avatarUrl);

  return AlertDialog(
    content: Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    curUser.avatarUrl ?? 'https://picsum.photos/id/1022/300'),
                radius: 50,
              )
            ],
          ),
          Text(
            '読んだ書籍 (${bookList.length})',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.redAccent),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  curUser.displayName.toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return UpdateUserProfile(
                          user: curUser,
                          displayNameTextController: _displayNameTextController,
                          professionTextController: _professionTextController,
                          quoteTextController: _quoteTextController,
                          avatarUrlTextController: _avatarUrlTextController);
                    },
                  );
                },
                icon: Icon(
                  Icons.mode_edit,
                  color: Colors.black12,
                ),
                label: Text(''),
              )
            ],
          ),
          Text(
            curUser.profession ?? '未登録',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          SizedBox(
            width: 100,
            height: 2,
            child: Container(
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.blueGrey.shade100),
              color: HexColor('#faf3f6'),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '好きな言葉',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 2,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(curUser.quote ?? '未登録',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ListView.builder(
                itemCount: bookList.length,
                itemBuilder: (context, index) {
                  Book book = bookList[index];
                  return Card(
                    elevation: 2.0,
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(book.photoUrl!),
                          ),
                          title: Text(book.title),
                          subtitle: Text(book.author!),
                        ),
                        Text('読了日: ${formatDate(book.finishedReading!)}')
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    ),
  );
}
