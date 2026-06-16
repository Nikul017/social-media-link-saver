# Feature Map — Cloud Sync Feature

## Purpose

Enables multi-device data synchronization, keeping bookmarks, tags, and folders identical across mobile and desktop environments.

---

## Depends On

* **Drift Database Engine (`AppDatabase`)**
* **Network Scrapers / API Clients (`Dio`)**
* **Cloud Backend Service (Supabase or Firebase)**
* **Connectivity Monitor (`connectivity_plus`)**

---

## Architecture Design: Offline-First Sync

To maintain zero-lag functionality offline, sync operates asynchronously via a transaction queue:
1. **Local Writes First**:
   * All mutations (adding bookmarks, deleting tags, editing folders) are saved immediately to local Drift SQLite tables.
   * Drift logs these operations in a local `sync_queue` table with action metadata (`CREATE`, `UPDATE`, `DELETE`), model type, and timestamp.
2. **Synchronization Trigger**:
   * Triggered when: Network connection changes from offline to online, user manually requests refresh, or the app enters the foreground.
3. **Queue Processing**:
   * The `SyncService` processes items in the local `sync_queue` sequentially to preserve order.
   * Pushes mutations to the remote cloud server (e.g. Supabase DB via REST/RPC API).
   * Once confirmed, deletes the local `sync_queue` records.

---

## Data Synchronization Flow

```plaintext
User modifies local record
  → Record saved to Drift SQLite
  → Insert item in local sync_queue table
  → Network change listener detects online state
  → SyncService reads sync_queue
  → API call sends batch payload to Cloud DB
  → Cloud confirms write
  → Local DB marks record synced, clears queue item
```

---

## Conflict Resolution Strategies

* **Last-Write-Wins (LWW)**: Uses timestamps on records (`updatedAt`). The record with the newest timestamp is preserved.
* **Folder Structure Merging**: Merges folder trees by checking folder name and hierarchy paths.
* **Tag Deduplication**: Normalizes tag names to lowercase and merges duplicate tags if matching labels are added on different devices while offline.
