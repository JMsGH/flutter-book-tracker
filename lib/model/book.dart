import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String? id;
  final String title;
  final String? author;
  final String? description;
  final String? categories;
  final String? notes;
  final String? photoUrl;
  final int? pageCount;
  final String? publishedDate;
  final double? rating;
  final Timestamp? startedReading;
  final Timestamp? finishedReading;
  final String? userId;

  Book({
    this.id,
    required this.title,
    this.author,
    this.description,
    this.categories,
    this.notes,
    this.photoUrl,
    this.pageCount,
    this.publishedDate,
    this.rating,
    this.startedReading,
    this.finishedReading,
    this.userId,
  });

  // factory Book.fromMap(Map<String, dynamic> data) {
  //   return Book(
  //     id: data['id'],
  //     title: data['title'],
  //     author: data['author'],
  //     description: data['description'],
  //     categories: data['categories'],
  //     notes: data['notes'],
  //   );
  // }

  /* Newer firestore sdk versions allow for
      using data.get('pass_field_name')
  */

  factory Book.fromDocument(QueryDocumentSnapshot data) {
    return Book(
      id: data.id,
      title: data.get('title'),
      author: data.get('author'),
      description: data.get('description'),
      categories: data.get('categories'),
      notes: data.get('notes'),
      photoUrl: data.get('photo_url'),
      pageCount: data.get('page_count'),
      publishedDate: data.get('published_date'),
      rating: data.get('rating'),
      startedReading: data.get('started_reading_at'),
      finishedReading: data.get('finished_reading_at'),
      userId: data.get('user_id'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'user_id': userId,
      'author': author,
      'notes': notes,
      'photo_url': photoUrl,
      'published_date': publishedDate,
      'rating': rating,
      'description': description,
      'page_count': pageCount,
      'started_reading_at': startedReading,
      'finished_reading_at': finishedReading,
      'categories': categories,
    };
  }
}
