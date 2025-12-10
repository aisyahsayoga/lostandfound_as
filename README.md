# Lost & Found (Flutter)

Lost & Found app to report and discover missing items. Supports user reports, marking items as returned to their owners (Resolved), and a concise dashboard with Lost/Found/Resolved stats.

## Features

- Home Dashboard
  - Stats for `Resolved`, `Lost`, `Found`
  - Category filters (All, Electronics, Personal Items, Documents, Apparel)
  - “Recent Items” grid with image, name, location, and status chip (Found/Lost/Resolved)
- My Reports
  - User’s own reports list
  - Check button to mark an item as `Resolved` (card turns green with a “Resolved” badge)
  - Image placeholder when no photo is available
- Reporting
  - Report Lost/Found items page
- Profile
  - Edit Profile, My Reports, and Logout
  - Unused Settings section removed
- Onboarding
  - Shown for Guest users (not logged in). Logged-in users skip onboarding and enter the app directly

## Tech Stack

- Flutter (Dart)
- Appwrite (Account, Databases, Storage)
- SharedPreferences (onboarding flag)

## Requirements

- Flutter SDK and Dart (3.x recommended)
- Android SDK / Xcode as needed
- Active Appwrite project

## Getting Started

```bash
flutter pub get
dart analyze
flutter run
```

Build Android release:

```bash
flutter build apk --release
```

## Appwrite Configuration

The app uses Appwrite for authentication, database, and file storage.

1) Create an Appwrite Project
- Note `endpoint` and `projectId`

2) Database & Collections
- Create one Database with two Collections: `users` and `items`
- `users` (minimum columns):
  - `accountId` (string)
  - `fullname` (string)
  - `email` (string)
  - `createAt` (ISO string)
  - `avatarFileId` (string, optional)
- `items` (minimum columns):
  - `title` (string)
  - `description` (string)
  - `category` (string)
  - `location` (string)
  - `reportDate` (ISO string)
  - `isFound` (boolean)
  - `isResolved` (boolean, default `false`)
  - `imageIds` (array of strings)
  - `reporterId` (string)
  - `createdAt` (ISO string)

3) Storage Bucket
- Create a bucket to store images

4) Permissions & Row Security
- Enable Row Security on the `items` collection
- Default `Read` can be `Any` so the list is visible
- When creating rows, the app sets `Update/Delete` to `User:<reporterId>`
- For legacy rows (created before this rule), add `Update → User:<reporterId>` manually if needed

5) Optional Indexes
- Add indexes for performance, e.g., `isResolved` + `createdAt (DESC)`

6) Provide credentials to the app
- Open `lib/main.dart` and update `AuthService().init(...)` with your Appwrite values:
  - `endpoint`, `projectId`, `databaseId`, `usersCollectionId`, `itemsCollectionId`, `bucketId`

## Onboarding Behavior

- Guest (not logged in): Onboarding is shown at app launch. After “Skip”/“Get Started”, the app is entered
- Logged-in: App opens directly, onboarding is skipped

## Project Structure (brief)

- `lib/main.dart` — app entry point
- `lib/screens/main_wrapper.dart` — bottom tabs + onboarding gate
- `lib/screens/onboarding.dart` — onboarding screen
- `lib/screens/home_dashboard.dart` — dashboard and item grid
- `lib/screens/my_reports_screen.dart` — user reports (resolved button)
- `lib/screens/profile_page.dart` — profile (Edit Profile, My Reports, Logout)
- `lib/screens/lost_item_report.dart` — reporting screen
- `lib/services/auth_service.dart` — Appwrite integration (account, DB, storage)
- `lib/theme/*` — app theme

## Resolved Flow

- In My Reports, tap the check button on items that have been returned
- The app updates `isResolved` to `true`
- The card turns green with a “Resolved” badge, and Home Resolved stats increase
- On Home, items with `isResolved == true` show “Resolved” chip with a green-tinted bottom row

## Troubleshooting

- Error `Unknown attribute: "isResolved" (400)`
  - Add `isResolved` (boolean) column to the `items` collection with default `false`
- Error `403` when tapping check in My Reports
  - Ensure the row has `Update → User:<reporterId>` permission
- Layout overflow (yellow/black stripe)
  - Handled via image height and grid ratio adjustments. If it appears on some devices, tweak `childAspectRatio` or paddings

## License

This project is for educational purposes. Adjust license as needed.
