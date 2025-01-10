# energy_app

A demo Flutter project which fetch data (energy generation/ consumption) from backend-api for monitoring. 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Configuration 

Change `API_ENDPOINT` in `lib/api/api.dart` to correct local endpoint of backend.



## Run App

`flutter pub get` to download all dependencies

`flutter run` then select physical device or Android emulator/iOS Simulator for debug mode

`flutter run --release` for release mode

## Build App

`flutter build apk --release` to build apk for running on android devices

`flutter build ios` to build .app for ios devices

## Structure

`api` folder contains api-related class, models and functions
`presentation` and `widget` folders contain UI components, pages
`providers` folder contains providers for state management and handling data
`routing` folder contains router between pages
`utils` folder contains helper functions
`test` folder contains unittest

## Tradeoffs

Due to short time and no specific design, most components and color scheme are default or from shared-packages. The structure of the app follows provider pattern because of simple implementation and providing clean code.
