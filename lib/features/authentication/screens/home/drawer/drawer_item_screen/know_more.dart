import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KnowMoreScreen extends StatefulWidget {
  const KnowMoreScreen({super.key});

  @override
  State<KnowMoreScreen> createState() => _KnowMoreScreenState();
}

class _KnowMoreScreenState extends State<KnowMoreScreen> {
  final List<Map<String, String>> safetyFeatures = [
    {
      'title': '24x7 Proactive Safety Checks',
      'description': 'We send notifications and follow-up calls for route deviations, unplanned stops, etc.',
      'icon': '⚠️'
    },

    {
      'title': 'SOS Button',
      'description': 'Call our Emergency Response Team for immediate help.',
      'icon': '🚨'
    },
    {
      'title': 'Late Night Ride Completion Check',
      'description': 'We verify your safe arrival during late-night rides.',
      'icon': '🌙'
    },
    {
      'title': 'Live Location Sharing',
      'description': 'Share your live location with family and friends for extra safety.',
      'icon': '📍'
    },
    {
      'title': 'Emergency Contacts',
      'description': 'Add trusted contacts who will be notified in case of emergencies.',
      'icon': '📞'
    },
    {
      'title': 'Speed Alerts',
      'description': 'Get notified if the driver exceeds the safe speed limit.',
      'icon': '⚡'
    },
  ];
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Toolkit'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: safetyFeatures.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onCardTap(context, safetyFeatures[index]['title']!),
            child: Card(
              elevation: 3,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: Text(safetyFeatures[index]['icon']!, style: TextStyle(fontSize: 24)),
                    title: Text(
                      safetyFeatures[index]['title']!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(safetyFeatures[index]['description']!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void _onCardTap(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Clicked on $title')),
    );
  }
}
