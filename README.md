
## Run Project
# Start the emulator (can take a minute the first time)
flutter emulators --launch genius_pixel

# In another terminal, from your project:
cd c:\Users\Nick\Documents\project\genius_project
flutter devices          # should list the emulator when booted
flutter pub get
flutter run              # or: flutter run -d emulator-5554


## Create .freezed.dart
dart run build_runner build --delete-conflicting-outputs