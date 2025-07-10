# Poupix

**Poupix** is a simple and modern personal expense tracker built with Flutter and Supabase.  
It follows the MVVM architecture pattern, uses the command/result pattern, and implements local caching via SharedPreferences for performance.

![Poupix Thumb](poupix_thumb.jpeg)

## Features

- 📊 Track personal expenses with categorized data
- 🗓 Filter expenses by month
- 🔐 Authentication with Supabase
- ☁️ Remote data via RPCs (Stored Procedures)
- 💾 Local caching to improve load times
- 🧱 MVVM architecture (Model-View-ViewModel)
- 🔁 Command & Result pattern for clean state management

## Tech Stack

- [Flutter](https://flutter.dev/)
- [Supabase](https://supabase.com/)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [GoRouter](https://pub.dev/packages/go_router)

## Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/poupix.git
   cd poupix
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file and add your Supabase keys:
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   ```
⚠️ Make sure the .env file is located in the assets directory and is correctly listed in your pubspec.yaml to be accessible at runtime.

4. Run the app:
   ```bash
   flutter run
   ```

## Folder Structure

```
lib/
├── app_state/         # Global state and caching
├── data/              # Repositories and services
├── domain/            # Models and core entities
├── ui/                # Views, widgets and ViewModels
├── utils/             # Commands, results, helpers
```

## Purpose

This project was created for educational purposes to explore clean architecture in Flutter. While simple, it serves as a solid foundation for MVPs and small real-world apps, with the potential to scale into more robust applications.

## Author

Developed by [Samir Pegado Gomes](https://github.com/samirpegado)
