import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// Using the DiscordColors class from the provided code
class DiscordColors {
  static const Color primaryRed = Color(0xFFED4245);
  static const Color darkGrey = Color(0xFF2C2F33);
  static const Color charcoalGrey = Color(0xFF23272A);
  static const Color lightGrey = Color(0xFFB9BBBE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color mutedRed = Color(0xFFA83232);
  static const Color softGrey = Color(0xFF99AAB5);
}

class PlayerCardBack extends StatelessWidget {
  final String gameName;
  final String rank;
  final String username;
  final String country;
  final VoidCallback onTap;
  final Map<String, dynamic> stats;

  const PlayerCardBack({
    Key? key,
    required this.gameName,
    required this.rank,
    required this.username,
    required this.country,
    required this.onTap,
    required this.stats,
  }) : super(key: key);

  Color getRankColor(String rank) {
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
        return const Color(0xFF4A80EB); // Blue
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
    final rankColor = getRankColor(rank);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.85;
        final cardHeight = cardWidth * 1.5;
        
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: cardWidth,
            height: cardHeight,
            margin: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
            child: Stack(
              children: [
                // Card background with border
                _buildCardBackground(cardWidth, cardHeight, rankColor),
                
                // Card content
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(cardWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header section - Username and game
                        Padding(
                          padding: EdgeInsets.only(top: cardWidth * 0.05, bottom: cardWidth * 0.03),
                          child: Column(
                            children: [
                              Text(
                                username.toUpperCase(),
                                style: TextStyle(
                                  color: DiscordColors.darkGrey,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: rankColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: rankColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '$gameName | $rank',
                                  style: TextStyle(
                                    color: rankColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: DiscordColors.softGrey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    country,
                                    style: const TextStyle(
                                      color: DiscordColors.softGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Divider
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            height: 1,
                            width: double.infinity,
                            color: DiscordColors.darkGrey.withOpacity(0.2),
                          ),
                        ),
                        
                        // Stats section - only include requested stats
                        Expanded(
                          child: _buildNewStatsSection(rankColor),
                        ),
                        
                        // Tap to flip hint
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: rankColor.withOpacity(0.4), width: 1),
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  size: 16,
                                  color: DiscordColors.softGrey.withOpacity(0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Tap to flip',
                                  style: TextStyle(
                                    color: DiscordColors.softGrey.withOpacity(0.7),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
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

  // New stats section with only the requested stats
  Widget _buildNewStatsSection(Color accentColor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary stats (displayed as larger numbers)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPrimaryStat(
                stats['kda'] ?? '0/0/0', 
                'K/D/A', 
                accentColor
              ),
              _buildPrimaryStat(
                '${stats['win_rate_recent'] ?? '0'}%', 
                'WIN RATE (LAST 20)', 
                accentColor
              ),
              _buildPrimaryStat(
                stats['games_played'] ?? '0', 
                'GAMES PLAYED', 
                accentColor
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Champion win rates
          Text(
            'CHAMPION WIN RATES',
            style: TextStyle(
              color: DiscordColors.darkGrey,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          
          // Champion win rate bars
          ..._buildChampionWinRates(accentColor),
          
          const SizedBox(height: 16),
          
          // Total matches display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_esports,
                size: 18,
                color: accentColor,
              ),
              const SizedBox(width: 8),
              Text(
                'TOTAL MATCHES: ${stats['total_matches'] ?? '0'}',
                style: TextStyle(
                  color: DiscordColors.darkGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryStat(String value, String label, Color accentColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: accentColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: DiscordColors.softGrey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildChampionWinRates(Color accentColor) {
    final championWinRates = stats['champion_win_rates'] as List<dynamic>? ?? [];
    
    return championWinRates.map<Widget>((champStat) {
      final Map<String, dynamic> champData = champStat as Map<String, dynamic>;
      final double winRate = double.parse((champData['win_rate'] ?? 0.0).toString()) / 100;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Champion icon (circle with first letter instead of image)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          (champData['name'] as String? ?? 'U').substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      champData['name'] ?? 'Unknown',
                      style: TextStyle(
                        color: DiscordColors.darkGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${(winRate * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Stack(
              children: [
                // Background
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Foreground (filled)
                Container(
                  height: 6,
                  width: double.infinity * winRate.clamp(0.0, 1.0),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}

// Updated ValorantCardPainter for white background
class ValorantCardPainter extends CustomPainter {
  final Color borderColor;
  
  ValorantCardPainter(this.borderColor);
  
  @override
  void paint(Canvas canvas, Size size) {
    final borderWidth = size.width * 0.03;
    
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