import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class LeyrSustainabilityDashboard extends StatefulWidget {
  const LeyrSustainabilityDashboard({Key? key}) : super(key: key);

  @override
  _LeyrSustainabilityDashboardState createState() => _LeyrSustainabilityDashboardState();
}

class _LeyrSustainabilityDashboardState extends State<LeyrSustainabilityDashboard> {
  String? expandedCardId;
  String activeTab = 'overview';
  final String userId = 'demo-user'; // This would normally come from auth

  // Carbon footprint comparison data
  final List<Map<String, dynamic>> carbonData = [
    {'name': 'Leyrr', 'value': 48, 'color': const Color(0xFF4CAF50)},
    {'name': 'Canva', 'value': 112, 'color': const Color(0xFFFF9800)},
    {'name': 'Prezi', 'value': 93, 'color': const Color(0xFFF44336)},
    {'name': 'PowerPoint', 'value': 137, 'color': const Color(0xFF2196F3)},
    {'name': 'Google Slides', 'value': 105, 'color': const Color(0xFF9C27B0)},
  ];

  // Monthly energy savings data
  final List<Map<String, dynamic>> energyData = [
    {'month': 'Jan', 'Leyrr': 26, 'Industry': 68},
    {'month': 'Feb', 'Leyrr': 24, 'Industry': 65},
    {'month': 'Mar', 'Leyrr': 28, 'Industry': 70},
    {'month': 'Apr', 'Leyrr': 22, 'Industry': 72},
    {'month': 'May', 'Leyrr': 21, 'Industry': 75},
    {'month': 'Jun', 'Leyrr': 25, 'Industry': 74},
  ];

  // Eco-design score data
  final List<Map<String, dynamic>> radarData = [
    {'subject': 'Image Optimization', 'Leyrr': 90, 'Competitors': 60},
    {'subject': 'Code Efficiency', 'Leyrr': 85, 'Competitors': 55},
    {'subject': 'Green Hosting', 'Leyrr': 95, 'Competitors': 40},
    {'subject': 'File Size', 'Leyrr': 80, 'Competitors': 65},
    {'subject': 'Local Processing', 'Leyrr': 75, 'Competitors': 50},
  ];

  // Energy sources distribution data
  final List<Map<String, dynamic>> energySourceData = [
    {'name': 'Renewable', 'value': 82, 'color': const Color(0xFF4CAF50)},
    {'name': 'Nuclear', 'value': 15, 'color': const Color(0xFF2196F3)},
    {'name': 'Fossil', 'value': 3, 'color': const Color(0xFFF44336)},
  ];

  // Total savings data
  final Map<String, String> savingsData = {
    'co2': '1,245 kg',
    'energy': '3,720 kWh',
    'water': '12,800 L',
    'trees': '68',
  };

