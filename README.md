# Mobile client-server app made for my wife as a gift
A cross-platform application with an ASP.NET Core backend and a Flutter frontend.

## Tech Stack
- Backend: ASP.NET Core (Web API)
- Frontend: Flutter
- Containerization: Docker

## Getting Started
### 0. Prerequisites
- Installed `Docker`
- Installed `Docker Compose`
- Access to a `Docker registry` (e.g., `Docker Hub` or private registry)
- Installed `.NET 8 SDK`
- Installed `Flutter SDK`

### 1. Clone the repository
  ```
  git clone https://github.com/SameGevDudios/adjective-io.git
  cd adjective-io
  ```

### 2. Backend Setup (Docker)

1. Create an `.env` file in the **backend root** directory (where `docker-compose.yml` is located). Use the structure from `.env.example`
  
    You can use these example values:
    ```
    AUTH_DB_PASSWORD=your_secure_password_1
    DATA_DB_PASSWORD=your_secure_password_2
    PREFERENCE_MIN_DELTA=0.2
    PREFERENCE_MAX_DELTA=0.35
    PREFERENCE_FADE_RATE=0.05
    PREFERENCE_WEIGHT_ABS=1.5
    PREFERENCE_POSITIVE_PERCENTAGE=0.7
    PREFERENCE_NEGATIVE_PERCENTAGE=0.3
    ```

2. Run with Docker Compose
    To build and start all services:
    ```
    docker-compose up -d --build
    ```
    The API will be available at: `http://localhost:5000/api/v1/`

### 3. Mobile app setup
1. Inside the Flutter project setup the `env/development.json` file. Use structure from `env/development.example.json`

2. Run app (debug)
`flutter run --dart-define-from-file=env/development.json`

3. Build the app
  - Android
      ```
      flutter build apk --dart-define-from-file=env/development.json
      ```
  - iOS (only supported on `macOS`)
      ```
      flutter build ios --dart-define-from-file=env/development.json
      ```

      NOTE: recommended to create `env/release.json` to configure app production environment
## 📄 License
[MIT](https://github.com/SameGevDudios/adjective-io/blob/main/LICENSE)
