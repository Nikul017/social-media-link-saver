# Feature Map — Bookmarks Feature

## Purpose

The Bookmarks feature allows users to save, preview, categorize, tag, and organize URLs. It features an automated scraper that collects website metadata (title, description, image, favicon) and stores the data locally in an offline-first SQLite database.

---

## Depends On

* **Drift Database Engine (`AppDatabase`)**
* **Riverpod State Manager (`flutter_riverpod`)**
* **GoRouter Navigation (`app_router`)**
* **Metadata Scraping Engine (`MetadataService`)**
* **Folder System & Tags System**

---

## Data Models & DB Schema

### Tables Defined in Drift:
1. **`Bookmarks` Table:**
   * `id`: Auto-incrementing primary key (int)
   * `url`: Scraped URL (string)
   * `title`: Page title (string)
   * `description`: Excerpt metadata (string, optional)
   * `thumbnailUrl`: Page hero image link (string, optional)
   * `faviconUrl`: Page favicon (string, optional)
   * `notes`: Markdown-supported notes text (string, optional)
   * `category`: AI-ready smart classification label (string, optional)
   * `folderId`: Foreign key linking to the `Folders` table (int, optional)
   * `isFavorite`: Favorite toggle boolean (defaults to `false`)
   * `isArchived`: Archived toggle boolean (defaults to `false`)
   * `createdAt`/`updatedAt`: Timestamp fields (DateTime)

2. **`Tags` Table:**
   * `id`: Primary key (int)
   * `name`: Tag name (string, unique)
   * `color`: Hex color string for color-coding tags (string, optional)

3. **`BookmarkTags` Table (Pivot table for Many-to-Many relationship):**
   * `bookmarkId`: References `Bookmarks(id)` with cascade deletion
   * `tagId`: References `Tags(id)` with cascade deletion
   * Primary Key: Composite `{bookmarkId, tagId}`

---

## Core State Providers

Providers are declared in [bookmark_providers.dart](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/lib/features/bookmarks/presentation/providers/bookmark_providers.dart):
* **`bookmarksListProvider`**: Retrieves and filters all bookmarks. Accepts search, folder, and tag filter parameters.
* **`bookmarkStreamProvider(id)`**: Watches database records for a single bookmark ID, updating the detail view reactively.
* **`favoriteBookmarksProvider`**: Filters bookmarks where `isFavorite = true`.
* **`archivedBookmarksProvider`**: Filters bookmarks where `isArchived = true`.
* **`addBookmarkSheetController`**: Manages the state of validation, metadata extraction, folder/tag selection, and creation flow in the add/edit sheet.

---

## Key Screens & UI Components

1. **`HomePage` (`lib/features/bookmarks/presentation/pages/home_page.dart`)**:
   * Layout: Pinterest-inspired masonry grid using `flutter_staggered_grid_view`.
   * Displays Bookmark cards with thumbnail previews.
   * Drawer for folder selection.
2. **`BookmarkDetailPage` (`lib/features/bookmarks/presentation/pages/bookmark_detail_page.dart`)**:
   * Reactive detail panel displaying tags, notes, and metadata.
   * Uses `bookmarkStreamProvider` to receive real-time edits without popping navigation.
3. **`AddBookmarkSheet` (`lib/features/bookmarks/presentation/widgets/add_bookmark_sheet.dart`)**:
   * Reusable modal sheet utilized for both **adding new bookmarks** and **editing existing bookmarks**.
   * Integrates auto-complete tags, folder selectors, and categories.
4. **`BookmarkCard` (`lib/features/bookmarks/presentation/widgets/bookmark_card.dart`)**:
   * Grid tile with glassmorphism overlays, displaying metadata thumbnail, favicons, title, and tags.

---

## Data & State Flow

### Save Flow
```plaintext
User shares/enters URL
  → Trigger MetadataService.fetchMetadata() via Dio
  → Populate AddBookmarkSheet preview
  → User adds tags/folders and taps Save
  → Call BookmarkRepository.saveBookmark()
  → Drift Database writes to Bookmarks & BookmarkTags tables
  → Drift watches tables → fires Stream update
  → Riverpod Provider emits new state list
  → Grid UI animates and inserts card
```

---

## Performance & Scaling Considerations

* **Image Caching**: Images are cached locally using `cached_network_image` to prevent repetitive network fetches and grid scrolling lag.
* **DB Indexing**: Drift indexes are applied on `bookmarks(url)` and relationship columns to optimize query speeds.
* **Many-to-Many Cleanup**: When deleting bookmarks, SQLite cascade rules automatically delete the corresponding links in `BookmarkTags` to avoid orphaned rows.
