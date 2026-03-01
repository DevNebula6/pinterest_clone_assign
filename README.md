# Pinterest Clone - Flutter Assignment

A pixel-perfect Pinterest clone built with Flutter that closely replicates the real Pinterest Android/iOS app. The app covers : authentication, onboarding, home feed, search, pin detail, profile, saved boards, and settings - all wired up with clean architecture, Riverpod state management, GoRouter navigation, and Clerk authentication.

---

## Download APK

> **[Download latest release APK](https://drive.google.com/file/d/1rkDO7Xh_t7uA0Pn8u-gtqR4zZfeCnA5b/view?usp=drive_link)**
>
> Built with `flutter build apk --release`. Install on any Android device (enable "Install from unknown sources" if prompted).

---

## Table of Contents

1. [Screens and Features](#screens-and-features)
2. [App Flow](#app-flow)
3. [Architecture](#architecture)
4. [Folder Structure](#folder-structure)
5. [State Management](#state-management)
6. [Navigation and Routing](#navigation-and-routing)
7. [Authentication](#authentication)
8. [Data Layer](#data-layer)
9. [Tech Stack](#tech-stack)
10. [Getting Started](#getting-started)
11. [iOS and Android Compatibility](#ios-and-android-compatibility)
12. [Design Decisions](#design-decisions)

---

## Screens and Features

### Auth Screens

| Screen | Route | Description |
|---|---|---|
| Login Landing | `/login` | Animated entry screen with Continue with Google + email button |
| Password Login | `/password-login` | Email + password form, shows/hides password, error handling |
| Sign Up | `/signup` | Email + password registration with Clerk |

### Onboarding

| Screen | Route | Description |
|---|---|---|
| Onboarding | `/onboarding` | Multi-step interest selector (12 categories), persisted to SharedPreferences |

### Main App

| Screen | Route | Description |
|---|---|---|
| Home Feed | `/home` | Infinite-scroll 2-column masonry grid via Pexels API |
| Search | `/search` | Category chips + search bar, results grid, keyboard dismiss |
| Pin Detail | `/pin/:id` | Full-screen image, description, user info, related pins |
| Profile | `/profile` | User stats, pin grid, avatar with Clerk data |
| Saved | `/saved` | Grid of saved/liked pins pulled from local notifier |
| Boards | `/boards` | Board list view with pin count per board |
| Account | `/account` | Your Account page with Clerk profile editing |

---

## App Flow

```
App Start
    |
    v
ClerkAuth checks session
    |
    +-- No session --> /login --> /password-login or /signup
    |                                   |
    |                             Clerk auth success
    |                                   |
    +-- Has session --------------------+
    |
    v
Onboarding check (SharedPreferences)
    |
    +-- Never completed --> /onboarding --> saves flag --> /home
    |
    +-- Already done --> /home
                            |
                     Main shell (bottom nav)
                     /home | /search | /saved | /profile
```

---

## Architecture

The app follows a clean 3-layer architecture:

```
+---------------------------+
|     Presentation Layer    |  Views, Widgets, Providers (Riverpod)
+---------------------------+
|      Domain Layer         |  Models, Repository interfaces
+---------------------------+
|       Data Layer          |  API clients, local storage, repo implementations
+---------------------------+
```

Data flows like this for the home feed:

1. `HomeFeedNotifier` calls `PinRepository.fetchPins(page)`
2. `PinRepositoryImpl` calls `PexelsApiClient.searchPhotos()`
3. API response gets mapped to `Pin` model objects
4. Notifier state updates to `AsyncValue<List<Pin>>`
5. `MasonryFeedWidget` rebuilds via `ref.watch(homeFeedProvider)`

---

## Folder Structure

```
lib/
 main.dart                    # Entry point, ProviderScope
 app.dart                     # MaterialApp.router, theme, scroll behavior
 data/
    api/
       pexels_api_client.dart    # HTTP client, Pexels endpoints
    repositories/
       pin_repository_impl.dart  # Concrete repo, maps API -> models
    local/
        preferences_service.dart  # SharedPreferences wrapper
 domain/
    models/
       pin.dart                  # Core Pin data model
       board.dart                # Board model
    repositories/
        pin_repository.dart       # Abstract interface
 presentation/
     providers/
        home_feed_provider.dart
        search_provider.dart
        saved_pins_provider.dart
        boards_provider.dart
        auth_provider.dart
     router/
        app_router.dart           # GoRouter config, redirect logic
     views/
         auth/
            login_view.dart
            password_login_view.dart
            signup_view.dart
         onboarding/
            onboarding_view.dart
         home/
            home_view.dart
            widgets/
                masonry_feed.dart
                pin_card.dart
         search/
            search_view.dart
         pin_detail/
            pin_detail_view.dart
         profile/
            profile_view.dart
         saved/
            saved_view.dart
         boards/
            boards_view.dart
         account/
            account_view.dart
         shell/
             main_shell.dart
             widgets/
                 bottom_navigation.dart
```

---

## State Management

Riverpod 2.x is used throughout. Every screen has a dedicated `AsyncNotifier` or `Notifier`.

| Provider | Type | Manages |
|---|---|---|
| `homeFeedProvider` | `AsyncNotifier<List<Pin>>` | Paginated pin list, load-more logic |
| `searchProvider` | `AsyncNotifier<List<Pin>>` | Search results, query debouncing |
| `savedPinsProvider` | `Notifier<List<Pin>>` | Liked/saved pins, toggle logic |
| `boardsProvider` | `Notifier<List<Board>>` | Board list, add pin to board |
| `clerkAuthProvider` | Stream from Clerk SDK | Auth session state |

Example - toggling a saved pin:

```dart
// In saved_pins_provider.dart
void togglePin(Pin pin) {
  final current = state;
  if (current.any((p) => p.id == pin.id)) {
    state = current.where((p) => p.id != pin.id).toList();
  } else {
    state = [...current, pin];
  }
}
```

---

## Navigation and Routing

GoRouter handles all navigation with a centralized redirect guard.

**Route tree:**

```
/login
/password-login
/signup
/onboarding
/shell (ShellRoute - bottom nav host)
    /home
    /search
    /saved
    /profile
/pin/:id         (pushes on top of shell)
/boards
/account
```

**Redirect logic:**

1. Check if Clerk session is loading - show splash if so
2. No session + not on auth route - redirect to `/login`
3. Session exists + on auth route - redirect to `/home`
4. Session exists + onboarding not done - redirect to `/onboarding`
5. All clear - allow navigation

**Page transitions:**

| Transition | Used For |
|---|---|
| Slide from right | Pin detail push |
| Fade | Shell tab switches |
| Default (platform) | Auth screens |

---

## Authentication

Clerk is used for auth via the `clerk_flutter` package. The flow:

```
App launch
    |
    v
ClerkAuth widget initializes
    |
    v
Tries to restore persisted session token
    |
    +-- Token valid --> user object available --> router redirects to /home
    |
    +-- No token / expired --> router redirects to /login
                                    |
                    User taps "Continue with email"
                                    |
                                    v
                            /password-login
                                    |
                        clerk.signIn(email, password)
                                    |
                    +-- Success --> session created --> /home
                    |
                    +-- Error --> show error SnackBar, stay on screen
```

User data (name, email, avatar) is pulled from `clerk.client.activeSession?.user` and displayed in Profile and Account screens.

---

## Data Layer

### Pexels API

| Endpoint | Used For |
|---|---|
| `GET /v1/search?query=nature&per_page=20&page=N` | Home feed pagination |
| `GET /v1/search?query=<term>&per_page=20` | Search results |
| `GET /v1/photos/:id` | Pin detail view |
| `GET /v1/search?query=<category>` | Related pins on detail screen |

The API key is stored in a `.env` file and loaded via `flutter_dotenv`.

### Local Storage (SharedPreferences)

| Key | Type | Purpose |
|---|---|---|
| `onboarding_complete` | bool | Whether user has finished onboarding |
| `selected_interests` | List<String> | Chosen interest categories |
| `saved_pins` | String (JSON) | Persisted saved/liked pins |

---

## Tech Stack

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^2.5.1 | State management |
| `go_router` | ^14.2.0 | Declarative navigation |
| `clerk_flutter` | 0.0.14-beta | Authentication |
| `http` | ^1.2.2 | HTTP requests to Pexels |
| `cached_network_image` | ^3.4.1 | Image caching and loading |
| `flutter_staggered_grid_view` | ^0.7.0 | Masonry/Pinterest-style grid |
| `flutter_dotenv` | ^5.2.1 | .env config loading |
| `shared_preferences` | ^2.3.3 | Local persistence |
| `flutter_svg` | ^2.0.10+1 | SVG icon rendering |
| `lottie` | ^3.2.0 | Animated loading/empty states |
| `shimmer` | ^3.0.0 | Skeleton loading placeholders |
| `google_fonts` | ^6.2.1 | Typography |
| `fpdart` | ^1.1.0 | Functional Either type for errors |
| `intl` | ^0.19.0 | Date formatting |

---

## Getting Started

### Prerequisites

- Flutter SDK 3.6.2 or later
- Dart SDK 3.x
- A Pexels API key (free at pexels.com/api)
- A Clerk account and publishable key (clerk.com)

### Setup

1. Clone the repo and install dependencies:

```bash
flutter pub get
```

2. Create a `.env` file in the project root:

```
PEXELS_API_KEY=your_pexels_key_here
CLERK_PUBLISHABLE_KEY=your_clerk_publishable_key_here
```

3. Run the app:

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# With a specific device
flutter run -d <device-id>
```

4. Check for issues:

```bash
flutter analyze
```

---

## iOS and Android Compatibility

| Feature | iOS | Android |
|---|---|---|
| Scroll physics | BouncingScrollPhysics | ClampingScrollPhysics |
| Keyboard handling | resizeToAvoidBottomInset + GestureDetector dismiss | Same |
| Orientation | Portrait only | Portrait only |
| Network security | NSAppTransportSecurity configured | cleartext via network_security_config |
| Text fields | autocorrect off, suggestions off | Same |
| Minimum frame rate | CADisableMinimumFrameDurationOnPhone: true | N/A |
| Safe area | SafeArea widgets throughout | Same |

---

## Design Decisions

**Why Riverpod over BLoC or Provider?**
Riverpod removes the BuildContext dependency for state access, makes testing easier (override providers in tests), and the `AsyncNotifier` pattern fits perfectly for API-driven screens with loading/error/data states.

**Why GoRouter?**
GoRouter is the Flutter team recommended solution and has first-class support for ShellRoutes (needed for the persistent bottom nav bar) and redirect guards (needed for the auth flow). Deep linking also works out of the box.

**Why fpdart Either for errors?**
Rather than try/catch scattered everywhere, repository methods return `Either<AppError, T>`. Callers use `result.fold(onLeft: handleError, onRight: useData)`. This makes error paths explicit and impossible to accidentally ignore.

**Why 2-step login (landing + password screen)?**
This mirrors exactly how the real Pinterest app works - the landing screen lets you choose Google or email without committing to a form, keeping the entry experience clean.

**Why a floating blur bottom bar?**
The real Pinterest app uses a translucent bottom navigation bar that floats over the content. The `ClipRRect` + `BackdropFilter` approach replicates this exactly and lets the masonry grid scroll all the way to the bottom edge.

---

*Built as a Flutter assignment. 12 screens, clean architecture, real Pexels photos, Clerk auth.*
