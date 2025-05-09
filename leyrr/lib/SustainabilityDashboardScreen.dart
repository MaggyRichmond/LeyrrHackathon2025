import 'package:flutter/material.dart';

class SustainabilityDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Hauteur de l'AppBar
    final appBarHeight = AppBar().preferredSize.height;
    // Hauteur de la barre de statut
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(onPressed: () {
                Navigator.of(context).pop();
              }, icon: Icon(Icons.arrow_back, color: Colors.white)),
            ),
            Center(child: Text('Leyrr Eco Dashboard', style: TextStyle(color: Colors.white),)),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: appBarHeight + statusBarHeight),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarbonTracker(),
              SizedBox(height: 20),
              Text("Eco Tips for You", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              _buildTipsSwiper(),
              SizedBox(height: 20),
              Text("Your Eco Badges", style: Theme.of(context).textTheme.titleLarge),
              _buildBadges(),
              SizedBox(height: 20),
              Text("Sustainability Progress", style: Theme.of(context).textTheme.titleLarge),
              _buildProgressBar("Low-impact Slides", 0.75),
              _buildProgressBar("Low-impact Fonts", 0.90),
              _buildProgressBar("Quiz Completion", 0.40),
              _buildProgressBar("Image Compression Usage", 0.90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarbonTracker() {
    return Card(
      color: Colors.green,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Carbon Footprint This Week", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8),
            Text("0.2 kg CO₂ saved", style: TextStyle(fontSize: 22, color: Colors.white)),
            SizedBox(height: 6),
            LinearProgressIndicator(
                value: 0.4,
                color: Colors.white,
                backgroundColor: Color(0xFF307033)),
            SizedBox(height: 15),
            Text("Goal: 500 g/week", style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSwiper() {
    final tips = [
      "Stick to native fonts to minimize loading",
      "Use fewer high-resolution images",
      "Limit animations to reduce energy use",
      "Keep slides below 5MB total",
    ];

    return SizedBox(
      height: 120,
      child: PageView.builder(
        itemCount: tips.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          return Card(
            color: Colors.green,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(tips[index], textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadges() {
    final badgeIcons = [
      Icons.eco,
      Icons.battery_full,
      Icons.trending_down,
      Icons.public,
      Icons.favorite,
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badgeIcons.length,
        itemBuilder: (context, index) {
          return CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
            child: Icon(
              badgeIcons[index],
              size: 28,
              color: Colors.white,
            ),
          );
        },
        separatorBuilder: (context, _) => const SizedBox(width: 12),
      ),
    );
  }


  Widget _buildProgressBar(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label (${(value * 100).toInt()}%)"),
          LinearProgressIndicator(value: value, color: Colors.green),
        ],
      ),
    );
  }
}