import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/model/user.dart';

import 'input_decoration.dart';

class UpdateUserProfile extends StatelessWidget {
  const UpdateUserProfile({
    Key? key,
    required this.user,
    required TextEditingController displayNameTextController,
    required TextEditingController professionTextController,
    required TextEditingController quoteTextController,
    required TextEditingController avatarUrlTextController,
  })  : _displayNameTextController = displayNameTextController,
        _professionTextController = professionTextController,
        _quoteTextController = quoteTextController,
        _avatarUrlTextController = avatarUrlTextController,
        super(key: key);

  final MUser user;
  final TextEditingController _displayNameTextController;
  final TextEditingController _professionTextController;
  final TextEditingController _quoteTextController;
  final TextEditingController _avatarUrlTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('${user.displayName} を編集'),
      ),
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                      user.avatarUrl ?? 'https://picsum.photos/id/1022/300'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _displayNameTextController,
                  decoration: buildInputDecoration(
                    label: '表示名',
                    hintText: user.displayName,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _professionTextController,
                  decoration: buildInputDecoration(
                    label: '職業',
                    hintText: user.profession,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _quoteTextController,
                  decoration: buildInputDecoration(
                    label: '好きな言葉',
                    hintText: user.quote,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _avatarUrlTextController,
                  decoration: buildInputDecoration(
                    label: '画像URL',
                    hintText: user.avatarUrl,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              final userChangedName =
                  user.displayName != _displayNameTextController.text;
              final userChangedAvatar =
                  user.avatarUrl != _avatarUrlTextController.text;
              final userChangedProfession =
                  user.profession != _professionTextController.text;
              final userChangedQuote = user.quote != _quoteTextController.text;

              final userNeedUpdate = userChangedName ||
                  userChangedAvatar ||
                  userChangedProfession ||
                  userChangedQuote;

              if (userNeedUpdate) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.id)
                    .update(MUser(
                            id: user.id,
                            uid: user.uid,
                            displayName: _displayNameTextController.text,
                            avatarUrl: _avatarUrlTextController.text,
                            profession: _professionTextController.text,
                            quote: _quoteTextController.text)
                        .toMap());
              }

              Navigator.of(context).pop();
            },
            child: Text('更新'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('キャンセル')),
        ),
      ],
    );
  }
}
