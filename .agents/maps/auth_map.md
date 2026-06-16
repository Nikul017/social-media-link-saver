# Feature Map — Authentication Feature

## Purpose

Secures user access, manages session lifecycle, and handles initial application routing checks.

---

## Depends On

* **GoRouter Navigation (`app_router`)**
* **Riverpod State Manager (`flutter_riverpod`)**
* **Local Storage / Secure Storage (`flutter_secure_storage` or shared preferences)**

---

## Current Scope (MVP)

Currently, the application operates as an offline-first client. Authentication has a placeholder structure:
1. **`SplashPage` (`lib/features/auth/presentation/pages/splash_page.dart`)**:
   * Initial launch routing destination.
   * Performs basic configuration initialization checks.
   * Redirects users to the Main Dashboard `/home` page.
   * Prevents premature interception of share intent URLs during cold starts.

---

## Future authentication integration

Future updates will introduce cloud syncing auth:
* **Proposed Providers**: Supabase Auth or Firebase Auth.
* **Authentication Options**:
  * Email and OTP (One-Time Password)
  * Google Sign-In
  * Apple Sign-In
* **Securing Credentials**: Store access tokens and session IDs locally using `flutter_secure_storage`.
* **State Flow**:
  * `authProvider` (watches AuthState stream: Unauthenticated, Authenticated, Loading).
  * Navigation guards in GoRouter redirecting unauthenticated users to `/login`.
