import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  
  ProfileScreen({this.user});
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel user;
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isInit) {
      // First check if we received user directly from the constructor
      if (widget.user != null) {
        user = widget.user!;
      } else {
        // Otherwise try to get from route arguments
        final args = ModalRoute.of(context)?.settings.arguments;
        
        if (args != null && args is UserModel) {
          user = args;
        } else {
          // Default user if no data is passed
          user = UserModel(
            uid: 'sample-uid',
            username: 'GamerUser',
            email: 'gamer@example.com',
            bio: 'I love gaming and competing!',
            photoUrl: null,
          );
        }
      }
      
      _isInit = true;
    }
  }

  // This is a placeholder for game stats
  // Later you would fetch this from Firestore
  final Map<String, Map<String, dynamic>> _mockGameStats = {
    'Fortnite': {
      'kills': 1240,
      'wins': 87,
      'kd': 2.5,
      'playtime': '342h',
      'rank': 'Diamond',
      'iconUrl': 'assets/fortnite_icon.png',
    },
    'Call of Duty': {
      'kills': 3451,
      'wins': 156,
      'kd': 1.8,
      'playtime': '523h',
      'rank': 'Platinum',
      'iconUrl': 'assets/cod_icon.png',
    },
    'Apex Legends': {
      'kills': 2180,
      'wins': 95,
      'kd': 2.2,
      'playtime': '280h',
      'rank': 'Gold',
      'iconUrl': 'assets/apex_icon.png',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              try {
                await _authService.signOut();
                // Navigation will be handled by AuthWrapper
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error signing out: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                // This is where you would refresh user data from Firestore
                setState(() {
                  _isLoading = true;
                });
                
                // Simulate loading
                await Future.delayed(Duration(seconds: 1));
                
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Center(
                        child: Column(
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              child: user.photoUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        user.photoUrl!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Theme.of(context).primaryColor,
                                    ),
                            ),
                            SizedBox(height: 12),
                            
                            // Username
                            Text(
                              user.username,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            
                            // Email
                            Text(
                              user.email,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            
                            // Bio
                            if (user.bio != null && user.bio!.isNotEmpty)
                              Text(
                                user.bio!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              
                            SizedBox(height: 16),
                            
                            // Edit Profile Button
                            OutlinedButton.icon(
                              icon: Icon(Icons.edit),
                              label: Text('Edit Profile'),
                              onPressed: () {
                                // This is where you would navigate to edit profile screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Edit profile functionality not implemented yet')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Game Stats Section
                      Text(
                        'Game Stats',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      
                      // Game Cards
                      ..._mockGameStats.entries.map((entry) {
                        final gameName = entry.key;
                        final stats = entry.value;
                        
                        return Card(
                          margin: EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Game Header
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                      child: Icon(
                                        Icons.games,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          gameName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Rank: ${stats['rank']}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                
                                // Game Stats
                                GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2.5,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    _buildStatItem('Kills', stats['kills'].toString()),
                                    _buildStatItem('Wins', stats['wins'].toString()),
                                    _buildStatItem('K/D', stats['kd'].toString()),
                                    _buildStatItem('Playtime', stats['playtime']),
                                  ],
                                ),
                                SizedBox(height: 8),
                                
                                // View More Button
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      // This is where you would navigate to detailed game stats
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Detailed stats not implemented yet')),
                                      );
                                    },
                                    child: Text('View More Stats'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      
                      // Add Game Button
                      Center(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Add Game'),
                          onPressed: () {
                            // This is where you would navigate to add game screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Add game functionality not implemented yet')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}