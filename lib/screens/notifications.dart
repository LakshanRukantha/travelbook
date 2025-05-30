import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, String>> notifications = [
    {
      "type": "follow",
      "user": "Nimal Perera",
      "message": "started following you",
      "time": "2h ago",
    },
    {
      "type": "follow",
      "user": "Kumari Jayasinghe",
      "message": "started following you",
      "time": "5h ago",
    },
    {
      "type": "post",
      "user": "Santha Fernando",
      "message": "posted a new update",
      "time": "1d ago",
    },
    {
      "type": "post",
      "user": "Chamara Silva",
      "message": "posted a new photo",
      "time": "3d ago",
    },
    {
      "type": "follow",
      "user": "Lakshan Rukantha",
      "message": "started following you",
      "time": "4d ago",
    },
    {
      "type": "post",
      "user": "Dilani Perera",
      "message": "posted a new blog",
      "time": "6d ago",
    },
    {
      "type": "follow",
      "user": "Keshan Rajapaksa",
      "message": "started following you",
      "time": "1w ago",
    },
    {
      "type": "post",
      "user": "Nadeesha Silva",
      "message": "posted a new photo",
      "time": "2w ago",
    },
  ];

  IconData _iconForType(String type) {
    switch (type) {
      case 'follow':
        return Icons.person_add;
      case 'post':
        return Icons.new_releases;
      default:
        return Icons.notifications;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'follow':
        return Colors.green;
      case 'post':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: notifications.isEmpty
          ? Center(child: Text('No notifications'))
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _colorForType(notif['type']!),
                    child: Icon(
                      _iconForType(notif['type']!),
                      color: Colors.white,
                    ),
                  ),
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: notif['user'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " ${notif['message']}"),
                      ],
                    ),
                  ),
                  subtitle: Text(notif['time']!),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        notifications.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Notification from ${notif['user']} dismissed')),
                      );
                    },
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Tapped on notification from ${notif['user']}')),
                    );
                  },
                );
              },
            ),
    );
  }
}
