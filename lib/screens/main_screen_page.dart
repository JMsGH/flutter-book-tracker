import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_book_tracker_app/constants/constants.dart';
import 'package:flutter_book_tracker_app/model/book.dart';
import 'package:flutter_book_tracker_app/model/user.dart';
import 'package:flutter_book_tracker_app/screens/login_screen.dart';
import 'package:flutter_book_tracker_app/widgets/book_details_dialog.dart';
import 'package:flutter_book_tracker_app/widgets/book_search_page.dart';
import 'package:flutter_book_tracker_app/widgets/create_profile.dart';
import 'package:flutter_book_tracker_app/widgets/reading_list_card.dart';

class MainScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('books');
    List<Book> userBooksReadList = [];
    // int booksRead = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
        toolbarHeight: 77,
        centerTitle: false,
        title: Row(
          children: [
            Text(
              'A.Reader',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: usersCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final userListStream = snapshot.data!.docs.map((user) {
                return MUser.fromDocument(user);
              }).where((user) {
                return (user.uid == FirebaseAuth.instance.currentUser!.uid);
              }).toList();
              MUser curUser = userListStream[0];

              return Column(
                children: [
                  InkWell(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(curUser.avatarUrl ??
                            'https://picsum.photos/id/1022/300'),
                        backgroundColor: Colors.white,
                        child: Text(''),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return createProfileDialog(
                              context, curUser, userBooksReadList);
                        },
                      );
                    },
                  ),
                  Text(
                    curUser.displayName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black),
                  )
                ],
              );
            },
          ),
          TextButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              });
            },
            icon: Icon(Icons.logout),
            label: Text(''),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookSearchPage(),
              ));
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12, left: 12, bottom: 10),
            child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.headline6,
                  children: [
                    TextSpan(text: '今、'),
                    TextSpan(
                        text: '読んでいるのは',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: '…'),
                  ]),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: bookCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('問題が発生しました (T.T)');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                    flex: 1,
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.lime.shade300,
                    )));
              }

              if (snapshot.data!.docs.isEmpty) {
                return Text('表示する書籍データがありません',
                    style: Theme.of(context).textTheme.headline4);
              }

              final userBookFilteredReadListStream =
                  snapshot.data!.docs.map((book) {
                return Book.fromDocument(book);
              }).where((book) {
                return ((book.userId ==
                        FirebaseAuth.instance.currentUser!.uid)) &&
                    (book.finishedReading == null) &&
                    (book.startedReading != null);
              }).toList();

              userBooksReadList = snapshot.data!.docs.map((book) {
                return Book.fromDocument(book);
              }).where((book) {
                return ((book.userId ==
                        FirebaseAuth.instance.currentUser!.uid)) &&
                    (book.finishedReading != null) &&
                    (book.startedReading != null);
              }).toList();

              return Expanded(
                  flex: 1,
                  child: (userBookFilteredReadListStream.length > 0)
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: userBookFilteredReadListStream.length,
                          itemBuilder: (context, index) {
                            Book book = userBookFilteredReadListStream[index];

                            return InkWell(
                              child: ReadingListCard(
                                buttonText: '読書中',
                                image: book.photoUrl!,
                                title: book.title,
                                author: book.author!,
                                rating: (book.rating) != null ? book.rating : 0,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BookDetailDialog(
                                      book: book,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        )
                      : Text('読書中の本はありません (・o・)',
                          style: Theme.of(context).textTheme.headline6));
            },
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '読みたい本リスト',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: kBlackColor),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: bookCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('問題が発生しました (T.T)');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                    flex: 1,
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.lime.shade300,
                    )));
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('表示する書籍データがありません',
                      style: Theme.of(context).textTheme.headline4),
                );
              }

              final readingListListBook = snapshot.data!.docs.map((book) {
                return Book.fromDocument(book);
                // ログイン中ユーザのuidでbookをフィルタリングする
              }).where((book) {
                return ((book.userId ==
                        FirebaseAuth.instance.currentUser!.uid)) &&
                    (book.startedReading == null) &&
                    (book.finishedReading == null);
              }).toList();
              return Expanded(
                  flex: 1,
                  child: (readingListListBook.length > 0)
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: readingListListBook.length,
                          itemBuilder: (context, index) {
                            Book book = readingListListBook[index];
                            return InkWell(
                              child: ReadingListCard(
                                buttonText: '未読',
                                rating: (book.rating) != null ? book.rating : 0,
                                image: book.photoUrl!,
                                title: book.title,
                                author: book.author!,
                                isBookRead: false,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BookDetailDialog(
                                      book: book,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        )
                      : Text('表示する書籍データがありません ^_^;',
                          style: Theme.of(context).textTheme.headline6));
            },
          ),
        ],
      ),
    );
  }
}
