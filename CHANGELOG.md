## HEAD

# Version 0.1.0 (Initial Release)

- *Fix*: Passed to Isar-Community fork to resolve compatibility issue.
    - Issue: *Isar incompatibility: SDK build failures and Android 15 (16 KB) crashes ([#5](https://github.com/Stefano-Bozzi/GymTracker-App/issues?q=is%3Aissue%20state%3Aclosed))*
    - See this PR ([#6](https://github.com/Stefano-Bozzi/GymTracker-App/pull/6))

## Core & Philosophy
* **Privacy First**: Fully offline architecture with zero cloud tracking or data collection. 
* **Local Storage**: Integrated Isar Database for fast, secure, and reliable local data management ([#1](https://github.com/Stefano-Bozzi/GymTracker-App/pull/1)).
* **Theming**: Automatic Light and Dark mode support synchronized with device system preferences ([*see this commit*](https://github.com/Stefano-Bozzi/GymTracker-App/commit/d91269f7ac57f878552112bfcc5af697392ab259)).

## Navigation & UI
* **Bottom Navigation Bar**: Quick access to the three main modules: Home, Calendar (History), and Workouts (Templates).
* **Dynamic FAB**: A smart Floating Action Button that automatically adapts its text, icon, and action based on the active page ("New Session" vs. "New Workout").
* **App Drawer**: Side navigation menu featuring a Licenses & Information page, with structural placeholders for upcoming Statistics and Settings features.

## Workout Templates (Workouts Page) ([#2](https://github.com/Stefano-Bozzi/GymTracker-App/pull/2))
* **Template Management**: View all saved workout templates in a reverse-chronological list.
* **Create & Edit**: Build reusable templates by defining a workout name, adding multiple exercises, and setting the target number of sets for each.
* **Delete**: Easily remove outdated or unused templates.

## Workout Sessions (Calendar Page) ([#3](https://github.com/Stefano-Bozzi/GymTracker-App/pull/3))
* **History Tracking**: View all past workout sessions in a dedicated history list.
* **Session Creation**: Start a brand-new session from scratch or initialize one quickly using a pre-saved Template.
* **Live Logging**: Log exact weights (in kg) and repetitions for every single set during a session.
* **Progress Metrics**: Automatic underlying calculation of the Estimated One-Repetition Maximum (e1RM) for tracked sets.
* **Session Modification**: Edit existing session logs or delete them entirely from the history.