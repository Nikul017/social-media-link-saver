# Feature Map — Search Feature

## Purpose

Provides global real-time full-text indexing and retrieval of bookmarks, matching query parameters against titles, URLs, descriptions, tags, and markdown notes.

---

## Depends On

* **Drift Database Engine (`AppDatabase`)**
* **Riverpod State Manager (`flutter_riverpod`)**
* **Bookmarks Feature (Domain/Data layer filters)**

---

## Database Indexing & Queries

Search uses local SQLite queries optimized for text parsing:
* **FTS (Full-Text Search) Queries**: Executes queries using standard SQLite `LIKE` matching or FTS-virtual-tables depending on configuration.
* **Fields Indexed**: Matches target query string across:
  * `Bookmarks.title`
  * `Bookmarks.url`
  * `Bookmarks.description`
  * `Bookmarks.notes`
* **Relational Filters**: Supports chaining tag filters and folder containment directly into the search queries.

---

## Core State Providers

* **`searchQueryProvider`**: Maintains the active query string.
* **`searchFiltersProvider`**: Track active filters (e.g. favorite status, archive state, specific folders, selected tags).
* **`searchResultsProvider`**:
  * Watches `searchQueryProvider` and `searchFiltersProvider`.
  * Implements a **debouncing delay (typically 300ms)** to prevent database overload during rapid keystrokes.
  * Fetches matching bookmarks from the repository stream and exposes lists to the view.

---

## Key Screens & UI Components

1. **`SearchPage` (`lib/features/search/presentation/pages/search_page.dart`)**:
   * Interactive panel with a search text bar.
   * Floating filter chips (favorite, tag, folder).
   * Instant search result grid showing bookmark cards.
   * Empty state animations for zero-result queries.

---

## Future Upgrades: AI Semantic Search

To expand search capabilities, the architecture supports future integration of a local vector database:
1. **Embeddings Engine**: Convert bookmark titles/descriptions/notes into vector embeddings using a local or cloud-based model (e.g. OpenAI, HuggingFace, Gemini API).
2. **Vector DB (e.g., SQLite Vec, Drift custom extension)**: Store high-dimensional vectors and perform cosine similarity searches.
3. **Semantic Query Flow**:
   ```plaintext
   User enters: "helpful flutter state management tools"
     → Generate embedding for search query
     → Query local database using cosine similarity metric
     → Return semantically relevant bookmarks, even if keywords do not match exactly.
   ```
