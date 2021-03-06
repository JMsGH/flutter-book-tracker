import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String id;
  final String uid;
  final String displayName;
  final String? quote;
  final String? profession;
  final String? avatarUrl;

  MUser({
    required this.id,
    required this.uid,
    required this.displayName,
    this.quote,
    this.profession,
    this.avatarUrl,
  });

  factory MUser.fromDocument(QueryDocumentSnapshot data) {
    return MUser(
      id: data.id,
      uid: data.get('uid'),
      displayName: data.get('display_name'),
      profession: data.get('profession'),
      quote: data.get('quote'),
      avatarUrl: data.get('avatar_url'),
    );
  }

  // ユーザ情報を更新する際にこのMapブロックが必要になる！
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'display_name': displayName,
      'quote': quote,
      'profession': profession,
      'avatar_url': avatarUrl,
    };
  }
}
