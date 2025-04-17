import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart'; // Add this import
import '../screens/registration_screen.dart';
import '../screens/profile_screen.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // If Firebase is still loading the auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Check if user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, fetch user data from Firestore
          return FutureBuilder<UserModel?>(
            future: _authService.getUserData(snapshot.data!.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              // If we have user data, go to profile screen
              if (userSnapshot.hasData && userSnapshot.data != null) {
                return ProfileScreen(user: userSnapshot.data!);
              } else {
                // If for some reason we can't get user data, logout and go to login
                _authService.signOut();
                return LoginScreen(); // Changed to LoginScreen
              }
            },
          );
        } else {
          // User is not logged in, go to login screen
          return LoginScreen(); // Changed to LoginScreen
        }
      },
    );
  }
}