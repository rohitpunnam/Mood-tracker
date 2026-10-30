# Mood Tracker 😊

A simple, calming mood-tracking application built with Flutter. Mood Tracker helps users check in with their feelings, optionally add a note, review previous mood entries, and view a breakdown of their mood history.

## Screenshots

 1. Log Mood

Choose how you feel today, add an optional note, and save your mood entry. The screen also displays a motivational quote.

![Mood Tracker - Log screen](screenshots/mood-log.png)

2. Mood History

Review previously saved mood entries, including the mood and the date and time each entry was logged.

![Mood Tracker - History screen](screenshots/mood-history.png)

 3. Mood Statistics

View your average mood, total logged entries, and the breakdown across five mood levels.

![Mood Tracker - Stats screen](screenshots/mood-stats.png)

 4. Dark Mode Support

Mood Tracker supports both Light Mode and Dark Mode, allowing users to choose their preferred appearance.

- **Light Mode:** Provides a clean and comfortable interface for daytime use.
- **Dark Mode:** Offers a darker interface for comfortable viewing in low-light environments.
- **Easy Switching:** Users can switch between Light and Dark Mode using the theme toggle icon in the app bar.
- **Dynamic Theme:** The theme automatically updates across the Log, History, and Stats screens.

**Dark Mode Preview**

![Mood Tracker Dark Mode](screenshots/mood-dark-mode.png)

 Features

- **Daily mood check-in:** Select one of five mood levels:
  - 😭 Awful
  - 🙁 Bad
  - 😐 Okay
  - 🙂 Good
  - 😄 Great
- **Optional notes:** Add a short note of up to 200 characters to a mood entry.
- **Mood history:** Browse logged mood entries with their date and time.
- **Mood statistics:** See the average mood, total number of entries, and a mood-by-mood breakdown.
- **Motivational quote:** View an inspirational quote on the Log screen.
- **Bottom navigation:** Switch between Log, History, and Stats.
- **Light and Dark Mode:** Switch between two appearance modes.
- **Simple interface:** A clean design with a calm green/teal colour palette.

 Built With

- **Flutter** – UI toolkit for building cross-platform applications.
- **Dart** – Programming language used by Flutter.

Getting Started

 Prerequisites

Install the following before running the project:

- Flutter SDK
- Dart SDK (included with Flutter)
- An editor such as Visual Studio Code or Android Studio
- A browser or emulator/device supported by Flutter

 Installation

**1. Clone this repository:**

```bash
git clone https://github.com/rohitpunnam/Mood-tracker.git
```

**2. Move into the project directory:**

```bash
cd Mood-tracker
```

**3. Install dependencies:**

```bash
flutter pub get
```

**4. Run the application:**

```bash
flutter run
```

To run it in Chrome, if web support is enabled:

```bash
flutter run -d chrome
```

How to Use

1. Open the Log screen.
2. Select the mood that best describes how you feel.
3. Optionally enter a note.
4. Tap **Save Mood**.
5. Open History to review logged entries.
6. Open Stats to view your average mood and mood breakdown.
7. Use the theme toggle to switch between Light and Dark Mode.

 Project Structure

```text
Mood-tracker/
├── lib/              # Application source code
├── test/             # Automated tests
├── web/              # Web platform files
├── windows/          # Windows platform files
├── pubspec.yaml      # Project metadata and dependencies
└── README.md         # Project documentation
```

Your actual project may contain additional folders and files.

Current Scope

The application currently supports mood logging, optional notes, mood history, mood statistics, motivational quotes, bottom navigation, and Light/Dark Mode.

Data persistence, authentication, and cloud synchronisation are not specified here because they are not confirmed as implemented features.

 Future Improvements

Possible enhancements include:

- Mood trends over longer periods
- Calendar-based mood history
- Exporting mood entries
- Optional reminders to check in
- Data backup and synchronisation

 License

No license has been specified yet. Add a license if you want to define how others may use, modify, and distribute this project.