import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  Map<String, dynamic>? user;
  final _captionController = TextEditingController();
  final _locationController = TextEditingController();
  final _picker = ImagePicker();

  File? _image;
  bool _isUploading = false;

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;
    final uid = currentUser.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data();
    }
    return null;
  }

  void fetchUserData() async {
    Map<String, dynamic>? userData = await getCurrentUser();

    if (mounted && userData != null) {
      setState(() {
        user = userData;
        print("user ${user}");
      });
    } else {
      context.push("/login");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showSnackbar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.redAccent,
      ),
    );
  }

  Future<void> _uploadPost() async {
    final caption = _captionController.text.trim();
    final location = _locationController.text.trim();
    final email = FirebaseAuth.instance.currentUser?.email;

    if (_image == null || caption.isEmpty || location.isEmpty) {
      _showSnackbar("Please select an image and fill all the fields.");
      return;
    }

    setState(() => _isUploading = true);

    try {
      final postId = const Uuid().v4();

      final ref =
          FirebaseStorage.instance.ref().child('posts').child('$postId.jpg');

      await ref.putFile(_image!);
      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('posts').doc(postId).set({
        'caption': caption,
        'location': location,
        'image': imageUrl,
        'liked_users': [],
        'likes': 0,
        'posted_by': email,
        'time': FieldValue.serverTimestamp(),
      });

      _showSnackbar("Post uploaded successfully!", color: Colors.green);
      context.pop();
    } catch (e) {
      _showSnackbar("Failed to upload post. Please try again.");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Post",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Posting as ${user?['name'] ?? "Anonymous User"}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.black12),
                  ),
                  child: _image == null
                      ? const Center(
                          child: Icon(Icons.add_a_photo,
                              size: 40, color: Colors.grey),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _captionController,
              hint: "Add a caption...",
              icon: Icons.short_text,
            ),
            const SizedBox(height: 10),
            _buildInputField(
              controller: _locationController,
              hint: "Add location",
              icon: Icons.location_on,
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: _isUploading ? null : () => context.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red), // red border
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: _isUploading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.upload, color: Colors.white),
                    label: Text(
                      _isUploading ? "Uploading..." : "Share",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: _isUploading ? null : _uploadPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey, // You can customize the border color here
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
      ),
      textInputAction: TextInputAction.done,
    );
  }
}
