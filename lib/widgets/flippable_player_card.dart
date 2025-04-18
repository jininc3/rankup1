import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'player_card.dart';

class FlippablePlayerCard extends StatefulWidget {
  final Map<String, dynamic> cardData;
  final Widget? backWidget;
  final Color? primaryColor;
  final Color? secondaryColor;

  const FlippablePlayerCard({
    Key? key,
    required this.cardData,
    this.backWidget,
    this.primaryColor,
    this.secondaryColor,
  }) : super(key: key);

  @override
  _FlippablePlayerCardState createState() => _FlippablePlayerCardState();
}

class _FlippablePlayerCardState extends State<FlippablePlayerCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  bool isBackVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: math.pi / 2)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(math.pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);

    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(math.pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: math.pi / 2, end: math.pi)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        setState(() {
          isBackVisible = _controller.value >= 0.5;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_controller.value == 0.0) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default back widget if none provided
    Widget backContent = widget.backWidget ?? _buildDefaultBackWidget();

    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Front of card
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateY(_frontRotation.value),
                child: Visibility(
                  visible: !isBackVisible,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: PlayerCard(
                    cardData: widget.cardData,
                    primaryColor: widget.primaryColor,
                    secondaryColor: widget.secondaryColor,
                  ),
                ),
              ),
              
              // Back of card
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateY(_backRotation.value),
                child: Visibility(
                  visible: isBackVisible,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: backContent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Default back widget with game stats
  Widget _buildDefaultBackWidget() {
    // Determine colors based on game
    List<Color> gradientColors = _getCardColors(widget.cardData['game']);
    
    if (widget.primaryColor != null && widget.secondaryColor != null) {
      gradientColors = [widget.primaryColor!, widget.secondaryColor!];
    }

    // Building stats based on game type
    List<Map<String, dynamic>> stats = _getGameSpecificStats(widget.cardData);

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
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientColors[1], gradientColors[0]],  // Reversed gradient for back
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.cardData['username']} Stats',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Stats grid
                Expanded(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      return _buildStatItem(
                        stats[index]['label'],
                        stats[index]['value'],
                        stats[index]['icon'],
                        gradientColors[0],
                      );
                    },
                  ),
                ),
                
                // Update history
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Last updated: Today',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                
                // Tap to flip hint
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
                        'Tap to flip card',
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
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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

  // Helper method to get game-specific stats
  List<Map<String, dynamic>> _getGameSpecificStats(Map<String, dynamic> data) {
    final String game = data['game'];
    
    switch (game) {
      case 'League of Legends':
        return [
          {'label': 'KILLS', 'value': '${(data['totalGames'] * 8).round()}', 'icon': Icons.flash_on},
          {'label': 'DEATHS', 'value': '${(data['totalGames'] * 5).round()}', 'icon': Icons.dangerous},
          {'label': 'ASSISTS', 'value': '${(data['totalGames'] * 7).round()}', 'icon': Icons.handshake},
          {'label': 'CS/MIN', 'value': '7.2', 'icon': Icons.bar_chart},
          {'label': 'KDA', 'value': '3.0', 'icon': Icons.score},
          {'label': 'VISION', 'value': '28', 'icon': Icons.visibility},
        ];
      case 'Valorant':
        return [
          {'label': 'KILLS', 'value': '${(data['totalGames'] * 16).round()}', 'icon': Icons.flash_on},
          {'label': 'DEATHS', 'value': '${(data['totalGames'] * 14).round()}', 'icon': Icons.dangerous},
          {'label': 'ASSISTS', 'value': '${(data['totalGames'] * 5).round()}', 'icon': Icons.handshake},
          {'label': 'HEADSHOT %', 'value': '38%', 'icon': Icons.face},
          {'label': 'FIRST BLOODS', 'value': '${(data['totalGames'] * 0.22).round()}', 'icon': Icons.timer},
          {'label': 'CLUTCHES', 'value': '${(data['totalGames'] * 0.09).round()}', 'icon': Icons.verified},
        ];
      case 'Teamfight Tactics':
        return [
          {'label': 'AVG PLACE', 'value': data['averagePlace'], 'icon': Icons.leaderboard},
          {'label': 'TOP 4 RATE', 'value': '58%', 'icon': Icons.emoji_events},
          {'label': 'TOP 1 RATE', 'value': '18%', 'icon': Icons.workspace_premium},
          {'label': 'AVG LEVEL', 'value': '8.3', 'icon': Icons.upgrade},
          {'label': 'LONGEST WIN', 'value': '5', 'icon': Icons.bolt},
          {'label': 'ECON RATING', 'value': 'B+', 'icon': Icons.account_balance},
        ];
      default:
        return [
          {'label': 'WINS', 'value': '${(data['totalGames'] * 0.55).round()}', 'icon': Icons.emoji_events},
          {'label': 'LOSSES', 'value': '${(data['totalGames'] * 0.45).round()}', 'icon': Icons.close},
          {'label': 'WIN RATE', 'value': data['winRate'], 'icon': Icons.percent},
          {'label': 'TOTAL GAMES', 'value': data['totalGames'].toString(), 'icon': Icons.gamepad},
        ];
    }
  }
}