---
description: Initiates the planning and clarification phase for a new task or vague requirement.
---

````md
---
name: planning
description: Mandatory planning and architecture analysis skill for Flutter projects using Graphify. Automatically activates for vague, complex, multi-file, architectural, refactor, feature, state-management, navigation, or UI requests.
---

# Graphify-Powered Flutter Planning Skill

This skill enforces architecture-aware planning before implementation.

It prevents:
- architectural drift
- duplicate implementations
- incorrect assumptions
- inconsistent state management
- poor feature integration
- unnecessary refactors

The agent MUST use Graphify as the primary architecture intelligence source before writing code.

---

# CORE RULES

## CRITICAL

The agent MUST NOT:
- write code
- modify files
- create files
- refactor architecture
- install dependencies
- generate migrations

until:
1. Graphify analysis is completed
2. Clarification questions are answered
3. The user explicitly approves the plan

---

# 1. GRAPHIFY ARCHITECTURE ANALYSIS

Before planning or implementation, ALWAYS refresh project intelligence.

## Step 1 — Update Graphify

Run:

```bash
graphify update
````

---

## Step 2 — Query Graphify

The agent MUST query Graphify to understand the existing architecture before proposing changes.

Mandatory query targets:

* feature modules
* providers/blocs/controllers
* repositories/services
* navigation flows
* widget relationships
* shared UI components
* API layers
* model usage
* theme systems
* dependency chains

---

# REQUIRED QUERY TYPES

## Feature Discovery

```bash
graphify query "features related to authentication"
graphify query "checkout feature structure"
graphify query "existing search implementations"
```

---

## State Management Discovery

```bash
graphify query "providers used by home screen"
graphify query "bloc dependencies for profile flow"
graphify query "riverpod state flow for cart"
```

---

## Navigation Discovery

```bash
graphify query "navigation path to settings"
graphify query "go_router route hierarchy"
graphify query "screens connected to onboarding"
```

---

## Reusable Component Discovery

```bash
graphify query "existing loading widgets"
graphify query "dialog components"
graphify query "theme extension usage"
graphify query "pagination implementations"
```

---

## Dependency Discovery

```bash
graphify query "dependencies of AuthProvider"
graphify query "services used by checkout"
graphify query "repository usage by payment flow"
```

---

# 2. REQUEST DECONSTRUCTION

The agent MUST analyze:

## Intent

Determine:

* feature request
* bug fix
* UI enhancement
* architecture refactor
* performance optimization
* infrastructure change

---

## Scope

Identify:

* impacted modules
* affected providers/blocs
* dependent services
* navigation implications
* shared widget usage
* storage/database impact

---

## Existing Pattern Detection

The agent MUST detect:

* similar implementations already existing
* reusable abstractions
* established architecture patterns
* current state management conventions
* UI design conventions

The agent MUST prefer:

* extending existing systems
* reusing existing abstractions
* following established project conventions

before introducing new architecture.

---

# 3. ARCHITECTURE SAFETY CHECKS

The agent MUST check for:

## State Risks

* duplicate state containers
* provider rebuild cascades
* circular dependencies
* unmanaged async state
* stale cache risks

---

## UI Risks

* excessive rebuild zones
* nested scroll conflicts
* expensive widget trees
* animation performance issues
* responsiveness inconsistencies

---

## Architecture Risks

* feature boundary violations
* direct API calls from UI
* repository bypassing
* tight coupling
* duplicated business logic

---

## Navigation Risks

* route duplication
* broken deep linking
* navigation race conditions
* improper auth guards

---

# 4. PROPOSAL FORMAT

The agent MUST output EXACTLY this structure:

# Proposal & Clarification: [Task Name]

## 1. What I Understand

### Requested Goal

[Detailed interpretation of the request]

### Graphify Findings

[List architecture discoveries from Graphify queries]

Example:

* `AuthProvider` manages session persistence
* `GoRouter` handles protected routes
* Existing loading states use `AsyncValue`
* Similar implementation exists in `SearchFeature`

### Planned Integration Strategy

[Explain how the implementation will align with the existing architecture]

---

## 2. Affected Architecture

### Existing Files

* [MODIFY] `lib/features/...`
* [MODIFY] `lib/core/...`

### New Files

* [NEW] `lib/features/...`
* [NEW] `lib/shared/...`

### Impacted Components

#### State Management

* Providers
* Blocs
* Controllers
* Notifiers

#### Services & Repositories

* Repository dependencies
* API services
* Local storage layers

#### Navigation

* Routes
* Guards
* Deep links

#### Shared UI

* Common widgets
* Theme extensions
* Design system components

---

## 3. Risks & Edge Cases

### Performance

* Potential rebuild propagation
* Expensive async operations
* Widget tree complexity

### Behavioral

* Empty states
* Retry handling
* Offline behavior
* Concurrent requests

### Architecture

* Dependency conflicts
* State duplication risks
* Boundary violations

---

## 4. Clarifying Questions

> [!IMPORTANT]
> Please answer the following before implementation begins:

1. **State Management Approach**

   * Option A: Extend existing state flow
   * Option B: Create isolated feature state

2. **UI Integration Strategy**

   * Option A: Reuse current design system
   * Option B: Introduce custom UI pattern

3. **Navigation Behavior**

   * Option A: Standard route navigation
   * Option B: Modal/bottom-sheet flow

4. **Failure Handling**

   * Option A: Snackbar feedback
   * Option B: Dedicated recovery UI

5. **Persistence Strategy**

   * Option A: In-memory only
   * Option B: Persist locally

---

# 5. APPROVAL GATE

After presenting the proposal:

STOP.

Do NOT:

* generate code
* create files
* suggest implementations
* perform refactors

until the user explicitly approves the plan.

---

# 6. GRAPHIFY-FIRST ENFORCEMENT

Before introducing ANY new:

* provider
* bloc
* repository
* service
* widget
* route
* model
* utility

the agent MUST query Graphify for existing equivalents.

Examples:

```bash
graphify query "existing pagination provider"
graphify query "shared form validation"
graphify query "existing auth repository"
graphify query "loading overlay widgets"
```

If existing solutions are found:

* reuse them
* extend them
* or justify why a new implementation is required

---

# 7. FLUTTER-SPECIFIC BEST PRACTICES

The agent MUST follow:

## UI

* Prefer const widgets where possible
* Minimize rebuild scope
* Avoid deeply nested Consumers/Builders
* Preserve responsive layouts

---

## State Management

* Keep business logic outside UI
* Avoid duplicate state sources
* Maintain unidirectional data flow

---

## Architecture

* Respect feature boundaries
* Use repositories/services consistently
* Avoid direct infrastructure access from presentation layer

---

## Performance

* Prevent unnecessary rebuilds
* Avoid synchronous heavy work in UI thread
* Preserve lazy loading patterns

---

# 8. REFUSAL CONDITIONS

The agent MUST refuse implementation until clarification if:

* architecture intent is unclear
* conflicting patterns are requested
* user request contradicts existing architecture
* Graphify analysis is incomplete
* feature scope is ambiguous

---

# 9. SUCCESS CRITERIA

A successful planning phase MUST:

* use Graphify queries
* identify impacted architecture
* detect reusable patterns
* expose risks and edge cases
* ask targeted clarification questions
* halt before implementation
* preserve project architecture consistency

```
```
