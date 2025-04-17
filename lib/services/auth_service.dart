import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      
      if (user == null) {
        throw Exception('Registration failed: User is null');
      }
      
      // Create a user model
      UserModel userModel = UserModel(
        uid: user.uid,
        username: username,
        email: email,
        photoUrl: null,
        bio: null,
        gameStats: {},
      );
      
      // Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      
      return userModel;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      
      if (user == null) {
        throw Exception('Login failed: User is null');
      }
      
      // Get user data from Firestore
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!doc.exists) {
        throw Exception('User data not found');
      }
      
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      
      if (!doc.exists) {
        return null;
      }
      
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? username,
    String? photoUrl,
    String? bio,
  }) async {
    try {
      Map<String, dynamic> data = {};
      
      if (username != null) data['username'] = username;
      if (photoUrl != null) data['photoUrl'] = photoUrl;
      if (bio != null) data['bio'] = bio;
      
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  // Update game stats
  Future<void> updateGameStats({
    required String uid,
    required String game,
    required Map<String, dynamic> stats,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'gameStats.$game': stats,
      });
    } catch (e) {
      throw Exception('Failed to update game stats: ${e.toString()}');
    }
  }
}