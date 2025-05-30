import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String userImage = "";
  final defaultImage = "assets/images/developers/user_default.png";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> fetchUserProfile() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        final data = doc.data();
        setState(() {
          userImage = data?['userImage'] ?? "";
          nameController.text = data?['name'] ?? "";
          emailController.text = currentUser.email ?? "";
          bioController.text = data?['bio'] ?? "";
          locationController.text = data?['location'] ?? "";
        });
      }
    } catch (e) {
      print("Failed to fetch profile data: $e");
    }
  }

  Future<void> saveProfileChanges() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'bio': bioController.text.trim(),
          'location': locationController.text.trim(),
          // optionally, update 'name' here if you want it editable
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
        context.pop(); // Return to profile page
      }
    } catch (e) {
      print("Error saving profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save changes")),
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      File imageFile = File(pickedFile.path);
      String fileName = 'profile_${currentUser.uid}.jpg';

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName);

      await ref.putFile(imageFile);

      String downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'userImage': downloadUrl});

      setState(() {
        userImage = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile picture updated")),
      );
    } catch (e) {
      print("Failed to upload profile image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile picture")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: userImage.isNotEmpty
                        ? NetworkImage(userImage)
                        : AssetImage(defaultImage) as ImageProvider,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  "Tap to change profile picture",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
              SizedBox(height: 20),
              Text("Name"),
              SizedBox(height: 5),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(border: OutlineInputBorder()),
                readOnly: true, // set to false if you want to allow editing
              ),
              SizedBox(height: 10),
              Text("Email"),
              SizedBox(height: 5),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              SizedBox(height: 10),
              Text("Bio"),
              SizedBox(height: 5),
              TextFormField(
                controller: bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Tell us about yourself",
                ),
              ),
              SizedBox(height: 10),
              Text("Location"),
              SizedBox(height: 5),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: saveProfileChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
