import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/model/book.dart';
import 'package:flutter_book_tracker_app/widgets/two_sided_roundbutton.dart';

class SearchedBookDetailDialog extends StatelessWidget {
  const SearchedBookDetailDialog({
    Key? key,
    required this.book,
    required CollectionReference<Map<String, dynamic>> bookCollectionReference,
  })  : _bookCollectionReference = bookCollectionReference,
        super(key: key);

  final Book book;
  final CollectionReference<Map<String, dynamic>> _bookCollectionReference;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Container(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(book.photoUrl!),
              radius: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.title,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '分類: ${book.categories!}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ページ数: ' + book.pageCount.toString(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '著者: ${book.author!}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '出版日: ${book.publishedDate!}',
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.blueGrey.shade100,
                  width: 1,
                )),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      book.description!,
                      style: TextStyle(wordSpacing: 0.9, letterSpacing: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TwoSidedRoundedButton(
            radius: 40,
            text: '保存',
            color: Colors.lightGreen.shade500,
            press: () {
              _bookCollectionReference.add(Book(
                userId: FirebaseAuth.instance.currentUser!.uid,
                title: book.title,
                author: book.author,
                description: book.description,
                publishedDate: book.publishedDate,
                pageCount: book.pageCount,
                photoUrl: book.photoUrl,
                categories: book.categories,
              ).toMap());
              Navigator.of(context).pop();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TwoSidedRoundedButton(
            radius: 40,
            text: 'キャンセル',
            color: Colors.orange.shade300,
            press: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
