import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../widgets/flippable_player_card.dart';
import '../screens/player_card_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  
  ProfileScreen({this.user});
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late UserModel user;
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isInit = false;
  late TabController _tabController;
  
  // Mock follower data
  final int _followerCount = 842;
  final int _followingCount = 356;
  
  // Mock post data
  final List<Map<String, dynamic>> _mockPosts = [
    {
      'imageUrl': 'https://via.placeholder.com/500',
      'likes': 124,
      'comments': 24,
      'timestamp': '2d ago',
    },
    {
      'imageUrl': 'https://via.placeholder.com/500',
      'likes': 276,
      'comments': 32,
      'timestamp': '4d ago',
    },
    {
      'imageUrl': 'https://via.placeholder.com/500',
      'likes': 95,
      'comments': 12,
      'timestamp': '1w ago',
    },
    {
      'imageUrl': 'https://via.placeholder.com/500',
      'likes': 188,
      'comments': 21,
      'timestamp': '2w ago',
    },
    {
      'imageUrl': 'https://via.placeholder.com/500',
      'likes': 310,
      'comments': 45,
      'timestamp': '3w ago',
    },
    {
      'imageUrl': 'https://via.placeholder.com/500',
      'likes': 242,
      'comments': 28,
      'timestamp': '1m ago',
    },
  ];

  // Player cards data - moved to a state variable so we can update it
  List<Map<String, dynamic>> _playerCards = [
    {
      'gameName': 'Valorant',
      'rank': 'Diamond',
      'mainCharacters': ['Jett', 'Reyna', 'Sage'],
      'bio': 'Diamond ranked Valorant player specializing in entry fragging and team support.',
      'username': 'ValorantPro',
      'country': 'United States',
      'stats': {
        'kda': '1.8/3.2/4.5',
        'win_rate_recent': '62',
        'games_played': '347',
        'total_matches': '526',
        'champion_win_rates': [
          {'name': 'Jett', 'win_rate': 68, 'icon': 'assets/images/jett.png'},
          {'name': 'Reyna', 'win_rate': 59, 'icon': 'assets/images/reyna.png'},
          {'name': 'Sage', 'win_rate': 72, 'icon': 'assets/images/sage.png'}
        ]
      }
    },
    {
      'gameName': 'League of Legends',
      'rank': 'Platinum',
      'mainCharacters': ['Yasuo', 'Zed', 'Akali'],
      'bio': 'Mid lane main with over 5 years of experience in ranked gameplay.',
      'username': 'MidLaneKing',
      'country': 'Canada',
      'stats': {
        'kda': '8.5/4.2/6.1',
        'win_rate_recent': '55',
        'games_played': '892',
        'total_matches': '1248',
        'champion_win_rates': [
          {'name': 'Yasuo', 'win_rate': 62, 'icon': 'assets/images/yasuo.png'},
          {'name': 'Zed', 'win_rate': 58, 'icon': 'assets/images/zed.png'},
          {'name': 'Akali', 'win_rate': 65, 'icon': 'assets/images/akali.png'}
        ]
      }
    },
    {
      'gameName': 'Fortnite',
      'rank': 'Gold',
      'mainCharacters': ['Assault Rifle', 'Shotgun', 'Sniper'],
      'bio': 'Building specialist with focus on high-ground control and tactical positioning.',
      'username': 'BuildMaster',
      'country': 'Australia',
      'stats': {
        'kda': '3.4/2.1/0.0',
        'win_rate_recent': '42',
        'games_played': '524',
        'total_matches': '982',
        'champion_win_rates': [
          {'name': 'Solo', 'win_rate': 38, 'icon': 'assets/images/solo.png'},
          {'name': 'Duos', 'win_rate': 45, 'icon': 'assets/images/duos.png'},
          {'name': 'Squads', 'win_rate': 52, 'icon': 'assets/images/squads.png'}
        ]
      }
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            bio: 'I love gaming and competing! 🎮 \nProfessional Fortnite Player | Twitch Streamer',
            photoUrl: null,
          );
        }
      }
      
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              user.username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Create new post')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              _showSideMenu(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                // This is where you would refresh user data
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile header (info + stats)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile info row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Profile Picture
                              Container(
                                width: 86,
                                height: 86,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.purple, Colors.orange],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2), // Border for Instagram story effect
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: user.photoUrl != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(user.photoUrl!),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.grey[200],
                                            child: Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 24),
                              
                              // Stats (posts, followers, following)
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatColumn(_playerCards.length.toString(), 'Games'),
                                    _buildStatColumn(_followerCount.toString(), 'Followers'),
                                    _buildStatColumn(_followingCount.toString(), 'Following'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 12),
                          
                          // Username
                          Text(
                            user.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          
                          // Bio
                          if (user.bio != null && user.bio!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                user.bio!,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            
                          SizedBox(height: 16),
                          
                          // Action buttons row
                          Row(
                            children: [
                              // Edit Profile button
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Edit profile pressed')),
                                    );
                                  },
                                  child: Text('Edit Profile'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    side: BorderSide(color: Colors.grey[300]!),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              
                              // Share Profile button
                              OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Share profile pressed')),
                                  );
                                },
                                child: Icon(Icons.person_add_outlined, size: 16),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: Colors.grey[300]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 10),
                    
                    // Tabs (Posts, Game Stats)
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.black,
                      tabs: [
                        Tab(icon: Icon(Icons.grid_on, color: Colors.black)),
                        Tab(icon: Icon(Icons.videogame_asset_outlined, color: Colors.black)),
                      ],
                    ),
                    
                    // Tab content
                    Container(
                      // Make this a flexible height based on content
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Posts Grid
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _mockPosts.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                            ),
                            itemBuilder: (context, index) {
                              return Image.network(
                                _mockPosts[index]['imageUrl'],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          
                          // Game Cards Tab
                          _buildPlayerCardsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // New method to build the player cards tab
  Widget _buildPlayerCardsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Player Cards',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Card'),
                  onPressed: () async {
                    // Navigate to Add Player Card screen and get the result back
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPlayerCardScreen()),
                    );
                    
                    // If we got a result back, add it to our cards
                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        _playerCards.add(result);
                      });
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Player card added successfully!')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Player cards list - handle empty state
          _playerCards.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _playerCards.length,
                  itemBuilder: (context, index) {
                    final card = _playerCards[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Dismissible(
                        key: Key('card_${index}_${card['gameName']}'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            _playerCards.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Player card removed'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  setState(() {
                                    _playerCards.insert(index, card);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: FlippablePlayerCard(
                            gameName: card['gameName'],
                            rank: card['rank'],
                            mainCharacters: List<String>.from(card['mainCharacters']),
                            bio: card['bio'],
                            username: card['username'],
                            country: card['country'],
                            stats: card['stats'],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          
          // Add some padding at the bottom
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videogame_asset_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No player cards yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first player card to showcase your gaming prowess!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPlayerCardScreen()),
              );
              
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  _playerCards.add(result);
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Player card added successfully!')),
                );
              }
            },
            icon: Icon(Icons.add),
            label: Text('Add Your First Card'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // Method to show side menu that slides from right to left
  void _showSideMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Side Menu",
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        
        return SlideTransition(
          position: offsetAnimation,
          child: Align(
            alignment: Alignment.centerRight,
            child: Material(
              child: Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width * 0.8,
                color: Colors.white,
                child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with close button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Menu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    
                    // Menu items
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Settings pressed')),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.bookmark_border),
                      title: Text('Saved'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Saved pressed')),
                        );
                      },
                    ),
                    
                    // Add more menu items
                    ListTile(
                      leading: Icon(Icons.history),
                      title: Text('Activity'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Activity pressed')),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.people_outline),
                      title: Text('Find Friends'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Find Friends pressed')),
                        );
                      },
                    ),
                    
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () async {
                        Navigator.pop(context);
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
              ),
            ),
          ),
        )
        );
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  // Keep this method for potential detailed view
  void _showGameStatsBottomSheet(BuildContext context, String gameName, Map<String, dynamic> stats) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  radius: 24,
                  child: Icon(
                    Icons.games,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gameName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rank: ${stats['rank']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.share_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Share stats pressed')),
                    );
                  },
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Game Stats Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.0,
                children: [
                  _buildDetailedStatItem('Kills', stats['kills'].toString(), Icons.flash_on),
                  _buildDetailedStatItem('Wins', stats['wins'].toString(), Icons.emoji_events),
                  _buildDetailedStatItem('K/D Ratio', stats['kd'].toString(), Icons.trending_up),
                  _buildDetailedStatItem('Playtime', stats['playtime'], Icons.timer),
                ],
              ),
            ),
            
            // Update Stats Button
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Update stats pressed')),
                  );
                },
                child: Text(
                  'Update Stats',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStatItem(String label, String value, IconData iconData) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Theme.of(context).primaryColor,
            size: 22,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}