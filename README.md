# TravelBook

**TravelBook** is a modern Flutter application designed to help users explore destinations, track locations, chat with AI Agent, and enjoy a smart, interactive travel experience. It integrates Firebase, Google Maps, AI, and more to offer a powerful travel companion right in your pocket.

## ✨ Features

- 🔐 Firebase Authentication for secure sign-in/sign-up
- 📍 Google Maps integration with real-time location tracking
- 🗺️ Route drawing using Polylines
- 📸 Post and explore travel experiences with images
- 🤖 AI assistant powered by Gemini
- 📦 Cloud Firestore and Firebase Storage for data and media
- 📸 Image Picker for uploading travel memories

## 📦 Dependencies

The project uses the following major Flutter packages:

| Package                   | Description                     |
| ------------------------- | ------------------------------- |
| `firebase_core`           | Firebase core services          |
| `firebase_auth`           | Authentication features         |
| `cloud_firestore`         | NoSQL cloud database            |
| `firebase_storage`        | Upload and retrieve files       |
| `google_maps_flutter`     | Maps and location pins          |
| `location`                | Access device location          |
| `flutter_polyline_points` | Draw travel paths               |
| `dash_chat_2`             | Customizable chat UI            |
| `flutter_gemini`          | Google Gemini AI integration    |
| `image_picker`            | Pick images from camera/gallery |
| `go_router`               | Navigation and routing          |
| `flutter_dotenv`          | Load environment variables      |
| `curved_navigation_bar`   | Stylish bottom navigation       |
| `geolocator`, `geocoding` | Location utilities              |

## 📂 Project Structure

```
lib/
├── main.dart
├── screens/
├── widgets/
├── models/
├── services/
assets/
└── images/
├── logo.webp
├── travel_buddy.png
├── posts/
└── sign/
.env
```

## 🔧 Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/LakshanRukantha/travelbook.git
   ```

   ```bash
   cd travelbook
   ```

2. Set up environment variables:

   Rename `.env.example` file into `.env` and add your API keys:

   ```env
   GEMINI_API_KEY =
   GOOGLE_MAPS_API_KEY=
   ```

3. Install dependencies:

   flutter pub get

4. Run the app:

   flutter run

## 🚀 Deployment

To build the app:

flutter build apk # Android  
 flutter build ios # iOS

## 🧪 Testing

flutter test

## 📄 License

Made with ❤️ using Flutter
