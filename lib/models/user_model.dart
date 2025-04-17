class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? photoUrl;
  final String? bio;
  final Map<String, dynamic>? gameStats;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.photoUrl,
    this.bio,
    this.gameStats,
  });

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'gameStats': gameStats,
    };
  }

  // Create UserModel from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      gameStats: map['gameStats'],
    );
  }

  // Create a copy of UserModel with some fields updated
  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? photoUrl,
    String? bio,
    Map<String, dynamic>? gameStats,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      gameStats: gameStats ?? this.gameStats,
    );
  }
}