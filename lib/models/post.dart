import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String type;
  final String communityName;
  final String communityProfilePic;
  final String uid;
  final String username;
  final DateTime createdAt;
  final int commentCount;
  final List<String> upvotes;
  final List<String> downvotes;
  final List<String> awards;
  Post({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.type,
    required this.communityName,
    required this.communityProfilePic,
    required this.uid,
    required this.username,
    required this.createdAt,
    required this.commentCount,
    required this.upvotes,
    required this.downvotes,
    required this.awards,
  });

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? type,
    String? communityName,
    String? communityProfilePic,
    String? uid,
    String? username,
    DateTime? createdAt,
    int? commentCount,
    List<String>? upvotes,
    List<String>? downvotes,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      type: type ?? this.type,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      commentCount: commentCount ?? this.commentCount,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'type': type,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'uid': uid,
      'username': username,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'commentCount': commentCount,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      link: map['link'] != null ? map['link'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      type: map['type'] as String,
      communityName: map['communityName'] as String,
      communityProfilePic: map['communityProfilePic'] as String,
      uid: map['uid'] as String,
      username: map['username'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      commentCount: map['commentCount'] as int,
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
      awards: List<String>.from(map['awards']),
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, description: $description, type: $type, communityName: $communityName, communityProfilePic: $communityProfilePic, uid: $uid, username: $username, createdAt: $createdAt, commentCount: $commentCount, upvotes: $upvotes, downvotes: $downvotes, awards: $awards)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.link == link &&
        other.description == description &&
        other.type == type &&
        other.communityName == communityName &&
        other.communityProfilePic == communityProfilePic &&
        other.uid == uid &&
        other.username == username &&
        other.createdAt == createdAt &&
        other.commentCount == commentCount &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes) &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        link.hashCode ^
        description.hashCode ^
        type.hashCode ^
        communityName.hashCode ^
        communityProfilePic.hashCode ^
        uid.hashCode ^
        username.hashCode ^
        createdAt.hashCode ^
        commentCount.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        awards.hashCode;
  }
}
