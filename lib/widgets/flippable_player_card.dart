import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'game_player_card.dart';
import 'player_card_back.dart';

class FlippablePlayerCard extends StatefulWidget {
  final String gameName;
  final String rank;
  final List<String> mainCharacters;
  final String bio;
  final String username;
  final String country;
  
  // Stats for the back of the card
  final Map<String, dynamic> stats;

  const FlippablePlayerCard({
    Key? key,
    required this.gameName,
    required this.rank,
    required this.mainCharacters,
    required this.bio,
    required this.username,
    required this.country,
    required this.stats,
  }) : super(key: key);

  @override
  State<FlippablePlayerCard> createState() => _FlippablePlayerCardState();
}

class _FlippablePlayerCardState extends State<FlippablePlayerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFrontSide = true;

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
        curve: Curves.easeInOutQuad,
      ),
    );
    
    // Add status listener to update which side is visible
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showFrontSide = false;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _showFrontSide = true;
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
    if (_showFrontSide) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * math.pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective effect
          ..rotateY(angle);
        
        // When card is exactly at 90 degrees, we switch the visible side
        final isFrontVisible = angle < math.pi / 2;
        
        return GestureDetector(
          onTap: _toggleCard,
          child: Transform(
            alignment: Alignment.center,
            transform: transform,
            child: isFrontVisible
                ? _buildFrontSide()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildBackSide(),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildFrontSide() {
    return GamePlayerCard(
      gameName: widget.gameName,
      rank: widget.rank,
      mainCharacters: widget.mainCharacters,
      bio: widget.bio,
      username: widget.username,
      country: widget.country,
      onTap: _toggleCard,
    );
  }

  Widget _buildBackSide() {
    return PlayerCardBack(
      gameName: widget.gameName,
      rank: widget.rank,
      username: widget.username,
      country: widget.country,
      stats: widget.stats,
      onTap: _toggleCard,
    );
  }
}