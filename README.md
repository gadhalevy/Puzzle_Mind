# Puzzle Mind Flutter App

A Flutter implementation of the Puzzle Mind interactive games platform.

## Setup Instructions

1. Make sure you have Flutter installed on your system. If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

2. Create an `assets/images` directory in your project root and add the following images:
   - mankhe.png
   - hanaa.png
   - havaia.png
   - haham.png
   - higayon.png
   - mi.png
   - place.png

3. Update the email credentials in `lib/main.dart` with your Gmail account details. For security, it's recommended to use environment variables or secure storage for sensitive information.

4. Run the following commands:
   ```bash
   flutter pub get
   flutter run
   ```

## Features

- Beautiful, responsive UI with RTL support for Hebrew
- Email subscription functionality
- Interactive game selection and description
- Feature showcase with animations
- Background image and custom styling

## Security Note

Make sure to properly secure your email credentials and never commit them directly in the code. Consider using environment variables or secure storage solutions in production.
