import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'HomeScreen.dart';
import 'dart:math';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Choose your plan"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const AnimatedLottieGridBackground(),
          // The drawer that comes up from the bottom
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Unlock your creativity ✨",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Choose a plan to continue",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      _buildPlanCard(
                        context,
                        title: "Free",
                        description:
                        "• Up to 3 presentations\n• Limited export\n• Occasional ads",
                        price: "0€ / month",
                        color: Colors.grey.shade200,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPlanCard(
                        context,
                        title: "Premium",
                        description:
                        "• Unlimited presentations\n• HD export + sharing\n• No ads + cloud storage",
                        price: "4.99€ / month",
                        color: Colors.deepPurpleAccent,
                        highlight: true,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
      BuildContext context, {
        required String title,
        required String description,
        required String price,
        required Color color,
        required VoidCallback onPressed,
        bool highlight = false,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: highlight ? 8 : 4,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(highlight) Text('Pro Design', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
            if(highlight) Image.asset('Assets/Images/Logo_Leyrr.png', height: 30,),
            if(!highlight) Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: highlight ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(fontSize: 14, color: highlight ? Colors.white : Colors.black)),
            const SizedBox(height: 12),
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: highlight ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: highlight ? Colors.white : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onPressed,
                child: Text(highlight ? "Choisir Premium" : "Choisir Gratuit", style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedLottieGridBackground extends StatefulWidget {
  const AnimatedLottieGridBackground({super.key});

  @override
  State<AnimatedLottieGridBackground> createState() => _AnimatedLottieGridBackgroundState();
}



class _AnimatedLottieGridBackgroundState extends State<AnimatedLottieGridBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  final List<String> lottiePaths = [
    'Assets/Animations/presentation_1.json',
  ];

  final ScrollController _scrollController = ScrollController();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.05, -0.3),
      end: const Offset(0.05, -0.3),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      _scrollController.jumpTo(0);
    }
  }

  Widget _buildRandomLottie() {
    String randomPath = lottiePaths[_random.nextInt(lottiePaths.length)];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 305),
      child: SizedBox(
        width: 220,
        child: Opacity(
          opacity: 1,
          child: Transform.rotate(
            angle: -0.5236,
            child: Lottie.asset(
              randomPath,
              repeat: true,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Positioned.fill(
      child: IgnorePointer(
        child: SlideTransition(
          position: _offsetAnimation,
          child: Stack(
            children: [
              // Partie supérieure (défilement)
              ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: null,
                itemBuilder: (context, index) {
                  return _buildRandomLottie();
                },
              ),
              // Partie inférieure (deux lignes pour compléter les trous)
              Positioned(
                top: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(3, (_) => _buildRandomLottie()), // Ligne 1
                    ),
                    Row(
                      children: List.generate(3, (_) => _buildRandomLottie()), // Ligne 2
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
}














