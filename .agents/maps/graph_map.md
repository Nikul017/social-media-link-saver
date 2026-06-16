# Feature Map — Graph Hub Feature

## Purpose

The Graph Hub provides an interactive Obsidian-style Force-Directed Knowledge Graph representing the connections between bookmarks, tags, and folders. Users can visualize their personal knowledge second-brain, locate thematic clusters, filter nodes, and tap elements to open related details.

---

## Depends On

* **Drift Database Engine (`AppDatabase`)**
* **Riverpod State Manager (`flutter_riverpod`)**
* **Graph View Engine (`graphview` or `flutter_force_directed_graph`)**
* **Bookmarks Feature (Data and Domain models)**

---

## Node & Relationship Mapping

The knowledge graph constructs relationships from Drift tables dynamically:
1. **Nodes (Visual Vertices)**:
   * **Bookmark Nodes**: Rendered using a distinct color (purple/indigo), showing site favicons or metadata icons.
   * **Tag Nodes**: Rendered with tag-specific colors (e.g. green, blue) as connection hubs.
   * **Folder Nodes**: Rendered with distinct color (gold/amber) representing the containment hierarchy.
2. **Edges (Visual Links)**:
   * **Bookmark-to-Tag Edge**: Signifies a tag associated with a bookmark.
   * **Bookmark-to-Folder Edge**: Signifies a parent folder containment.
   * **Folder-to-Folder Edge**: Represents sub-folder nesting hierarchies.

---

## Core State & Controllers

Implemented in:
* **`graph_controller.dart` (`lib/features/graph/presentation/controllers/graph_controller.dart`)**:
  * Exposes the graph structure state.
  * Fetches bookmarks, tags, and folders from database providers.
  * Runs the force-directed layout algorithm (`buildFromBookmarks`) to position vertices and edge coordinates.
  * Configures physics variables (repulsion, attraction, gravity) to prevent overlap.
* **`graphPageProvider`**:
  * Observes and loads database streams, feeding updates into the `graph_controller`.

---

## Key Screens & UI Components

1. **`GraphPage` (`lib/features/graph/presentation/pages/graph_page.dart`)**:
   * Layout container supporting pan-and-zoom gestures.
   * Renders the interactive node chart.
   * Includes floating controls: zoom-in/out, focus-center, and search/filter panels.
   * Displays legend badge tracking node counts by type (Bookmarks, Tags, Folders).
2. **`GraphNodeWidget`**:
   * Custom painter or icon widget representing individual nodes with labels.
   * Handles tap gestures to redirect to the resource's details route (e.g., folder content, tag filters, or bookmark detail page).

---

## Performance & Optimization Rules

* **Repaint Boundary**: Wrap the graph canvas inside a `RepaintBoundary` to prevent global widget tree rebuilds during layout dragging operations.
* **Node Limit Optimization**: Limit or group display nodes if the database exceeds 1,000 active bookmarks to preserve frame rates (aiming for 60fps).
* **Spring Simulation Debouncing**: Debounce graph simulation runs during real-time database updates to avoid jerky movements.
