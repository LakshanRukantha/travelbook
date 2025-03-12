import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: SingleChildScrollView( // Enables vertical scrolling
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Center(
  child: Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
       // Optional border
    ),
    child: ClipOval(
      child: Image.asset(
        "assets/images/logo.webp",
        height: 80,
        width: 80,
        fit: BoxFit.cover, // Ensures the image fits within the circular shape
      ),
    ),
  ),
),
              const SizedBox(height: 20),
              const Divider(
                height: 2,
                color: Color.fromARGB(137, 2, 1, 1),
                thickness: 2,
              ),
              const SizedBox(height: 10),
              const Text(
                "TravelBook is a mobile app that helps Sri Lankan tourists plan trips, find reliable travel information, and connect with fellow explorers. It's your trusted companion for unforgettable adventures, from seaside getaways to cultural journeys across Sri Lanka.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Support Number",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                children: const [
                  Icon(Icons.phone),
                  SizedBox(width: 10),
                  Text("0763721373", style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                children: const [
                  Icon(Icons.email),
                  SizedBox(width: 10),
                  Text("contact@travelbook.com", style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Developers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),

              // Horizontal scrolling list for developers
              SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDeveloper("Lakshan"),
                      _buildDeveloper("Sithija"),
                      _buildDeveloper("Sandaru"),
                      _buildDeveloper("Charith"),
                      _buildDeveloper("Hiruni"),
                      _buildDeveloper("Vidumini"),
                      _buildDeveloper("Meedum"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloper(String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 10), // Space between items
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/developers/user.webp',
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
