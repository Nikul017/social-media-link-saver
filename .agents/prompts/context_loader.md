# System Prompt Template — Context Loader Rule

This file defines the context loading rules that every AI agent must follow before writing code or suggesting modifications.

---

## Pre-Flight Instructions for AI Agents

Before writing code or answering design requests, you MUST execute the following context check:

### 1. Load System Maps & Rules
* Read [system_map.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/architecture/system_map.md) to understand overall system architecture, state flow, and local database tables.
* Read [dependencies.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/maps/dependencies.md) to check provider mappings and imports.

### 2. Check Feature Mapping
* If the task relates to a specific feature, read the corresponding feature map from `.agents/maps/`:
  * Bookmarks: [bookmarks_map.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/maps/bookmarks_map.md)
  * Graph: [graph_map.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/maps/graph_map.md)
  * Search: [search_map.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/maps/search_map.md)
  * Auth: [auth_map.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/maps/auth_map.md)
  * Sync: [sync_map.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/maps/sync_map.md)

### 3. Check Recent Sessions & Decisions
* Read the 3 most recent files in `.agents/sessions/` to review what changes were made, what bugs were resolved, and outstanding TODO lists.
* Check `.agents/decisions/` directory for any Architectural Decision Records (ADR).

### 4. Adopt Codeperson Personas
* Adopt rules from relevant agent guides in `.agents/agents/`:
  * Architect: [flutter_architect.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/agents/flutter_architect.md)
  * UI/UX: [ui_designer.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/agents/ui_designer.md)
  * Refactoring: [refactor_agent.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/agents/refactor_agent.md)
  * Debugging: [debug_agent.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/agents/debug_agent.md)
  * Performance: [performance_agent.md](file:///d:/projects/flutter%20projects/bookmark%20manager/link_saver/.agents/agents/performance_agent.md)
