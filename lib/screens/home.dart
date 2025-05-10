import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> posts = [
    {
      "name": "Lakshan Rukantha",
      "image":
          "https://media.istockphoto.com/id/1288609237/photo/spectacular-view-of-the-lion-rock-surrounded-by-green-rich-vegetation-picture-taken-from.jpg?s=612x612&w=0&k=20&c=Rkmk3T6SxqzMPyIOcSkeTLrMlb6aHo3gaQpqCrxBeZM=",
      "location": "Anuradhapura town and this is long text",
      "likes": 100,
      "caption":
          "This is a caption and long paragraph to test the text overflow in the card and this is long text"
    },
    {
      "name": "Jane Smith",
      "image":
          "https://thesunrisedreamers.com/wp-content/uploads/2022/03/Famous-sri-lanka-train.webp",
      "location": "Kandy",
      "likes": 154,
      "caption": "This is another caption"
    },
    {
      "name": "Alice Johnson",
      "image":
          "https://media.istockphoto.com/id/1288609237/photo/spectacular-view-of-the-lion-rock-surrounded-by-green-rich-vegetation-picture-taken-from.jpg?s=612x612&w=0&k=20&c=Rkmk3T6SxqzMPyIOcSkeTLrMlb6aHo3gaQpqCrxBeZM=",
      "location": "Colombo",
      "likes": 86,
      "caption": "This is yet another caption"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Travel Book",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
                print("Notification button pressed");
              },
            ),
          ],
          backgroundColor: Colors.blue,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "Lakshan!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                )),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                posts[index]["name"]!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                              const Text(
                                " is at ",
                                style: TextStyle(fontSize: 16),
                              ),
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.red,
                              ),
                              Flexible(
                                child: Text(
                                  " ${posts[index]["location"]!}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Image.network(posts[index]["image"]!),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 14),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${posts[index]["likes"]}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.favorite_border),
                                          color: Colors.white,
                                          onPressed: () {
                                            // Handle like action here
                                          },
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(posts[index]["caption"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
