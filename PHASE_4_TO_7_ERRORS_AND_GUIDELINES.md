# Phase 4 to 7 Errors and Guidelines

This document tracks specific bugs, errors, and fixes encountered during Phase 4 (Game Generation & Engine), Phase 5 (Session Tracking & Progress Analytics), Phase 6 (Parent Dashboards) and Phase 7 (Child Gamification) to establish best practices and avoid them in the future.

## 1. JSON Serialization `defaultValue` Warning (`json_serializable`)
**Error/Warning**:
The constructor parameter for `progressBySubject` has a default value `const []`, but the `JsonKey.defaultValue` value `[]` will be used for missing or `null` values in JSON decoding.
**Cause**:
When using `@JsonKey(defaultValue: <Type>[])` along with `this.fieldName = const []` in the constructor, `json_serializable` detects a discrepancy between the generated default and the Dart `const` default.
**Guideline**:
For complex objects and lists in Flutter 3.40+, prefer either letting `json_serializable` handle it natively by using nullable lists `List<Type>?`, or accept the warning if you explicitly want the fallback list to be parsed safely from missing JSON keys.

## 2. Foreign Key Nullability (`IntegrityError`)
**Error**:
`
sqlite3.IntegrityError: NOT NULL constraint failed: games.lesson_id
`
**Cause**:
When generating adaptive practice games directly for a child based on weak concepts, there is no associated `lesson_id` or `analysis_id`. However, the SQLAlchemy `Game` model defined `lesson_id: Mapped[str] = mapped_column(..., nullable=False)` (implicit because `Optional` wasn`t used).
**Fix**:
In SQLAlchemy 2.0, explicitly use `Mapped[Optional[str]]` and `nullable=True` for foreign keys that can be conditionally null:
`python
lesson_id: Mapped[Optional[str]] = mapped_column(String(36), ForeignKey("lessons.id"), nullable=True)
`
**Guideline**:
Always map out the full lifecycle of an entity. If it can be created in a standalone manner (like practice games), its foreign keys to parent origin entities MUST be nullable.

## 3. Disconnected Frontend State from Backend Lifecycle
**Error**:
In Phase 4, the `GamePlayScreen` tracked `_score`, `_xpEarned`, and `_streak` locally in state, but did not push these updates to the backend Session API (`/sessions/{id}/answer`). Phase 5 built the Mastery Engine API, but the Flutter UI was never connected.
**Fix**:
Wired `ref.read(gameServiceProvider).submitAnswer()` inside the `_onAnswerSubmitted()` UI callback, extracting `concept_id` dynamically from `currentLevel.conceptIds`.
Wired `ref.read(gameServiceProvider).completeSession()` when the mission is finished.
**Guideline**:
Always ensure that the final integration step between a frontend state manager (Riverpod/StatefulWidget) and a backend analytics/tracking API is explicitly implemented. Test the end-to-end flow of answering a question in UI -> Backend DB.

## 4. `BuildContext` across async gaps (`use_build_context_synchronously`)
**Error**:
`
info - Don`t use `BuildContext`s across async gaps, guarded by an unrelated `mounted` check.
`
**Cause**:
Calling `context.go(`/child`)` after `await showDialog(...)` throws a linting warning in modern Flutter.
**Fix**:
Capture the router before the async call: `final router = GoRouter.of(context);`, then check `if (mounted) { router.go(`/child`); }`.
**Guideline**:
Always extract `Navigator` or `GoRouter` to a local variable before an `await` barrier in button callbacks.

## 5. Unused Imports and Deprecated Members
**Error**:
- Unused import: `app_button.dart` in Renderers.
- Deprecated member: `onReorder` in `ReorderableListView.builder`.
**Fix**:
Cleaned up imports and migrated `onReorder: (old, new)` to `onReorderItem: (old, new)` in Flutter 3.41+.
**Guideline**:
Run `flutter analyze` continuously as you build out UI components to catch these deprecations immediately.

## 6. Unhandled Async Errors in UI Dialogs (Phase 6 & 7)
**Error**:
In `child_detail_screen.dart`, editing a child`s profile or deleting a child profile invoked backend API calls (`repo.updateChild`, `repo.deleteChild`) without a `try/catch` block. If the API failed (e.g., network error), the user would be stuck in the dialog, or an unhandled exception would crash the application state.
**Fix**:
Wrapped the asynchronous API calls in a `try/catch` block.
Extracted `final navigator = Navigator.of(context);` and `final messenger = ScaffoldMessenger.of(context);` before the `await` gap.
On success, called `navigator.pop()`. On error, displayed a `SnackBar` via `messenger` with the error message.
**Guideline**:
Never execute asynchronous API calls from a UI dialog (like `showDialog` or `AlertDialog`) without a surrounding `try/catch` block and fallback UX to inform the user of failure.

## 7. Refreshing State after Navigation Push
**Error / Observation**:
When navigating to `AddChildScreen` from `ChildrenListScreen`, adding a child and popping back to the list didn`t automatically reflect the newly added child because the local `_children` array wasn`t automatically refetched.
**Fix**:
Used `await context.push(`/parent/children/add`);` followed by calling `_loadChildren();`. Because `GoRouter``s `push` returns a Future that resolves when the user pops the route, this reliably triggers a refresh of the parent screen.
**Guideline**:
When using explicit local state management without a reactive state provider for list data, always `await` the navigation to a creation/edit screen, and execute the refresh method immediately after.

## 8. Android compileSdk version conflict with ile_picker plugin (Phase 8)
**Error**:
`
Execution failed for task ':file_picker:checkDebugAarMetadata'.
Dependency ':flutter_plugin_android_lifecycle' requires libraries and applications that depend on it to compile against version 36 or later of the Android APIs.
:file_picker is currently compiled against android-34.
`
**Cause**:
The modern ile_picker and lutter_plugin_android_lifecycle dependencies require Android API 36, but the default Flutter template (lutter.compileSdkVersion) resolved to 34.
**Fix**:
In pp/android/app/build.gradle.kts, explicitly hardcoded compileSdk = 36 instead of compileSdk = flutter.compileSdkVersion.
**Guideline**:
When third-party plugins advance their minimum compile SDK beyond the stable Flutter SDK's internal default, explicitly set the compileSdk in the Android module to satisfy the highest requirement.
