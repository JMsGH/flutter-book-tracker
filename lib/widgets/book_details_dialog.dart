import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/constants/constants.dart';
import 'package:flutter_book_tracker_app/model/book.dart';
import 'package:flutter_book_tracker_app/screens/main_screen_page.dart';
import 'package:flutter_book_tracker_app/util/util.dart';
import 'package:flutter_book_tracker_app/widgets/two_sided_roundbutton.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'input_decoration.dart';

class BookDetailDialog extends StatefulWidget {
  const BookDetailDialog({
    required this.book,
  });

  final Book book;

  @override
  _BookDetailDialogState createState() => _BookDetailDialogState();
}

class _BookDetailDialogState extends State<BookDetailDialog> {
  bool isReadingClicked = false;
  bool isFinishedReadingClicked = false;
  TextEditingController? _notesTextController;

  final _bookCollectionReference =
      FirebaseFirestore.instance.collection('books');

  double _rating = -1;

  @override
  void initState() {
    _notesTextController = TextEditingController(text: widget.book.notes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController _notesTextController =
    //     TextEditingController(text: widget.book.notes);

    return AlertDialog(
        title: Column(
          children: [
            Row(
              children: [
                Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(widget.book.photoUrl!),
                  radius: 50,
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 100),
                  child: TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close),
                      label: Text('')),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.book.title,
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: kBlackColor, fontSize: 16),
                                  children: [
                                    TextSpan(
                                        text: '著者:  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    TextSpan(text: widget.book.author),
                                  ]),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: kBlackColor, fontSize: 16),
                                  children: [
                                    TextSpan(
                                        text: '表紙リンク:  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    TextSpan(text: widget.book.photoUrl!),
                                  ]),
                            )),
                      ],
                    )),
                TextButton.icon(
                  onPressed: widget.book.startedReading == null
                      ? () {
                          setState(() {
                            if (isReadingClicked == false) {
                              isReadingClicked = true;
                            } else {
                              isReadingClicked = false;
                            }
                          });
                        }
                      : null,
                  icon: Icon(
                    Icons.book_sharp,
                    color: Colors.blue.shade300,
                  ),
                  label: widget.book.startedReading == null
                      ? (!isReadingClicked)
                          ? Text('読み始める')
                          : Text('読書中',
                              style: TextStyle(color: Colors.blueGrey))
                      : Text(
                          '読書開始日: ${formatDate(widget.book.startedReading!)}',
                          style: TextStyle(color: Colors.blueGrey)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  onPressed: widget.book.finishedReading == null
                      ? () {
                          setState(() {
                            if (isFinishedReadingClicked == false) {
                              isFinishedReadingClicked = true;
                            } else {
                              isFinishedReadingClicked = false;
                            }
                          });
                        }
                      : null,
                  icon: Icon(
                    Icons.done,
                    color: Colors.greenAccent,
                  ),
                  label: widget.book.finishedReading == null
                      ? (!isFinishedReadingClicked)
                          ? Text('読了と登録！')
                          : Text('読了！',
                              style: TextStyle(color: Colors.blueGrey))
                      : Text(
                          '読了日: ${formatDate(widget.book.finishedReading!)}'),
                ),
                RatingBar.builder(
                    initialRating: widget.book.rating ?? 0,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.red,
                          );
                        case 1:
                          return Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.redAccent,
                          );
                        case 2:
                          return Icon(
                            Icons.sentiment_neutral,
                            color: Colors.amber,
                          );
                        case 3:
                          return Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.lightGreen,
                          );
                        case 4:
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );
                        default:
                          return Container();
                      }
                    },
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    }),
                TextFormField(
                  controller: _notesTextController,
                  decoration: buildInputDecoration(label: '感想', hintText: '感想'),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TwoSidedRoundedButton(
                      text: '　更新　',
                      radius: 12,
                      color: Colors.green.shade300,
                      press: () {
                        // データが追加されたり、修正されたりした場合のみ更新する
                        final userChangedNotes =
                            widget.book.notes != _notesTextController!.text;
                        final userChangedRating =
                            (_rating != -1) && (widget.book.rating != _rating);

                        final bookUpdate =
                            userChangedNotes || userChangedRating;

                        if (bookUpdate)
                          _bookCollectionReference
                              .doc(widget.book.id)
                              .update(Book(
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                title: widget.book.title,
                                photoUrl: widget.book.photoUrl,
                                author: widget.book.author,
                                startedReading: isReadingClicked
                                    ? Timestamp.now()
                                    : widget.book.startedReading,
                                finishedReading: isFinishedReadingClicked
                                    ? Timestamp.now()
                                    : widget.book.finishedReading,
                                rating: userChangedRating
                                    ? _rating
                                    : widget.book.rating,
                                notes: _notesTextController!.text,
                              ).toMap());
                        Navigator.of(context).pop();
                      },
                    ),
                    TwoSidedRoundedButton(
                        text: '　削除　',
                        radius: 12,
                        color: Colors.orange.shade200,
                        press: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('本当に削除しますか？'),
                                  content: Text('削除すると元に戻せません'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('キャンセル')),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          _bookCollectionReference
                                              .doc(widget.book.id)
                                              .delete();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MainScreenPage(),
                                              ));
                                        },
                                        child: Text('削除する')),
                                  ],
                                );
                              });
                        }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
