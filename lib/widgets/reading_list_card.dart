import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/constants/constants.dart';
import 'package:flutter_book_tracker_app/model/book.dart';
import 'package:flutter_book_tracker_app/widgets/two_sided_roundbutton.dart';

import 'book_rating.dart';

class ReadingListCard extends StatelessWidget {
  final String image;
  final String title;
  final String author;
  final double? rating;
  final String? buttonText;
  final Book? book;
  final bool? isBookRead;
  final Function? pressDetails;
  final VoidCallback? pressRead;

  const ReadingListCard({
    Key? key,
    required this.image,
    required this.title,
    required this.author,
    this.rating,
    this.buttonText = 'ボタンテキスト',
    this.book,
    this.isBookRead,
    this.pressDetails,
    this.pressRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 202,
      margin: EdgeInsets.only(left: 24, bottom: 0),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              height: 244,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 33,
                      color: kShadowColor,
                    )
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              image,
              width: 100,
            ),
          ),
          Positioned(
            top: 34,
            right: 10,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite_border),
                ),
                BookRating(score: (rating)),
              ],
            ),
          ),
          Positioned(
            top: 160,
            child: Container(
                height: 85,
                width: 202,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                            style: TextStyle(color: kBlackColor),
                            children: [
                              TextSpan(
                                  text: '$title\n',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: author,
                                  style: TextStyle(color: kLightBlackColor)),
                            ]),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: Text('詳細'),
                        ),
                        Expanded(
                            child: TwoSidedRoundedButton(
                                text: buttonText!,
                                press: pressRead,
                                color: kLightPurple)),
                      ],
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
