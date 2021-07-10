import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/constants/constants.dart';

class BookRating extends StatelessWidget {
  final double? score;

  const BookRating({Key? key, this.score = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(3, 7),
                blurRadius: 20,
                color: Color(0xfd3d3d3).withOpacity(0.5)),
          ]),
      child: Column(
        children: [
          Icon(
            score != 0 ? Icons.star : Icons.star_border_outlined,
            color: kIconColor,
            size: 15,
          ),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
