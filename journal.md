# Journal: Building "My Dear Diary"

This journal documents the steps taken to build the "My Dear Diary" Flutter application, following the provided development guides.

## 1. Environment Setup

*   **Intention:** To establish a consistent and reproducible development environment.
*   **Steps Taken:**
    *   Read and understood the `Diary App Development Guide_.md` and `Archlinux Flutter Development Setup Guide.md`.
    *   Created a `Dockerfile` to define the Flutter development environment.
    *   Created a `docker-compose.yml` to orchestrate the container.
    *   Created an `entrypoint.sh` script to run commands within the container.
    *   Built and started the Docker container.
    *   Resolved file permission issues to ensure proper operation.

## 2. Project Scaffolding

*   **Intention:** To create a well-organized and scalable project structure.
*   **Steps Taken:**
    *   Created a new Flutter project within the Docker container.
    *   Established the directory structure as specified in the guide (app, core, data, presentation).
    *   Added all necessary dependencies to the `pubspec.yaml` file.

## 3. Data Persistence Layer

*   **Intention:** To create a robust and efficient local database for storing diary entries.
*   **Steps Taken:**
    *   Created the `DiaryEvent` data model.
    *   Implemented the `DatabaseHelper` as a singleton to manage the SQLite database connection.
    *   Created the `DiaryRepository` to abstract data operations and provide a clean API to the rest of the application.

## 4. User Interface

*   **Intention:** To build the core UI screens and navigation.
*   **Steps Taken:**
    *   Configured `go_router` for declarative navigation.
    *   Created the main application widget (`MyDearDiaryApp`).
    *   Updated `main.dart` to run the application.
    *   Created the `DashboardPage` and `EventsPage`.
    *   Created a reusable `EventCard` widget.
    *   Implemented the corresponding `DashboardViewModel` and `EventsViewModel` to manage the state of the UI.
    *   Implemented the timeline view on the `DashboardPage` using the `timeline_tile` package.
    *   Implemented the `MainShell` widget with a `BottomNavigationBar` for top-level navigation.

## 5. Advanced Features

*   **Intention:** To implement interactive and intelligent features to enhance the user experience.
*   **Steps Taken:**
    *   Created the `EventFormViewModel` to manage the state of the event entry form.
    *   Created the `EventEntryPage` with a form for creating and editing events.
    *   Implemented intelligent title suggestions using `flutter_typeahead`.
    *   Added debouncing to the title suggestion feature to optimize performance.
    *   Implemented a date range filter on the `DashboardPage`.
    *   **Fixed:** Addressed the black screen issue after saving an event by navigating back to the dashboard using `context.go()`.
    *   **Fixed:** Implemented date and time pickers for `startTime` and `endTime` fields in the event entry form.
    *   **Feature:** Implemented interactive options (Edit, Delete, Share) for event cards on Dashboard and Events pages via a modal bottom sheet.
    *   **Feature:** Enabled navigation to `EventEntryPage` for editing existing events, passing the `DiaryEvent` object.
    *   **Feature:** Implemented event deletion functionality, refreshing the UI after deletion.
    *   **Fixed:** Corrected the initial display of events on the Dashboard by refining the loading logic in `DashboardViewModel` and `DashboardPage`.
    *   **Feature:** Implemented time filter for search using a dedicated button and `showDateRangePicker`.
    *   **Feature:** Made the search bar remember the previously searched text.
    *   **Feature:** Implemented a live counter for events found in the search bar as the user types.
    *   **Fixed:** Ensured the dashboard refreshes after creating, editing, or deleting an event by using `.then()` callbacks on `context.push()` and `loadEvents(refresh: true)`.

## 6. Polishing the Experience

*   **Intention:** To add visual flourishes and animations to create a more engaging and delightful user experience.
*   **Steps Taken:**
    *   Created and applied an `AnimatedGradientBackground` to the main application shell.
    *   Implemented custom slide transitions for the event entry page.
    *   Used Flutter's built-in `AnimatedList` to add fade-in animations to the events list.
    *   **Feature:** Implemented relative time display (e.g., "now", "2 minutes ago") for event timestamps in `EventCard` and `DashboardPage`.
    *   **Feature:** Removed the left-side date display from the timeline in `DashboardPage`.
    *   **Feature:** Consolidated the Dashboard and Events pages into a single Dashboard view with search and lazy loading capabilities.
    *   **Feature:** Displayed the number of events found during search in `DashboardPage`.
    *   **Feature:** Changed the app name to "My Dear Diary" for Android and iOS.
    *   **Feature:** Moved `MyDearDiary.png` to `assets/app_icon` for app icon generation.

## 7. Refactoring

*   **Intention:** To improve code quality, reduce coupling, and increase modularity.
*   **Steps Taken:**
    *   **Decoupled `EventCard`:** Modified the `EventCard` to accept `onEdit` and `onDelete` callbacks, removing its direct dependency on `DashboardViewModel`.
    *   **Extracted `EventSearchDelegate`:** Moved the `EventSearchDelegate` to its own file in `lib/presentation/widgets`.
    *   **Broke down `DashboardPage`:** Extracted the timeline view into a separate private widget (`_EventTimeline`) to reduce the size of the `build` method.
