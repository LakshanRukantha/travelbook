import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Privacy Policy for TravelBook',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Last Updated: 30th May 2025',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              '1. Introduction',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'TravelBook ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application developed with Flutter.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Information We Collect',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'We may collect the following types of information:',
            ),
            Text(
              '- Personal Information: Email address, display name, profile image via Firebase Authentication.\n'
              '- Location Information: Real-time geographic location to show nearby places or route maps.\n'
              '- Uploaded Content: Photos, videos, and other files you choose to share in posts.\n'
              '- Device Information: Device type, OS version, IP address, and app usage data.\n'
              '- Chat & Interaction Data: Messages shared via in-app chat features.',
            ),
            SizedBox(height: 16),
            Text(
              '3. How We Use Your Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'We use the collected information for the following purposes:\n'
              '- To enable user registration and login.\n'
              '- To allow users to share posts and media content.\n'
              '- To provide location-based services and maps.\n'
              '- To improve app functionality and user experience.\n'
              '- To maintain safety, prevent fraud, and enforce our terms.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Permissions We Require',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'To function properly, TravelBook may request access to the following:\n'
              '- Location: For map features and nearby place suggestions.\n'
              '- Camera and Gallery: To capture and upload images.\n'
              '- Storage: To save or upload files.\n'
              '- Internet Access: Required for real-time data syncing and cloud services.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Data Sharing & Third Parties',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'We do not sell your personal data. However, we may share your data with:\n'
              '- Firebase (Authentication, Firestore, Storage)\n'
              '- Google Maps APIs for location services\n'
              '- Hosting or analytics providers that help us operate the app securely and efficiently',
            ),
            SizedBox(height: 16),
            Text(
              '6. Data Security',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'We use industry-standard measures like encryption and secure connections to protect your data. However, please note that no method of transmission over the internet or method of electronic storage is 100% secure.',
            ),
            SizedBox(height: 16),
            Text(
              '7. Children\'s Privacy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'TravelBook is not intended for users under the age of 13. We do not knowingly collect personal information from children under 13.',
            ),
            SizedBox(height: 16),
            Text(
              '8. Your Rights & Choices',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'You can:\n'
              '- Access or update your profile information at any time.\n'
              '- Revoke permissions like location via your device settings.\n'
              '- Request data deletion by contacting us at the address below.',
            ),
            SizedBox(height: 16),
            Text(
              '9. Changes to This Policy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'We may update this Privacy Policy from time to time. Updates will be posted in-app with a new effective date. Continued use of TravelBook after changes means you accept the updated policy.',
            ),
            SizedBox(height: 16),
            Text(
              '10. Contact Us',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'If you have any questions or concerns regarding this Privacy Policy, please contact us at:\n'
              'contact@travelbook.com',
            ),
          ],
        ),
      ),
    );
  }
}
