# OpenHIIT

![Integration Tests](https://github.com/a-mabe/openhiit/actions/workflows/integration_tests.yaml/badge.svg)
![Nightly Build](https://github.com/a-mabe/openhiit/actions/workflows/nightly_build.yaml/badge.svg)
![Pre-Release](https://github.com/a-mabe/openhiit/actions/workflows/pre_release.yaml/badge.svg)
![Release](https://github.com/a-mabe/openhiit/actions/workflows/release.yaml/badge.svg)

<p align="center">
   <img src="./assets/icon/openhiit-ios.png" width="150"/>
</p>

<p align="center">
  <a href="https://www.buymeacoffee.com/amabe"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" width="200" /></a>
  <a href="https://play.google.com/store/apps/details?id=com.codepup.workout_timer"><img src="./assets/Google_Play_Badge.svg" width="140" /></a>
  <a href="https://apt.izzysoft.de/packages/com.codepup.workout_timer"><img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroidButton.png" height="46" alt="Get it at IzzyOnDroid"></a>
  <a href="https://apps.apple.com/us/app/openhiit/id6459617819"><img src="./assets/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg" width="140" /></a>
</p>

**OpenHIIT** is a free, open-source interval timer app built with Flutter. Create unlimited workout timers with custom audio/visual cues. No ads, no paywalls, no subscriptions.

▶️ The background timer package is developed separately [here](https://github.com/a-mabe/background_timer).

## Table of Contents

1. [Why OpenHIIT?](#why-openhiit)
2. [Features](#features)
3. [Roadmap](#roadmap)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Support](#support)
7. [Contributing](#contributing)
8. [License](#license)

---

## Why OpenHIIT?

- **No limits** — create as many timers and workouts as you want.
- **No paywalls** — every feature is free, forever.
- **No ads or subscriptions** — open-sourced under the [MIT license](#license).

---

## Features

| | |
|---|---|
| ⏲️ **Customizable Timers** | Build interval timers. |
| 🔊 **Visual & Audio Cues** | Stay on track with cues for every interval transition. |
| 💾 **Save & Load** | Store unlimited timer configurations. |
| 📱 **Export & Import** | Export and share timer configs or import configs. |
| 🖌️ **Color Coding** | Color-code your timers to keep your routines organized. |
| 🏋️ **Exercise Labels** | Add exercise names that display on-screen while the timer runs. |

<p align="center">
   <img src="https://github.com/user-attachments/assets/2d64f356-526b-419e-8b71-cc43bf8da65b" width="170">
   &nbsp;&nbsp;&nbsp;
   <img src="https://github.com/user-attachments/assets/8ada8439-deae-47ea-b76c-96c49cfdf914" width="170">
   &nbsp;&nbsp;&nbsp;
   <img src="https://github.com/user-attachments/assets/4b470c2f-96db-4e01-95c9-228cccb65316" width="170">
   &nbsp;&nbsp;&nbsp;
   <img src="https://github.com/user-attachments/assets/a74e76e5-4608-4303-a751-e156f1645335" width="170">
</p>

---

## Roadmap

Check out the [OpenHIIT Roadmap](https://github.com/users/a-mabe/projects/3) to see planned features, work in progress, and ideas under consideration. Have a suggestion? Open an issue or start a discussion.

---

## Installation

### Download the App

<a href="https://play.google.com/store/apps/details?id=com.codepup.workout_timer"><img src="./assets/Google_Play_Badge.svg" width="180" /></a>
&nbsp;&nbsp;
<a href="https://apps.apple.com/us/app/openhiit/id6459617819"><img src="./assets/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg" width="180" /></a>

### Build from Source

1. **Install Flutter** — follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install) to set up Flutter and the Dart SDK.

2. **Clone the repository:**
   ```bash
   git clone https://github.com/a-mabe/openhiit.git
   cd openhiit
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app** — connect a device or start an emulator, then:
   ```bash
   flutter run
   ```

---

## Usage

1. **Create a timer** — tap the "+" button to start a new interval timer.
2. **Customize intervals** — set your work, rest, and transition durations.
3. **Add exercises** — label each interval with the exercise name to display on screen.
4. **Save your config** — save the timer for quick access in future sessions.
5. **Start your workout** — follow the visual and audio cues through each interval.
6. **Share or reuse** — export your timers to share with others or import them on a new device.

---

## Support

Encountering an issue? Visit the [support page](./support.md) for troubleshooting guidance and known issues.

---

## Contributing

Contributions are welcome! Please open an issue before creating a PR. To begin working on an issue:

1. Fork the repository on GitHub.
2. Create a new branch with a descriptive name (e.g., `feature/rest-round-alerts`).
3. Make your changes, following the project's coding style.
4. Commit and push your changes to your fork.
5. Open a pull request describing what you changed and why.

Please check the [Roadmap](#roadmap) and open issues before starting work to avoid duplication.

---

## License

OpenHIIT is released under the [MIT License](https://opensource.org/licenses/MIT). You're free to use, modify, and distribute this app under those terms. See the `LICENSE` file for full details.