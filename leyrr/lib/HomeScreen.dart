import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leyrr/EditorScreen.dart';
import 'package:leyrr/LoginScreen.dart';
import 'package:leyrr/EcoBadges.dart';
import 'package:leyrr/SustainabilityDashboardScreen.dart';
import 'package:leyrr/Test/SustainDashboard.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LocalUser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _firstName;
  int _currentIndex = 0;
  bool isInFrench = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_data');
    if (jsonString != null) {
      final user = LocalUser.fromJson(jsonDecode(jsonString));
      setState(() {
        _firstName = user.firstName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Image.asset('Assets/Images/Logo_Leyrr.png', height: 50),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: isInFrench,
                onChanged: (bool value) {
                  setState(() {
                    isInFrench = value;
                  });
                },
                activeColor: Colors.deepPurpleAccent,
                inactiveTrackColor: Colors.grey,
                inactiveThumbColor: Colors.deepPurpleAccent,
              ),
            )
          ],
        ),
        elevation: 0,
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          if (_currentIndex == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditorScreen(templateName: "Mon Projet")));
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(setFloatingButtonText(), style: TextStyle(color: Colors.white)),
      )
          : null,
      body: Container(
        padding: EdgeInsets.only(top: appBarHeight + statusBarHeight),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFEEEEEE)],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeContent(),
            _buildTemplatesScreen(),
            _buildMoreScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, -1),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          showUnselectedLabels: false,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_open),
              label: isInFrench ? 'Mes projets' : 'My Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.space_dashboard_rounded),
              label: isInFrench ? 'Modèles' : 'Templates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: isInFrench ? 'Plus' : 'More',
            ),
          ],
        ),
      ),
    );
  }

  String setFloatingButtonText() {
    switch (_currentIndex) {
      case 0:
        return isInFrench ? "Nouveau projet" : "New Project";
      case 1:
        return isInFrench ? "Nouveau modèle" : "New Template";
    }
    return "";
  }

  Widget _buildPresentationList() {
    final presentations = [
      {'title': isInFrench ? "Présentation Produit" : "Product Presentation", 'date': "01 mai 2025"},
      {'title': isInFrench ? "Réunion d'équipe" : "Team Meeting", 'date': "27 avril 2025"},
    ];

    return Column(
      children: presentations.map((presentation) {
        return Card(
          color: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.slideshow, size: 32, color: Colors.white),
            title: Text(presentation['title']!, style: TextStyle(color: Colors.white)),
            subtitle: Text(
              isInFrench ? "Modifiée le ${presentation['date']}" : "Modified on ${presentation['date']}",
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              // ouvrir la présentation
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHomeContent() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Lottie.asset(
                'Assets/Animations/presentation_1.json',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isInFrench ? "Bonjour $_firstName 👋" : "Hello $_firstName 👋",
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isInFrench
                ? "Prêt à créer une nouvelle présentation ou en reprendre une ?"
                : "Ready to create a new presentation or pick up one?",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text(
            isInFrench ? "Vos dernières présentations" : "Your Recent Presentations",
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _buildPresentationList(),
        ],
      ),
    );
  }

  Widget _buildTemplatesScreen() {
    final templates = [
      {'preview': 'Assets/Images/Template_preview_1.png'},
      {'preview': 'Assets/Images/Template_preview_2.png'},
      {'preview': 'Assets/Images/Template_preview_3.png'},
      {'preview': 'Assets/Images/Template_preview_5.png'},
      {'preview': 'Assets/Images/Template_preview_6.png'},
      {'preview': 'Assets/Images/Template_preview_7.png'},
      {'preview': 'Assets/Images/Template_preview_8.png'},
      {'preview': 'Assets/Images/Template_preview_9.png'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isInFrench ? "Sélectionnez un modèle" : "Select a template",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Center(child: Column(
              children: [
                Icon(Icons.add),
                SizedBox(height: 20),
                Text(isInFrench ? "Ajouter un modèle" : "Add a template"),
              ],
            )),
          ),
          SizedBox(height: 30),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 16/9
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return InkWell(
                onTap: () {
                  // Naviguer vers l'éditeur avec ce template
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(template['preview']!, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMoreScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isInFrench ? "Plus d'options" : "More Options",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _buildMenuItem(
            icon: Icons.person,
            label: isInFrench ? "Mon profil" : "My Profile",
            onTap: () {
              // Navigate to profile screen
            },
          ),
          _buildMenuItem(
            icon: Icons.emoji_events,
            label: isInFrench ? "Mes badges éco" : "My Eco Badges",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EcoBadges()));
            },
          ),
          _buildMenuItem(
            icon: Icons.eco_rounded,
            label: isInFrench ? "Mon impact environnemental" : "My Environmental Impact",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SustainabilityDashboard()));
            },
          ),

          _buildMenuItem(
            icon: Icons.eco_rounded,
            label: isInFrench ? "Mes statistiques" : "My stats",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeyrSustainabilityDashboard()));
            },
          ),
          const Divider(height: 32),

          _buildMenuItem(
            icon: Icons.article,
            label: isInFrench ? "Conditions d'utilisation" : "Terms of Service",
            onTap: () {
              // Open Terms of Service
            },
          ),
          _buildMenuItem(
            icon: Icons.lock,
            label: isInFrench ? "Politique de confidentialité" : "Privacy Policy",
            onTap: () {
              // Open Privacy Policy
            },
          ),
          const Divider(height: 32),
          _buildMenuItem(
            icon: Icons.settings,
            label: isInFrench ? "Paramètres" : "Settings",
            onTap: () {
              // Navigate to settings screen
            },
          ),
          _buildMenuItem(
            icon: Icons.logout,
            label: isInFrench ? "Se déconnecter" : "Log Out",
            color: Colors.red,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }


  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label, style: TextStyle(color: color)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}
