import 'package:flutter/material.dart';

class EcoBadges extends StatefulWidget {
  const EcoBadges({Key? key}) : super(key: key);

  @override
  _EcoBadgesState createState() => _EcoBadgesState();
}

class _EcoBadgesState extends State<EcoBadges> with TickerProviderStateMixin {
  String? activeBadge;
  int userScore = 350;
  int treeGrowth = 30;
  int co2Reduction = 789;
  bool showTutorial = true;
  int waterLevel = 25;
  int energyType = 1;

  late AnimationController _controller;
  late Animation<int> _animation;
  late Animation<double> _scaleAnimation;

  // Increase tree growth with interactions
  void growTree() {
    if (treeGrowth < 100) {
      setState(() {
        treeGrowth += 5;
        userScore += 10;
      });
    }
  }
  
  // Increase water level with interactions
  void addWater() {
    if (waterLevel < 100) {
      setState(() {
        waterLevel += 5;
        userScore += 10;
      });
    }
  }
  
  // Change energy type with interactions
  void upgradeEnergy() {
    if (energyType < 3) {
      setState(() {
        energyType += 1;
        userScore += 15;
      });
    }
  }
  
  // Get user level based on score
  int getUserLevel() {
    if (userScore < 100) return 1;
    if (userScore < 250) return 2;
    if (userScore < 500) return 3;
    if (userScore < 800) return 4;
    return 5;
  }
  
  // Calculate total environmental impact
  Map<String, int> getTotalImpact() {
    return {
      'trees': treeGrowth ~/ 10,
      'co2': (co2Reduction).floor(),
      'water': (waterLevel * 12).floor(),
      'energy': (energyType * 42).floor()
    };
  }
  
  // Toggle active badge detail view
  void toggleBadgeDetail(String badgeId) {
    setState(() {
      if (activeBadge == badgeId) {
        activeBadge = null;
      } else {
        activeBadge = badgeId;
      }
    });
  }
  
