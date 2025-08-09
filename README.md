# My Dear Diary

My Dear Diary is a simple and elegant journaling application built with Flutter. It allows you to record your thoughts, experiences, and memories in a beautiful and intuitive timeline format.

## Features

*   **Timeline View:** Events are displayed in a chronological timeline, making it easy to see your life at a glance.
*   **Event Creation and Editing:** Easily create new diary entries with a title, description, and start/end times. You can also edit existing entries.
*   **Search and Filter:** Search for events by keyword and filter them by date range.
*   **Lazy Loading:** Events are loaded on-demand as you scroll, ensuring a smooth and performant experience.
*   **Modern UI:** A clean and modern user interface with a beautiful animated gradient background.

## Development Environment

This project uses a Dockerized development environment to ensure consistency and reproducibility. The following dependencies are required to build and run the project:

*   **Docker:** [https://www.docker.com/](https://www.docker.com/)
*   **Docker Compose:** [https://docs.docker.com/compose/](https://docs.docker.com/compose/)

## How to Build

1.  **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd MyDearDiary
    ```

2.  **Start the Docker container:**

    ```bash
    docker-compose up -d
    ```

3.  **Build the APK:**

    ```bash
    docker-compose exec flutter-dev flutter build apk
    ```

    The built APK will be located in `build/app/outputs/flutter-apk/app-release.apk`.

## How to Contribute

Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

1.  **Fork the repository.**
2.  **Create a new branch for your feature or bug fix:**

    ```bash
    git checkout -b my-new-feature
    ```

3.  **Make your changes and commit them:**

    ```bash
    git commit -am 'Add some feature'
    ```

4.  **Push to the branch:**

    ```bash
    git push origin my-new-feature
    ```

5.  **Create a new Pull Request.**

Please make sure to write clear and concise commit messages and to follow the existing code style.