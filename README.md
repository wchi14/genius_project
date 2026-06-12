
## Run Project
# Start the emulator (can take a minute the first time)
flutter emulators --launch genius_pixel --cold

# In another terminal, from your project:
flutter devices          # should list the emulator when booted

flutter pub get
flutter run              # or: flutter run -d emulator-5554


## Create .freezed.dart
dart run build_runner build --delete-conflicting-outputs