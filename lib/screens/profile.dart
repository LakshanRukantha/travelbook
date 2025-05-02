import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileName = "Lakshan Rukantha";
  String profileEmail = "rukanthalakshan@gmail.com";
  String profileImage =
      "assets/images/developers/user.webp"; // Default profile image

  int postsCount = 3;
  int followersCount = 223;
  int followingCount = 546;

  List<Map<String, String>> posts = [
    {
      "text": "Take only memories, leave only footprints",
      "likes": "120",
      "time": "6h ago",
      "image": "assets/images/posts/travel.webp"
    },
    {
      "text": "Travel is the only thing you buy that makes you richer",
      "likes": "145",
      "time": "3h ago",
      "image": "assets/images/posts/travel1.webp"
    },
    {
      "text": "Life is a journey, not a destination",
      "likes": "210",
      "time": "1d ago",
      "image": "assets/images/posts/travel2.webp"
    },
  ];

  void _editProfile() {
    TextEditingController nameController =
        TextEditingController(text: profileName);
    TextEditingController emailController =
        TextEditingController(text: profileEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  profileName = nameController.text;
                  profileEmail = emailController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _changeProfilePicture() {
    List<String> profileImages = [
      "assets/images/posts/travel.webp",
      "assets/images/posts/travel1.webp",
      "assets/images/posts/travel2.webp"
    ]; // Add more images if needed

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: profileImages.map((image) {
              return ListTile(
                leading: Image.asset(image,
                    width: 50, height: 50, fit: BoxFit.cover),
                title: Text(image.split('/').last),
                onTap: () {
                  setState(() {
                    profileImage = "assets/images/developers/user.webp";
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _addPost() {
    TextEditingController postController = TextEditingController();
    String selectedImage = "assets/post1.jpg"; // Default post image

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: postController,
                decoration: InputDecoration(labelText: "Enter your post"),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedImage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedImage = newValue!;
                  });
                },
                items: [
                  "assets/images/posts/travel.webp",
                  "assets/images/posts/travel1.webp",
                  "assets/images/posts/travel2.webp"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.split("/").last),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (postController.text.isNotEmpty) {
                  setState(() {
                    posts.add({
                      "text": postController.text,
                      "likes": "0",
                      "time": "Just now",
                      "image": selectedImage
                    });
                    postsCount++;
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Post"),
            ),
          ],
        );
      },
    );
  }

  void _updateFollowers() {
    setState(() {
      followersCount++;
    });
  }

  void _updateFollowing() {
    setState(() {
      followingCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: _changeProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profileImage),
              ),
            ),
            SizedBox(height: 10),
            Text(
              profileName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(profileEmail, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.pushNamed("edit_profile");
              },
              child: Text("Edit Profile"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                profileStat(postsCount.toString(), "Posts"),
                profileStat(
                    followersCount.toString(), "Followers", _updateFollowers),
                profileStat(
                    followingCount.toString(), "Following", _updateFollowing),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _addPost,
              icon: Icon(Icons.add),
              label: Text("Add Post"),
            ),
            SizedBox(height: 10),
            Column(
              children: posts
                  .map((post) => postItem(post["text"]!, post["likes"]!,
                      post["time"]!, post["image"]!))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileStat(String count, String label, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(count,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget postItem(String text, String likes, String time, String image) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(text),
        subtitle: Text("$time  •  $likes Likes"),
      ),
    );
  }
}
