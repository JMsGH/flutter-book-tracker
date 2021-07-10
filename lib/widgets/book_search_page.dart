import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/model/book.dart';
import 'package:flutter_book_tracker_app/widgets/searched_book_detail_dialog.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_book_tracker_app/widgets/input_decoration.dart';

import 'input_decoration.dart';

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController _searchTextController = TextEditingController();

  List<Book> listOfBooks = [];
  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('書籍の検索'),
        backgroundColor: Colors.redAccent,
      ),
      body: Material(
        elevation: 0,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: TextField(
                        onSubmitted: (value) {
                          _search();
                        },
                        controller: _searchTextController,
                        decoration: buildInputDecoration(
                            label: '検索', hintText: 'Flutter Development'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                if (listOfBooks.length != 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          width: 300,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: createBookCards(listOfBooks, context),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Text(''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _search() async {
    await fetchBooks(_searchTextController.text).then((value) {
      // for (var item in value) {
      //   print(item.title);
      setState(() {
        listOfBooks = value;
      });
      // 動画のとおりにここに return null; を入れておくとデバッグでE rror: Exception: NoSuchMethodError: '[]'が出る
      // return null;
    }, onError: (val) {
      throw Exception('ERROR!: ${val.toString()}');
    });
  }

  Future<List<Book>> fetchBooks(String query) async {
    List<Book> books = [];
    http.Response response = await http
        .get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body['items'];
      for (var item in list) {
        String title = item['volumeInfo']['title'] == null
            ? 'N/A'
            : item['volumeInfo']['title'];
        String author = item['volumeInfo']['authors'] == null
            ? "N/A"
            : item['volumeInfo']['authors'][0];
        String description = item['volumeInfo']['description'] == null
            ? "N/A"
            : item['volumeInfo']['description'];
        String categories = item['volumeInfo']['categories'] == null
            ? "N/A"
            : item['volumeInfo']['categories'][0];

        String thumbNail = item['volumeInfo']['imageLinks'] == null
            ? 'https://images.unsplash.com/photo-1553729784-e91953dec042?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1950&q=80'
            : item['volumeInfo']['imageLinks']['thumbnail'];
        int pageCount = item['volumeInfo']['pageCount'] == null
            ? 0
            : item['volumeInfo']['pageCount'];
        String publishedDate = item['volumeInfo']['publishedDate'] == null
            ? "N/A"
            : item['volumeInfo']['publishedDate'];

        Book searchedBook = new Book(
          title: title,
          author: author,
          description: description,
          categories: categories,
          photoUrl: thumbNail,
          pageCount: pageCount,
          publishedDate: publishedDate,
        );

        books.add(searchedBook);
        // print(searchedBook.photoUrl.toString());
        // print(books.length.toString());
      }
    } else {
      throw ('error ${response.reasonPhrase}');
    }

    if (books.length == 0) {
      print('書籍が見つかりませんでした');
    }

    return books;
  }

  List<Widget> createBookCards(List<Book> books, BuildContext context) {
    List<Widget> children = [];
    final _bookCollectionReference =
        FirebaseFirestore.instance.collection('books');
    for (var book in books) {
      children.add(Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return SearchedBookDetailDialog(
                    book: book,
                    bookCollectionReference: _bookCollectionReference);
              },
            );
          },
          child: Card(
            elevation: 5,
            color: HexColor('#f6f4ff'),
            child: Wrap(
              children: [
                Image.network(
                  (book.photoUrl == null || book.photoUrl == "")
                      ? 'https://images.unsplash.com/photo-1553729784-e91953dec042?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1950&q=80'
                      : '${book.photoUrl}',
                  width: 160,
                  height: 100,
                ),
                ListTile(
                  title: Text(
                    book.title,
                    style: TextStyle(color: HexColor('#5d48b6')),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    book.author!,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ));
    }
    return children;
  }
}
