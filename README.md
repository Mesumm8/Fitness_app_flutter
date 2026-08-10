
# 🏋️‍♂️ Fitness Tracker App

A Flutter application designed to track custom workouts, log completed exercises, and visualize consistency over time using a commit-style activity heatmap. Built with state management powered by `Provider` and local data persistence via `Hive`.

---

## ✨ Features

- **Workout Creation:** Add custom workout categories (e.g., Upper Body, Lower Body, Cardio).
- **Exercise Tracking:** Add specific exercises to each workout with defined weight, reps, and sets.
- **Interactive Checklists:** Check off completed exercises in real-time.
- **Activity HeatMap:** Track daily workout consistency through a visual calendar heatmap.
- **Offline Persistence:** All workouts, exercises, and completion records are saved locally using Hive fast key-value storage.

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **State Management:** [`provider`](https://pub.dev/packages/provider)
- **Local Database:** [`hive`](https://pub.dev/packages/hive) & [`hive_flutter`](https://pub.dev/packages/hive_flutter)
- **Visualization:** [`flutter_heatmap_calendar`](https://pub.dev/packages/flutter_heatmap_calendar)

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
- Android Studio / VS Code with Flutter & Dart extensions
- An active Android/iOS emulator or connected physical device

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/fitness_app_flutter.git](https://github.com/your-username/fitness_app_flutter.git)
   cd fitness_app_flutter

```

2. **Install dependencies:**
```bash
flutter pub get

```


3. **Run the application:**
```bash
flutter run

```



---

## 📁 Folder Structure

```text
lib/
├── components/          # Reusable UI widgets (HeatMap, ExerciseTile, etc.)
├── data/                # Hive database handlers and Provider state management
├── datetime/            # Date formatting and helper utilities (YYYYMMDD)
├── models/              # Data models (Workout, Exercise)
├── pages/               # App screen views (HomePage, WorkoutPage)
└── main.dart            # App entry point & Hive box initialization

```

---

## 📱 Workflows

1. **Home Screen:** Displays overall consistency heatmap and existing workouts list.
2. **Add Workout:** Modal dialog allowing instant creation of target routines.
3. **Workout Screen:** Detailed view showing exercises, sets, reps, weight, and check-off completion states.


