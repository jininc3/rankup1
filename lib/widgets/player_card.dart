import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final VoidCallback? onTap;
  final Color? primaryColor;
  final Color? secondaryColor;

  const PlayerCard({
    Key? key,
    required this.cardData,
    this.onTap,
    this.primaryColor,
    this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine colors based on game or use provided colors
    List<Color> gradientColors = _getCardColors(cardData['game']);
    
    if (primaryColor != null && secondaryColor != null) {
      gradientColors = [primaryColor!, secondaryColor!];
    }

    // Additional fields for different games
    String subtitle = '';
    if (cardData.containsKey('mainRole') && cardData.containsKey('mainChampion')) {
      subtitle = 'Main: ${cardData['mainRole']} | ${cardData['mainChampion']}';
    } else if (cardData.containsKey('mainRole') && cardData.containsKey('mainAgent')) {
      subtitle = 'Main: ${cardData['mainRole']} | ${cardData['mainAgent']}';
    } else if (cardData.containsKey('favoriteComp')) {
      subtitle = 'Favorite: ${cardData['favoriteComp']}';
    }

    // Stat values
    String statLabel = cardData.containsKey('averagePlace') ? 'AVG PLACE' : 'WIN RATE';
    String statValue = cardData.containsKey('averagePlace') 
        ? cardData['averagePlace'] 
        : cardData['winRate'];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header row with game info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Game name and icon
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: cardData.containsKey('gameIcon') && cardData['gameIcon'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      cardData['gameIcon'],
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.games,
                                        color: Colors.grey[800],
                                        size: 18,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.games,
                                      color: Colors.grey[800],
                                      size: 18,
                                    ),
                                  ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            cardData['game'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      
                      // Rank info
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: cardData.containsKey('rankIcon') && cardData['rankIcon'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      cardData['rankIcon'],
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.military_tech,
                                        color: gradientColors[0],
                                        size: 14,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.military_tech,
                                      color: gradientColors[0],
                                      size: 14,
                                    ),
                                  ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              cardData['rank'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Player info
                  Row(
                    children: [
                      // Player icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: cardData.containsKey('playerIcon') && cardData['playerIcon'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                cardData['playerIcon'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(
                                  Icons.person,
                                  color: Colors.grey[800],
                                  size: 30,
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[800],
                                size: 30,
                              ),
                            ),
                      ),
                      SizedBox(width: 16),
                      
                      // Player username and additional info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cardData['username'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Stats footer
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              statLabel,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              statValue,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        Column(
                          children: [
                            Text(
                              'TOTAL GAMES',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              cardData['totalGames'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Flip card hint
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Colors.white.withOpacity(0.7),
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Tap for detailed stats',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to get card colors based on game
  List<Color> _getCardColors(String game) {
    switch (game) {
      case 'League of Legends':
        return [Colors.blue.shade700, Colors.blue.shade500];
      case 'Valorant':
        return [Colors.red.shade700, Colors.red.shade500];
      case 'Teamfight Tactics':
        return [Colors.purple.shade700, Colors.purple.shade500];
      case 'Wild Rift':
        return [Colors.teal.shade700, Colors.teal.shade500];
      case 'Legends of Runeterra':
        return [Colors.amber.shade800, Colors.amber.shade600];
      default:
        return [Colors.blue.shade700, Colors.blue.shade500];
    }
  }
}