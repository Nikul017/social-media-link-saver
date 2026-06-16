# Codebase Dependencies & Provider Map

This document lists the dependencies between Riverpod state providers, repositories, local databases, services, and external libraries.

---

## State Providers (Riverpod)

### `databaseProvider`
* **Defines**: Drift `AppDatabase` instance.
* **Used by**:
  * Local Datasources
  * Repository implementations
  * Seeders / Importers

---

### `bookmarkRepositoryProvider`
* **Depends on**: `databaseProvider`
* **Used by**:
  * `bookmarksListProvider`
  * `bookmarkStreamProvider`
  * `duplicateBookmarksProvider`
  * `importProvider`
  * `exportProvider`

---

### `bookmarksListProvider`
* **Depends on**: `bookmarkRepositoryProvider`
* **Used by**:
  * `HomePage` (renders bookmark grid)
  * `SearchPage` (searches within lists)

---

### `bookmarkStreamProvider(id)`
* **Depends on**: `bookmarkRepositoryProvider`
* **Used by**:
  * `BookmarkDetailPage` (renders reactive single-bookmark details)

---

### `pendingSharedUrlProvider`
* **Defines**: Stream of URLs captured from native share intents.
* **Used by**:
  * `HomePage` (triggers opening of `AddBookmarkSheet` when URL shared)

---

### `themeNotifierProvider`
* **Defines**: Active application theme setting (light/dark mode).
* **Used by**:
  * `main.dart` (loads MaterialApp themes)
  * `SettingsPage` (toggles theme)

---

### `graphControllerProvider`
* **Depends on**:
  * `bookmarksListProvider`
  * `folderListProvider`
  * `tagListProvider`
* **Used by**:
  * `GraphPage` (calculates layout coordinates and dimensions)

---

## External Package Dependencies

Listed in `pubspec.yaml`:
* **State Management**: `flutter_riverpod`, `riverpod_annotation`
* **Database**: `drift`, `drift_dev`, `path_provider`, `path`
* **Routing**: `go_router`
* **Networking & Scrapes**: `dio`, `html`
* **Animations**: `flutter_animate`, `animations`
* **Grid Views**: `flutter_staggered_grid_view`
* **Share Intents**: `receive_sharing_intent`