  void toggleCard(String cardId) {
    setState(() {
      expandedCardId = expandedCardId == cardId ? null : cardId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Image.asset('Assets/Images/Logo_Leyrr.png', height: 50,),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Header
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Environmental Impact',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  // Tab Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabButton('overview', 'Overview'),
                      SizedBox(width: 10),
                      _buildTabButton('detailed', 'Detailed Analysis'),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Stats Cards
              GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 :
                MediaQuery.of(context).size.width > 600 ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard('CO₂ Reduction', savingsData['co2']!, Colors.green, Icons.eco),
                  _buildStatCard('Energy Saved', savingsData['energy']!, Colors.blue, Icons.bolt),
                  _buildStatCard('Water Saved', savingsData['water']!, Colors.cyan, Icons.water_drop),
                  _buildStatCard('Trees Equivalent', savingsData['trees']!, Colors.amber, Icons.forest),
                ],
              ),

              const SizedBox(height: 24),

              // Chart Cards
              _buildChartGrid(),

              const SizedBox(height: 24),

              // Certification Badge
              _buildCertificationBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabId, String label) {
    final bool isActive = activeTab == tabId;

    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = tabId;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.green[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, MaterialColor color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Icon(
                Icons.arrow_upward,
                color: color,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'vs industry average',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                icon,
                color: color[300],
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '+12% this month',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartGrid() {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 2 : 1,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Carbon Footprint Chart
        _buildChartCard(
          'carbon',
          'Carbon Footprint per Presentation',
          'Comparison in grams of CO₂e',
          _buildBarChart(),
          _carbonDetailContent(),
        ),

        // Energy Consumption Chart
        _buildChartCard(
          'energy',
          'Monthly Energy Consumption',
          'kWh per active user',
          _buildLineChart(),
          _energyDetailContent(),
        ),

        // Eco-design Score Chart
        _buildChartCard(
          'radar',
          'Eco-design Score',
          'Comparison by criterion (score out of 100)',
          _buildRadarChart(),
          _radarDetailContent(),
        ),

        // Energy Sources Chart
        _buildChartCard(
          'sources',
          'Leyrr Cloud Energy Sources',
          'Percentage breakdown',
          _buildPieChart(),
          _sourcesDetailContent(),
        ),
      ],
    );
  }

  Widget _buildChartCard(
      String cardId,
      String title,
      String subtitle,
      Widget chart,
      Widget? detailContent,
      ) {
    final bool isExpanded = expandedCardId == cardId;

    return GestureDetector(
      onTap: () => toggleCard(cardId),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  color: Colors.grey[600],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Chart
            SizedBox(
              height: isExpanded ? 240 : 180,
              child: chart,
            ),

            // Expanded content
            if (isExpanded && detailContent != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              detailContent,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 150,
        minY: 0,
        groupsSpace: 12,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipMargin: 8,  // Paramètre mis à jour dans la version la plus récente
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${carbonData[groupIndex]['name']}: ${carbonData[groupIndex]['value']} g CO₂e',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < carbonData.length) {
                  return Text(
                    carbonData[index]['name'] as String,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 32,  // Si besoin d'ajuster l'espace réservé
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 30,
              interval: 30,
            ),
          ),
          topTitles: AxisTitles(drawBelowEverything: false),
          rightTitles: AxisTitles(drawBelowEverything: false),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: List.generate(
          carbonData.length,
              (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                fromY: 0, // Ajouté fromY pour la compatibilité avec la nouvelle API
                toY: carbonData[index]['value'].toDouble(),
                color: Colors.red,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                width: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _carbonDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This metric calculates the average carbon footprint generated by creating and hosting a standard 15-slide presentation. Calculations include:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildDetailChip('Server CPU/GPU consumption'),
            _buildDetailChip('Data transfer'),
            _buildDetailChip('Cloud storage'),
            _buildDetailChip('AI computations'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.eco,
                color: Colors.green[700],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Leyrr generates 57% fewer emissions than the average competitor platform.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipMargin: 8, // Marge pour le tooltip
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300]!,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey[300]!,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < energyData.length) {
                  return Text(
                    energyData[index]['month'] as String,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }
                return const Text('');
              }, // Espacement des titres
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 30,
              interval: 20,
            ),
          ),
          topTitles: AxisTitles(drawBelowEverything: false),
          rightTitles: AxisTitles(drawBelowEverything: false),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        minX: 0,
        maxX: energyData.length - 1.0,
        minY: 0,
        maxY: 80,
        lineBarsData: [
          // Leyrr Line
          LineChartBarData(
            spots: List.generate(
              energyData.length,
                  (index) => FlSpot(
                index.toDouble(),
                (energyData[index]['Leyrr'] as int).toDouble(),
              ),
            ),
            isCurved: true,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
          // Industry Average Line
          LineChartBarData(
            spots: List.generate(
              energyData.length,
                  (index) => FlSpot(
                index.toDouble(),
                (energyData[index]['Industry'] as int).toDouble(),
              ),
            ),
            isCurved: true,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _energyDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This chart shows the evolution of average energy consumption per active user on a monthly basis. Leyrr\'s continuous optimization enables a consistent reduction in energy consumption.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Optimization factors:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildDetailChip('Optimized cloud architecture'),
            _buildDetailChip('Intelligent media compression'),
            _buildDetailChip('Repetitive calculations caching'),
            _buildDetailChip('Local processing when possible'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.bolt,
                color: Colors.green[700],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Leyrr consumes on average 65% less energy than competitor platforms.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadarChart() {
    // Using a simplified radar chart implementation with CustomPaint
    // In a real application, you would use a more sophisticated library
    // or implement a full RadarChart widget
    return CustomPaint(
      painter: RadarChartPainter(radarData),
      child: const Center(
        child: Text(
          'Eco-design Score Comparison',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _radarDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This radar chart compares the eco-design scores of Leyrr and the average of competitors according to 5 key criteria:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: radarData.length,
          itemBuilder: (context, index) {
            final item = radarData[index];
            final leyrScore = item['Leyrr'] as int;
            final compScore = item['Competitors'] as int;
            final diff = leyrScore - compScore;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['subject'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    '+$diff pts',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green[700],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Leyrr outperforms the average of competitors in all eco-design categories.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: energySourceData.map((data) {
          return PieChartSectionData(
            value: data['value'].toDouble(),
            color: data['color'] as Color,
            title: '${data['value']}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _sourcesDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This chart shows the distribution of energy sources used to power Leyrr\'s cloud infrastructure.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: energySourceData.length,
          itemBuilder: (context, index) {
            final item = energySourceData[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: '${item['name']} (${item['value']}%): ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: _getEnergySourceDescription(item['name'] as String),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.green[700],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Leyrr is on track to achieve 100% renewable energy by 2026.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getEnergySourceDescription(String source) {
    switch (source) {
      case 'Renewable':
        return 'Solar, wind, hydroelectric';
      case 'Nuclear':
        return 'Low CO₂ emission power plants';
      case 'Fossil':
        return 'Used only for backup systems';
      default:
        return '';
    }
  }

  Widget _buildDetailChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCertificationBadge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified,
              color: Colors.green[600],
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Green IT Certification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Leyrr is certified according to ISO 14001 and 50001 standards for software eco-design',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Learn More',
              style: TextStyle(
                color: Colors.green[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A simplified radar chart painter
class RadarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  RadarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;
    final categories = data.length;

    // Draw web
    final webPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final webPoints = <Offset>[];

    for (int i = 0; i < categories; i++) {
      final angle = 2 * math.pi * i / categories - math.pi / 2;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      webPoints.add(point);

      // Draw line from center to point
      canvas.drawLine(center, point, webPaint);
    }

    // Draw web circles
    for (int r = 1; r <= 3; r++) {
      final circlePaint = Paint()
        ..color = Colors.grey[300]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(center, radius * r / 3, circlePaint);
    }

    // Draw web polygon
    for (int i = 0; i < categories; i++) {
      final p1 = webPoints[i];
      final p2 = webPoints[(i + 1) % categories];
      canvas.drawLine(p1, p2, webPaint);
    }

    // Draw data - Leyrr
    final leyrPoints = <Offset>[];

    for (int i = 0; i < categories; i++) {
      final angle = 2 * math.pi * i / categories - math.pi / 2;
      final value = data[i]['Leyrr'] as int;
      final point = Offset(
        center.dx + radius * (value / 100) * math.cos(angle),
        center.dy + radius * (value / 100) * math.sin(angle),
      );
      leyrPoints.add(point);
    }

    final leyrPath = Path()..addPolygon(leyrPoints, true);
    final leyrPaint = Paint()
      ..color = Colors.green[600]!.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(leyrPath, leyrPaint);

    final leyrStrokePaint = Paint()
      ..color = Colors.green[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(leyrPath, leyrStrokePaint);

    // Draw data - Competitors
    final compPoints = <Offset>[];

    for (int i = 0; i < categories; i++) {
      final angle = 2 * math.pi * i / categories - math.pi / 2;
      final value = data[i]['Competitors'] as int;
      final point = Offset(
        center.dx + radius * (value / 100) * math.cos(angle),
        center.dy + radius * (value / 100) * math.sin(angle),
      );
      compPoints.add(point);
    }

    final compPath = Path()..addPolygon(compPoints, true);
    final compPaint = Paint()
      ..color = Colors.orange[600]!.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(compPath, compPaint);

    final compStrokePaint = Paint()
      ..color = Colors.orange[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(compPath, compStrokePaint);

    // Draw dots on data points
    for (final point in leyrPoints) {
      final dotPaint = Paint()
        ..color = Colors.green[600]!
        ..style = PaintingStyle.fill;

      canvas.drawCircle(point, 4, dotPaint);
    }

    for (final point in compPoints) {
      final dotPaint = Paint()
        ..color = Colors.orange[600]!
        ..style = PaintingStyle.fill;

      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
