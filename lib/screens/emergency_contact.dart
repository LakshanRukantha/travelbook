import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactPage extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {'name': 'Police Emergency', 'number': '119'},
    {'name': 'Ambulance / Medical Emergency', 'number': '1990'},
    {'name': 'Fire & Rescue Services', 'number': '110'},
    {'name': 'Tourist Police (Colombo HQ)', 'number': '+94112421052'},
    {'name': 'Tourist Police Hotline (24/7)', 'number': '1912'},
    {'name': 'General Police HQ (Colombo)', 'number': '+94112421111'},
    {'name': 'Roadside Emergency (RDA)', 'number': '1969'},
    {'name': 'Airport Information – BIA', 'number': '+94112252861'},
    {'name': 'Sri Lanka Railways Information', 'number': '1913'},
    {'name': 'Sri Lanka Transport Board (SLTB)', 'number': '1955'},
    {'name': 'National Hospital (Colombo)', 'number': '+94112691111'},
    {'name': 'Disaster Management Centre', 'number': '117'},
    {'name': 'Tourism Hotline (Sri Lanka Tourism)', 'number': '1912'},
  ];

  EmergencyContactPage({super.key});

  Future<void> _callNumber(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      debugPrint('Could not launch $number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Contacts',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Tap a contact below to call emergency services immediately.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.phone, color: Colors.redAccent),
                    title: Text(contact['name']!),
                    subtitle: Text(contact['number']!),
                    onTap: () => _callNumber(contact['number']!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
