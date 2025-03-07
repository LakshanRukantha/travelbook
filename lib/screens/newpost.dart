import 'package:flutter/material.dart';

class Newpost extends StatefulWidget {
  const Newpost({super.key});

  @override
  State<Newpost> createState() => _NewpostState();
}

class _NewpostState extends State<Newpost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        title: Text(
          "New Post",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add, size: 40, color: Colors.black54),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(height: 20),
          
            TextField(
              decoration: InputDecoration(
                hintText: "Add a Caption",
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Add Location",
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: Size(120, 50),
                  ),
                  onPressed: () {},
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: Size(120, 50),
                  ),
                  onPressed: () {},
                  child: Text("Share"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}