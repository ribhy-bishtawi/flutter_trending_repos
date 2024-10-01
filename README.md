# Trending Repos

Trending Repos is a Flutter application that displays trending repositories from GitHub. Users can filter repositories based on creation time (last day, last week, last month), view repository details, and mark repositories as favorites, which are saved locally for offline viewing.

## General Architecture

This application is built using the **MVVM (Model-View-ViewModel)** architecture pattern for clean separation of concerns and ease of testing and maintenance.

- **Model**: Responsible for handling data logic and defining the repository model.
- **ViewModel**: Handles business logic, network requests, and state management for the views. It interacts with the network helper for API calls and shared preferences for caching favorites.
- **View**: Displays the UI components and reflects the state changes from the ViewModel.

The app also uses **Provider** for state management, ensuring efficient reactivity between the views and the data without unnecessary rebuilds.

## Directory Structure
```
lib/
├── controller/              # ViewModel logic and state management
│   └── repository_viewmodel.dart
├── core/                    # Core app services like app providers
│   └── app_providers.dart
├── data/                    # Data models and services
│   ├── models/              # Repository model and data mapping
│   │   └── repository_model.dart
│   └── services/            # API calls and network helpers
│       ├── api_constants.dart
│       ├── api_service.dart
│       ├── custom_response.dart
│       └── status_code.dart
├── main.dart                # App entry point
├── presentation/            # UI screens and widgets
│   ├── screens/             # Trending and favorites screens
│   │   ├── details_screen.dart
│   │   ├── favs_screen.dart
│   │   └── trending_repos_screen.dart
│   └── widgets/             # Reusable widgets (e.g., repo_card.dart)
├── utils/                   # Utility functions and constants
│   ├── app_strings.dart
│   ├── constants.dart
│   ├── palette.dart
│   └── text_style.dart
└── README.md
```

## Reasoning Behind Main Technical Choices

- **Provider for State Management**: Provider is lightweight, easy to integrate, and offers a good solution for managing the app's state without introducing too much complexity. It allows reactive UI updates whenever the app state changes.
- **Dio for Networking**: Dio was chosen for handling API requests due to its powerful features such as built-in request logging, error handling, and support for custom configuration.
- **MVVM Architecture**: This architecture pattern was selected to maintain a clean separation of concerns between business logic and UI, making the app more scalable, testable, and maintainable.
- **SharedPreferences for Offline Data**: SharedPreferences is used to store the user's favorite repositories locally, allowing users to view them even when they are offline.

## Features

### Implemented Features:

- **Trending Repositories**: Displays repositories that are trending on GitHub. The user can filter by time frame (day, week, month).
- **Infinite Scrolling**: The app loads more repositories when the user reaches the end of the list.
- **Favorites**: The user can mark repositories as favorites and view them in the "Favorites" screen, even while offline.
- **Search**: The user can search repositories by name in both the trending and favorites screens.
- **Repository Details**: Users can tap on a repository to view detailed information such as language, forks, creation date, and a link to the GitHub page.
- **Error Handling**: Displays user-friendly error messages for network issues or API errors.
- **Responsive Design**: The app support different screen sizes, ensuring a user-friendly layout on both smaller mobile devices and larger tablets.

### Unimplemented Features:
- **Routes Management**: The app currently handles navigation manually. Using a dedicated routing package like GoRoute would help manage routes more efficiently, making navigation easier to extend and maintain.
- **Localization Integration**: While localization support is ready, it hasn't been fully integrated into the app. Implementing localization will allow the app to support multiple languages and adapt to different regions, improving accessibility and user experience.


### Future Improvements:

- **Tablet UI Support**: The app is fully responsive and works well on both larger and smaller screens. However, need more adjustments to fine-tune the layout.
- **Unit Tests**: Additional testing, especially on ViewModel classes and network services, would enhance the app’s robustness.
- **Use of sqflite Instead of shared_preferences**: While the current use of shared_preferences is efficient for small to moderately sized lists (e.g., a few repositories), for larger datasets, this approach may become less efficient.
  
## Final Notes

- **Error Handling**: Error handling is included to keep users informed when network issues occur. The app shows clear error messages for API limits, missing data, or network failures.
- **Code Organization**: The code is modular and follows a clean architecture with proper separation between data, business logic, and UI. This makes the app easy to extend, refactor, and test.
