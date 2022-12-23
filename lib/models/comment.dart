class Comment {
  final String id;
  final String postId;
  final String text;
  final String username;
  final String userProfilePic;
  final DateTime createdAt;
  Comment({
    required this.id,
    required this.postId,
    required this.text,
    required this.username,
    required this.userProfilePic,
    required this.createdAt,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? text,
    String? username,
    String? userProfilePic,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      text: text ?? this.text,
      username: username ?? this.username,
      userProfilePic: userProfilePic ?? this.userProfilePic,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'text': text,
      'username': username,
      'userProfilePic': userProfilePic,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      postId: map['postId'] as String,
      text: map['text'] as String,
      username: map['username'] as String,
      userProfilePic: map['userProfilePic'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, text: $text, username: $username, userProfilePic: $userProfilePic, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.text == text &&
        other.username == username &&
        other.userProfilePic == userProfilePic &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        text.hashCode ^
        username.hashCode ^
        userProfilePic.hashCode ^
        createdAt.hashCode;
  }
}
