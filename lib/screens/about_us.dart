import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        // Enables vertical scrolling
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/logo.webp",
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
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
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Support Number",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Row(
                children: const [
                  Icon(Icons.phone),
                  SizedBox(width: 10),
                  Text("0763721373", style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Row(
                children: const [
                  Icon(Icons.email),
                  SizedBox(width: 10),
                  Text("contact@travelbook.com",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Developers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDeveloper("Lakshan Rukantha",
                          "assets/images/developers/lakshan.jpg"),
                      _buildDeveloper("Bethmina Sithija",
                          "assets/images/developers/sithija.jpg"),
                      _buildDeveloper("Sandaru Tharaka",
                          "assets/images/developers/sandaru.jpg"),
                      _buildDeveloper("Charith Wijesinghe",
                          "assets/images/developers/charith.jpg"),
                      _buildDeveloper("Hiruni Prarthana",
                          "assets/images/developers/hiruni.jpg"),
                      _buildDeveloper("Vidumini Prabodya",
                          "assets/images/developers/vidumini.jpg"),
                      _buildDeveloper("Meedum Shanika",
                          "assets/images/developers/meedum.jpg"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "v1.0.0-alpha",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloper(String name, String image) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: ClipOval(
              child: Image.asset(
                image,
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
