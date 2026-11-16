# Vindora Customer Flutter App — Phase 1 scaffold

This is the initial Flutter source scaffold for the customer-only Vindora app.

## Requirements

- Flutter stable (Dart SDK >= 3.3)
- Android Studio / Android SDK for Android builds
- Xcode on macOS for iOS builds

## Run locally

1. Install Flutter and verify with `flutter doctor`.
2. Run `flutter pub get`.
3. Run `flutter run` on an emulator or device.

## Current state

- Arabic RTL app shell and Vindora navy/purple theme.
- Login screen UI and secure token storage integration.
- API client configured for `https://vindora.whf.bz/backend/mobile_api.php`.
- Basic product-grid screen wired to the proposed `products` API response.
- Backend API implementation is not deployed yet. Login and protected mobile actions will not work until the PHP mobile API is implemented and deployed.

## Important

The PHP archive uses PHP sessions today. A dedicated bearer-token API is required for Flutter. Do not put database credentials or server secrets in this Flutter project. Review `backend_notes/phase_1_findings_and_api_contract.md` and `backend_notes/mobile_app_migration_proposal.sql` before any production backend changes.