  // Interactive tutorial toggle
  void toggleTutorial() {
    setState(() {
      showTutorial = !showTutorial;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Valeur numérique fluide sur toute la durée
    _animation = IntTween(begin: 0, end: co2Reduction).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Gonflement rapide au début, retour progressif à 1.0
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOutBack)), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeInBack)), weight: 70),
    ]).animate(_controller);

    _controller.forward();
  }



  @override
  void dispose() {
    // N'oubliez pas de nettoyer l'animation pour éviter les fuites de mémoire
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalImpact = getTotalImpact();
    
    // Badge definitions
    final badges = [
      {
        'id': 'forest-saver',
        'title': 'Forest Saver',
        'icon': Icons.park,
        'color': Colors.green,
        'level': (treeGrowth / 20).floor() + 1,
        'maxLevel': 5,
        'progress': treeGrowth,
        'action': growTree,
        'actionLabel': 'Grow',
        'details': [
          "Creates eco-friendly presentations",
          "Reduces digital carbon footprint",
          "Saved equivalent of ${treeGrowth ~/ 10} trees"
        ],
        'impact': "You've prevented ${_animation.value}g of CO₂ emissions"
      },
      {
        'id': 'ocean-guardian',
        'title': 'Ocean Guardian',
        'icon': Icons.water_drop,
        'color': Colors.blue,
        'level': (waterLevel / 20).floor() + 1,
        'maxLevel': 5,
        'progress': waterLevel,
        'action': addWater,
        'actionLabel': 'Add Water',
        'details': [
          "Optimizes media storage",
          "Reduces data center water usage",
          "Saved ${(waterLevel * 12).floor()}L of water"
        ],
        'impact': "Your efficiency has saved water needed for cooling data centers"
      },
      {
        'id': 'green-energy',
        'title': 'Green Energy Champion',
        'icon': Icons.bolt,
        'color': Colors.amber,
        'level': energyType,
        'maxLevel': 3,
        'progress': energyType * 33,
        'action': upgradeEnergy,
        'actionLabel': 'Upgrade',
        'details': [
          "Uses energy-efficient features",
          "Supports transition to renewables",
          "Level $energyType: ${energyType == 1 ? 'Energy Saver' : energyType == 2 ? 'Solar Adopter' : 'Renewable Master'}"
        ],
        'impact': "You've saved ${(energyType * 42).floor()}kWh of electricity"
      }
    ];

    // Hauteur de l'AppBar
    final appBarHeight = AppBar().preferredSize.height;
    // Hauteur de la barre de statut
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
          elevation: 0,
          title: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.arrow_back, color: Colors.white)),
              ),
            ],
          ),
        ),
      body: Container(
        padding: EdgeInsets.only(top: appBarHeight + statusBarHeight, left: 16, right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Color(0xFFEEEEEE)],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with tutorial button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Leyrr Eco Badges',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: toggleTutorial,
                    icon: const Icon(Icons.info_outline),
                    color: Colors.grey[600],
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tutorial section
              if (showTutorial)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'How Eco Badges Work',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            onPressed: toggleTutorial,
                            icon: const Icon(Icons.close),
                            color: Colors.grey[500],
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Interact with your badges to show your commitment to sustainability! Each presentation you create with eco-friendly choices improves your badges:',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          'Click badges to see your impact details',
                          'Use interactive buttons to simulate progress',
                          'Share your achievements with your team',
                          'Gain levels as you make more sustainable choices',
                        ].map((text) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.circle, size: 6, color: Colors.black54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  text,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'In real usage, your badges grow automatically as you use Leyrr\'s eco-friendly features!',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

              // User level and overall status
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.emoji_events,
                            color: Colors.green[600],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Eco Champion Level ${getUserLevel()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const Text(
                                'Keep creating sustainable presentations!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {


                          },
                          icon: const Icon(Icons.share, size: 16),
                          label: const Text('Share Impact'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[50],
                            foregroundColor: Colors.green[700],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: (userScore / 1000).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[200],
                        color: Colors.green[600],
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Impact metrics
                    Row(
                      children: [
                        Expanded(
                          child: _buildImpactMetric(
                            'Trees Saved',
                            totalImpact['trees'].toString(),
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: _buildImpactMetric(
                                'CO₂ Reduction',
                                '${_animation.value}g',
                                Colors.blue,
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildImpactMetric(
                            'Water Saved',
                            '${totalImpact['water']}L',
                            Colors.cyan,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildImpactMetric(
                            'Energy Saved',
                            '${totalImpact['energy']}kWh',
                            Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Badges grid
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.55,
                ),
                itemCount: badges.length,
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  final isActive = activeBadge == badge['id'];
                  final Color badgeColor = badge['color'] as Color;

                  return GestureDetector(
                    onTap: () => toggleBadgeDetail(badge['id'] as String),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: isActive
                              ? badgeColor.withOpacity(0.2)
                              : Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: isActive
                          ? Border.all(color: badgeColor, width: 2)
                          : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: badgeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  badge['icon'] as IconData,
                                  color: badgeColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      badge['title'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          badge['maxLevel'] as int,
                                          (i) => Container(
                                            width: 6,
                                            height: 6,
                                            margin: const EdgeInsets.only(right: 2),
                                            decoration: BoxDecoration(
                                              color: i < (badge['level'] as int)
                                                ? badgeColor
                                                : Colors.grey[300],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ' ${badge['level']}/${badge['maxLevel']}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: ((badge['progress'] as int) / 100).clamp(0.0, 1.0),
                              backgroundColor: Colors.grey[200],
                              color: badgeColor,
                              minHeight: 3,
                            ),
                          ),

                          // Badge details (shown when active)
                          if (isActive) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(height: 1),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...(badge['details'] as List<String>).map((detail) =>
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.eco,
                                            size: 12,
                                            color: badgeColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              detail,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.black54,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    badge['impact'] as String,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final action = badge['action'] as Function;
                                        action();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: badgeColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        textStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: Text(
                                        '${badge['actionLabel']} ${badge['title']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Recent achievements
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Achievements',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAchievement(
                      'Forest Protector Badge Unlocked',
                      'Reached Level 2 by saving 3 trees worth of paper',
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildAchievement(
                      'Eco-Design Milestone',
                      'Created 5 presentations with minimal environmental impact',
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildAchievement(
                      'Resource Optimizer',
                      'Used AI suggestions to reduce presentation size by 65%',
                      Colors.purple,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildImpactMetric(String label, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildAchievement(String title, String description, MaterialColor color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color[50],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.military_tech,
            color: color[600],
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
