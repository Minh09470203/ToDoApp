# ToDoList - Flutter App

A simple ToDoList app built with Flutter that lets you add, edit, delete, and mark tasks as completed. Data is stored locally using `shared_preferences`. The UI supports light/dark themes and shows task details in a modal bottom sheet.

## Main features
- Add tasks with a name and an optional deadline.
- Edit task names.
- Delete tasks (with confirmation).
- Mark/unmark tasks as completed.
- Swipe-to-delete (Dismissible) with confirmation.
- View task details in a modal bottom sheet.
- Light/Dark theme toggle.
- Simple local storage with `shared_preferences`.

## Requirements
- Flutter (stable channel) installed.
- Dart (comes with Flutter).
- An emulator or a physical device to run the app.

## Packages used
- shared_preferences
- google_fonts
- (and Flutter's built-in packages)

Make sure to add these packages to the `dependencies` section of `pubspec.yaml` if they are not already present.

## Install & run
1. Clone or download the repository:
   - git clone <repo-url>

2. Change to the project directory:
   - cd <project-folder>

3. Get dependencies:
   - flutter pub get

4. Run the app:
   - flutter run

Or build an APK:
   - flutter build apk --release

## License
- MIT license
