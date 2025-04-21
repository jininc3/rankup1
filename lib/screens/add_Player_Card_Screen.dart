import 'package:flutter/material.dart';

class AddPlayerCardScreen extends StatefulWidget {
  const AddPlayerCardScreen({Key? key}) : super(key: key);

  @override
  _AddPlayerCardScreenState createState() => _AddPlayerCardScreenState();
}

class _AddPlayerCardScreenState extends State<AddPlayerCardScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form values
  String _gameName = '';
  String _rank = '';
  String _username = '';
  String _country = '';
  String _bio = '';
  final List<String> _mainCharacters = ['', '', ''];
  
  // Dropdown options
  final List<String> _gameOptions = [
    'Valorant',
    'League of Legends',
    'Fortnite',
    'Apex Legends',
    'Counter-Strike',
    'Overwatch',
    'Call of Duty',
    'DOTA 2'
  ];
  
  final Map<String, List<String>> _rankOptions = {
    'Valorant': ['Iron', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Ascendant', 'Immortal', 'Radiant'],
    'League of Legends': ['Iron', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master', 'Grandmaster', 'Challenger'],
    'Fortnite': ['Open League', 'Contender League', 'Champion League'],
    'Apex Legends': ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master', 'Predator'],
    'Counter-Strike': ['Silver', 'Gold Nova', 'Master Guardian', 'Legendary Eagle', 'Supreme', 'Global Elite'],
    'Overwatch': ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master', 'Grandmaster', 'Top 500'],
    'Call of Duty': ['Recruit', 'Regular', 'Experienced', 'Skilled', 'Expert', 'Elite', 'Master', 'Legendary'],
    'DOTA 2': ['Herald', 'Guardian', 'Crusader', 'Archon', 'Legend', 'Ancient', 'Divine', 'Immortal'],
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Player Card'),
        actions: [
          TextButton(
            onPressed: _saveCard,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Game Selection Dropdown
              _buildSectionHeader('Game Information'),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Game',
                  border: OutlineInputBorder(),
                ),
                hint: Text('Select a game'),
                value: _gameName.isEmpty ? null : _gameName,
                items: _gameOptions.map((String game) {
                  return DropdownMenuItem<String>(
                    value: game,
                    child: Text(game),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _gameName = newValue ?? '';
                    _rank = ''; // Reset rank when game changes
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a game'
                    : null,
              ),
              SizedBox(height: 16),
              
              // Rank Selection Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Rank',
                  border: OutlineInputBorder(),
                ),
                hint: Text('Select your rank'),
                value: _rank.isEmpty ? null : _rank,
                items: _gameName.isEmpty
                    ? []
                    : (_rankOptions[_gameName] ?? []).map((String rank) {
                        return DropdownMenuItem<String>(
                          value: rank,
                          child: Text(rank),
                        );
                      }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _rank = newValue ?? '';
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select your rank'
                    : null,
              ),
              SizedBox(height: 24),
              
              // User Information
              _buildSectionHeader('Player Information'),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                initialValue: _username,
                onChanged: (value) => _username = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your username'
                    : null,
              ),
              SizedBox(height: 16),
              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
                initialValue: _country,
                onChanged: (value) => _country = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your country'
                    : null,
              ),
              SizedBox(height: 16),
              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                  hintText: 'Tell others about your gaming style...',
                ),
                initialValue: _bio,
                maxLines: 3,
                onChanged: (value) => _bio = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a bio'
                    : null,
              ),
              SizedBox(height: 24),
              
              // Main Characters/Weapons
              _buildSectionHeader(_getCharacterLabel()),
              _buildCharacterFields(),
              SizedBox(height: 24),
              
              // Placeholder for the stats section - in a real app, this would be more complex
              _buildSectionHeader('Stats'),
              Text(
                'Basic stats will be added automatically. You can edit them later.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 40),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveCard,
                  child: Text(
                    'Create Player Card',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getCharacterLabel() {
    if (_gameName.isEmpty) return 'Main Characters';
    
    switch (_gameName) {
      case 'Valorant':
      case 'League of Legends':
      case 'Overwatch':
      case 'DOTA 2':
        return 'Main Characters';
      case 'Fortnite':
      case 'Call of Duty':
        return 'Favorite Weapons';
      case 'Apex Legends':
        return 'Main Legends';
      default:
        return 'Main Characters';
    }
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildCharacterFields() {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: '${_getCharacterLabel().substring(0, _getCharacterLabel().length - 1)} ${index + 1}',
              border: OutlineInputBorder(),
            ),
            initialValue: _mainCharacters[index],
            onChanged: (value) {
              setState(() {
                _mainCharacters[index] = value;
              });
            },
            validator: index == 0 ? (value) => value == null || value.isEmpty
                ? 'Please enter at least one ${_getCharacterLabel().toLowerCase().substring(0, _getCharacterLabel().length - 1)}'
                : null : null,
          ),
        );
      }),
    );
  }
  
  void _saveCard() {
    if (_formKey.currentState!.validate()) {
      // Create a basic stats object based on the game
      final Map<String, dynamic> defaultStats = _createDefaultStats();
      
      // Create the player card object
      final Map<String, dynamic> playerCard = {
        'gameName': _gameName,
        'rank': _rank,
        'mainCharacters': _mainCharacters.where((char) => char.isNotEmpty).toList(),
        'bio': _bio,
        'username': _username,
        'country': _country,
        'stats': defaultStats,
      };
      
      // Return the data to the previous screen
      Navigator.pop(context, playerCard);
    }
  }
  
  Map<String, dynamic> _createDefaultStats() {
    // These would ideally come from a game API or user input
    // This is just a simple placeholder
    if (_gameName == 'Valorant') {
      return {
        'kda': '0.0/0.0/0.0',
        'win_rate_recent': '50',
        'games_played': '0',
        'total_matches': '0',
        'champion_win_rates': [
          {'name': _mainCharacters[0], 'win_rate': 50, 'icon': 'assets/images/default.png'},
          if (_mainCharacters[1].isNotEmpty)
            {'name': _mainCharacters[1], 'win_rate': 50, 'icon': 'assets/images/default.png'},
          if (_mainCharacters[2].isNotEmpty)
            {'name': _mainCharacters[2], 'win_rate': 50, 'icon': 'assets/images/default.png'},
        ]
      };
    } else if (_gameName == 'League of Legends') {
      return {
        'kda': '0.0/0.0/0.0',
        'win_rate_recent': '50',
        'games_played': '0',
        'total_matches': '0',
        'champion_win_rates': [
          {'name': _mainCharacters[0], 'win_rate': 50, 'icon': 'assets/images/default.png'},
          if (_mainCharacters[1].isNotEmpty)
            {'name': _mainCharacters[1], 'win_rate': 50, 'icon': 'assets/images/default.png'},
          if (_mainCharacters[2].isNotEmpty)
            {'name': _mainCharacters[2], 'win_rate': 50, 'icon': 'assets/images/default.png'},
        ]
      };
    } else {
      // Generic stats for other games
      return {
        'kda': '0.0/0.0/0.0',
        'win_rate_recent': '50',
        'games_played': '0',
        'total_matches': '0',
        'champion_win_rates': [
          {'name': _mainCharacters[0], 'win_rate': 50, 'icon': 'assets/images/default.png'},
          if (_mainCharacters[1].isNotEmpty)
            {'name': _mainCharacters[1], 'win_rate': 50, 'icon': 'assets/images/default.png'},
          if (_mainCharacters[2].isNotEmpty)
            {'name': _mainCharacters[2], 'win_rate': 50, 'icon': 'assets/images/default.png'},
        ]
      };
    }
  }
}