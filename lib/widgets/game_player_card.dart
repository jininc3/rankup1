import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

// Discord-style color palette
class DiscordColors {
  static const Color primaryRed = Color(0xFFED4245);
  static const Color darkGrey = Color(0xFF2C2F33);
  static const Color charcoalGrey = Color(0xFF23272A);
  static const Color lightGrey = Color(0xFFB9BBBE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color mutedRed = Color(0xFFA83232);
  static const Color softGrey = Color(0xFF99AAB5);
}

class GamePlayerCard extends StatefulWidget {
  final String gameName;
  final String rank;
  final List<String> mainCharacters;
  final String bio;
  final VoidCallback onTap;
  final String username;
  final String country;
  
  // New stats parameters for back of card
  final Map<String, String> stats;
  final String playStyle;
  final String joinDate;

  const GamePlayerCard({
    Key? key,
    required this.gameName,
    required this.rank,
    required this.mainCharacters,
    required this.bio,
    required this.onTap,
    this.username = 'User',
    this.country = 'Unknown',
    this.stats = const {},
    this.playStyle = '',
    this.joinDate = '',
  }) : super(key: key);

  @override
  State<GamePlayerCard> createState() => _GamePlayerCardState();
}

class _GamePlayerCardState extends State<GamePlayerCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      if (_isFlipped) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _isFlipped = !_isFlipped;
    });
  }

  Color getRankColor(String rank) {
    // Match colors to Valorant rank colors
    switch (rank.toLowerCase()) {
      case 'iron':
        return const Color(0xFF7C8792); // Grey
      case 'bronze':
        return const Color(0xFFAD7F47); // Bronze
      case 'silver':
        return const Color(0xFFAFB8C4); // Silver
      case 'gold':
        return const Color(0xFFECCE52); // Gold
      case 'platinum':
        return const Color(0xFF47B986); // Teal
      case 'diamond':
        return const Color(0xFF4A80EB); // Blue (adjusted to match image)
      case 'ascendant':
        return const Color(0xFF44CE9C); // Green
      case 'immortal':
        return const Color(0xFFBF4D4D); // Red
      case 'radiant':
        return const Color(0xFFFFD700); // Gold/Yellow
      default:
        return DiscordColors.primaryRed; // Discord red default
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankColor = getRankColor(widget.rank);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.85; // Make card 85% of available width
        // Making the card more rectangular like in the image
        final cardHeight = cardWidth * 1.5; // Slightly shorter aspect ratio
        
        return GestureDetector(
          onTap: () {
            _toggleCard(); // Toggle the card when tapped
            widget.onTap();
          },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              // Calculate the rotation based on animation value
              final rotation = _animation.value * math.pi;
              
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateY(rotation),
                child: rotation < math.pi / 2
                    ? _buildFrontCard(cardWidth, cardHeight, rankColor) // Front of card
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi), // Ensure text isn't backwards
                        child: _buildBackCard(cardWidth, cardHeight, rankColor), // Back of card
                      ),
              );
            },
          ),
        );
      }
    );
  }

  Widget _buildFrontCard(double width, double height, Color borderColor) {
  return Container(
    width: width,
    height: height,
    margin: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
    child: Stack(
      children: [
        _buildCardBackground(width, height, borderColor),

        // Game icon in top left (using an icon instead of image)
        Positioned(
          top: 30,
          left: 32,
          child: Icon(
            _getGameIcon(widget.gameName),
            color: borderColor,
            size: 40,
          ),
        ),

        // Lane icon on the right
        Positioned(
          top: height * 0.78,
          right: 36,
          child: Icon(
            Icons.track_changes, // placeholder for lane icon
            color: borderColor,
            size: 24,
          ),
        ),

        // Main content
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: width * 0.03),
           child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30), // Top spacer
                // Username
                Text(
                  widget.username.toUpperCase(),
                  style: const TextStyle(
                    color: DiscordColors.darkGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                // Profile picture (circle with initials instead of image)
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: width * 0.12,
                    backgroundColor: borderColor.withOpacity(0.2),
                    child: Text(
                      _getInitials(widget.username),
                      style: TextStyle(
                        color: borderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Rank icon (text based instead of image)
                SizedBox(
                  height: width * 0.5,
                  child: _buildRankEmblem(widget.rank, borderColor, width * 0.18),
                ),

                // Rank, Subtitle, Game name
                Column(
                  children: [
                    Text(
                      widget.rank.toUpperCase(),
                      style: const TextStyle(
                        color: DiscordColors.darkGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '*SMITE WINNER', // You can make this dynamic later
                      style: TextStyle(
                        color: DiscordColors.softGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.gameName.toUpperCase(),
                      style: TextStyle(
                        color: borderColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // "Tap for stats" at bottom center
        Positioned(
          bottom: width * 0.13,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor.withOpacity(0.4), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, size: 16, color: borderColor),
                  const SizedBox(width: 4),
                  Text(
                    "TAP FOR STATS",
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildBackCard(double width, double height, Color borderColor) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
      child: Stack(
        children: [
          // Card background with border
          _buildCardBackground(width, height, borderColor),
          
          // Card content
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(width * 0.07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with username and rank
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Username
                      Text(
                        widget.username.toUpperCase(),
                        style: const TextStyle(
                          color: DiscordColors.darkGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      
                      // Rank badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: borderColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.rank.toUpperCase(),
                              style: TextStyle(
                                color: borderColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Main stats section with grid
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats header
                        Row(
                          children: [
                            Icon(Icons.bar_chart, color: borderColor, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              "PLAYER STATS",
                              style: TextStyle(
                                color: borderColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Stats grid
                        Expanded(
                          child: _buildStatsGrid(borderColor),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Main characters section
                        Row(
                          children: [
                            Icon(Icons.favorite, color: borderColor, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              "MAIN ${widget.gameName == 'Valorant' || widget.gameName == 'League of Legends' ? 'CHARACTERS' : 'WEAPONS'}",
                              style: TextStyle(
                                color: borderColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Character/weapon tags
                        Row(
                          children: widget.mainCharacters.map((character) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor.withOpacity(0.6), width: 1),
                                ),
                                child: Text(
                                  character,
                                  style: TextStyle(
                                    color: DiscordColors.darkGrey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Bio section
                        Row(
                          children: [
                            Icon(Icons.person, color: borderColor, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              "BIO",
                              style: TextStyle(
                                color: borderColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          widget.bio,
                          style: TextStyle(
                            color: DiscordColors.darkGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Bottom info (join date, country, tap to flip)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Join date
                      widget.joinDate.isNotEmpty ? Row(
                        children: [
                          const Icon(Icons.calendar_today, color: DiscordColors.softGrey, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "Since ${widget.joinDate}",
                            style: const TextStyle(
                              color: DiscordColors.softGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ) : const SizedBox(),
                      
                      // Tap to flip again indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor.withOpacity(0.4), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.flip, size: 14, color: borderColor),
                            const SizedBox(width: 4),
                            Text(
                              "FLIP CARD",
                              style: TextStyle(
                                color: borderColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Color accentColor) {
    // Default stats if not provided
    final Map<String, String> displayStats = widget.stats.isEmpty 
        ? {
            'KDA': '2.8',
            'Win Rate': '54%',
            'Matches': '1,245',
            'Headshots': '68%',
            'Avg Score': '265',
            'Top 3': '43%',
          }
        : widget.stats;
        
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: displayStats.length,
      itemBuilder: (context, index) {
        final statName = displayStats.keys.elementAt(index);
        final statValue = displayStats.values.elementAt(index);
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statValue,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                statName,
                style: const TextStyle(
                  color: DiscordColors.softGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardBackground(double width, double height, Color borderColor) {
    return Stack(
      children: [
        // White background with rounded corners
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),

        // Custom paint layer for the octagonal border
        Center(
          child: CustomPaint(
            size: Size(width, height),
            painter: ValorantCardPainter(borderColor),
          ),
        ),
      ],
    );
  }

  Widget _buildRankEmblem(String rank, Color rankColor, double size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Simple diamond shape using CustomPaint instead of image
          CustomPaint(
            size: Size(size * 3, size * 2.4),
            painter: DiamondPainter(rankColor),
          ),
          
          // Text instead of image
          Text(
            rank.toUpperCase(),
            style: TextStyle(
              color: rankColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get initials from username
  String _getInitials(String username) {
    if (username.isEmpty) return '';
    
    List<String> nameParts = username.split(RegExp(r'[^a-zA-Z]'));
    nameParts = nameParts.where((part) => part.isNotEmpty).toList();
    
    if (nameParts.isEmpty) return username.substring(0, 1).toUpperCase();
    
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return nameParts[0].substring(0, 1).toUpperCase();
    }
  }

  // Get icon based on game name
  IconData _getGameIcon(String gameName) {
    switch (gameName.toLowerCase()) {
      case 'valorant':
        return Icons.sports_esports;
      case 'league of legends':
        return Icons.shield;
      case 'fortnite':
        return Icons.grain;
      case 'apex legends':
        return Icons.flash_on;
      case 'call of duty':
        return Icons.gps_fixed;
      case 'overwatch':
        return Icons.visibility;
      default:
        return Icons.games;
    }
  }
}

class ValorantCardPainter extends CustomPainter {
  final Color borderColor;
  
  ValorantCardPainter(this.borderColor);
  
  @override
  void paint(Canvas canvas, Size size) {
    final borderWidth = size.width * 0.03; // Reduced border width from 5% to 3%
    
    // Create a rounded rectangle path with clipped corners (octagonal shape)
    final path = _createOctagonalPath(size, borderWidth * 1.5);
    
    // Draw the border with a gradient
    final borderPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [
          borderColor.withOpacity(0.8),
          borderColor,
          borderColor.withOpacity(0.9),
          Colors.white.withOpacity(0.15), // subtle highlight
        ],
        [0.0, 0.4, 0.7, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    
    canvas.drawPath(path, borderPaint);
    
    // Draw inner accent line
    final innerPath = _createOctagonalPath(
      Size(size.width - borderWidth * 2, size.height - borderWidth * 2),
      borderWidth,
      offset: Offset(borderWidth, borderWidth)
    );
    
    final innerBorderPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    canvas.drawPath(innerPath, innerBorderPaint);
  }
  
  Path _createOctagonalPath(Size size, double cornerCut, {Offset offset = Offset.zero}) {
    final path = Path();
    
    // Define points for an octagonal shape (clipped corners rectangle)
    path.moveTo(offset.dx + cornerCut, offset.dy);
    path.lineTo(offset.dx + size.width - cornerCut, offset.dy);
    path.lineTo(offset.dx + size.width, offset.dy + cornerCut);
    path.lineTo(offset.dx + size.width, offset.dy + size.height - cornerCut);
    path.lineTo(offset.dx + size.width - cornerCut, offset.dy + size.height);
    path.lineTo(offset.dx + cornerCut, offset.dy + size.height);
    path.lineTo(offset.dx, offset.dy + size.height - cornerCut);
    path.lineTo(offset.dx, offset.dy + cornerCut);
    path.close();
    
    return path;
  }

  @override
  bool shouldRepaint(ValorantCardPainter oldDelegate) => 
    oldDelegate.borderColor != borderColor;
}

class DiamondPainter extends CustomPainter {
  final Color baseColor;
  
  DiamondPainter(this.baseColor);
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final diamondSize = size.width * 0.7;
    
    // Draw a diamond shape
    final diamondPath = Path();
    
    // Diamond points
    final top = Offset(center.dx, center.dy - diamondSize / 2);
    final right = Offset(center.dx + diamondSize / 2, center.dy);
    final bottom = Offset(center.dx, center.dy + diamondSize / 2);
    final left = Offset(center.dx - diamondSize / 2, center.dy);
    
    diamondPath.moveTo(top.dx, top.dy);
    diamondPath.lineTo(right.dx, right.dy);
    diamondPath.lineTo(bottom.dx, bottom.dy);
    diamondPath.lineTo(left.dx, left.dy);
    diamondPath.close();
    
    // Paint with linear gradient for 3D effect
    final gradientPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(center.dx - diamondSize / 4, center.dy - diamondSize / 4),
        Offset(center.dx + diamondSize / 4, center.dy + diamondSize / 4),
        [
          baseColor.withOpacity(0.7),
          baseColor,
          baseColor.withOpacity(0.8),
        ],
        [0.0, 0.5, 1.0]
      );
    
    canvas.drawPath(diamondPath, gradientPaint);
    
    // Inner diamond for highlights
    final innerSize = diamondSize * 0.6;
    final innerDiamondPath = Path();
    
    // Inner diamond points
    final innerTop = Offset(center.dx, center.dy - innerSize / 2);
    final innerRight = Offset(center.dx + innerSize / 2, center.dy);
    final innerBottom = Offset(center.dx, center.dy + innerSize / 2);
    final innerLeft = Offset(center.dx - innerSize / 2, center.dy);
    
    innerDiamondPath.moveTo(innerTop.dx, innerTop.dy);
    innerDiamondPath.lineTo(innerRight.dx, innerRight.dy);
    innerDiamondPath.lineTo(innerBottom.dx, innerBottom.dy);
    innerDiamondPath.lineTo(innerLeft.dx, innerLeft.dy);
    innerDiamondPath.close();
    
    // Paint with lighter color
    final innerPaint = Paint()
      ..color = baseColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(innerDiamondPath, innerPaint);
    
    // Add highlight
    final highlightPath = Path();
    final highlightSize = diamondSize * 0.3;
    
    final hTop = Offset(center.dx, center.dy - highlightSize / 2);
    final hRight = Offset(center.dx + highlightSize / 2, center.dy);
    
    highlightPath.moveTo(hTop.dx, hTop.dy);
    highlightPath.lineTo(hRight.dx, hRight.dy);
    highlightPath.lineTo(center.dx, center.dy);
    highlightPath.close();
    
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(highlightPath, highlightPaint);
  }
  
  @override
  bool shouldRepaint(DiamondPainter oldDelegate) => 
    oldDelegate.baseColor != baseColor;
}