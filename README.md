# 📰 Newsly - Flutter News App

A modern Flutter application that displays the latest news articles from various categories using the NewsAPI.

## Features

- Browse top headlines from different categories (General, Business, Technology, etc.)
- Search for news articles by keyword
- View detailed article information
- Clean and responsive UI
- Pull-to-refresh functionality

## Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / Xcode (for emulator/simulator)
- NewsAPI API key (get it from [NewsAPI](https://newsapi.org/))

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/0xsreejith/newsly.git
   cd newsly
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Add your NewsAPI key**
   - Open `lib/services/news_service.dart`
   - Replace `'YOUR_NEWSAPI_KEY'` with your actual NewsAPI key

4. **Run the app**
   ```bash
   flutter run
   ```

## Dependencies

- `http`: For making HTTP requests
- `provider`: For state management
- `cached_network_image`: For efficient image loading and caching
- `url_launcher`: For opening article URLs in browser
- `intl`: For date formatting
- `shared_preferences`: For local storage (if needed in the future)

## Folder Structure

```
lib/
  ├── models/         # Data models
  ├── screens/        # App screens
  ├── services/       # API services
  ├── utils/          # Utility classes
  ├── widgets/        # Reusable widgets
  └── main.dart       # Entry point
```

## Contributing

Feel free to submit issues and enhancement requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
