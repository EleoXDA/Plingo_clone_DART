# Developing apps with Bloc 8.0

_This project was developed as part of an article for RWenderlich._

Hey, you! Did you hear? The new release 8.0 for Bloc has been out for some time now and you will love it! One of the most notable changes is that it removes the deprecated `mapEventToState` API in favor of `on<Event>` introduced in earlier versions; there's also a new way to work with concurrent events and monitoring Blocs is now easier to do and predict.

In this tutorial, you'll get to:

- Refresh you knowledge about core concepts like Bloc and Cubits.
- Learn about the new event API in Bloc 8.0.
- Understand the concurrency of events in a Bloc.
- Track and debug your Blocs or Cubits.

It is time for you to take advantage of all these new changes by developing an app with Bloc 8.0, are you ready?

Note: This tutorial assumes you have intermediate knowledge of stateful and stateless widgets, usage of previous versions of Bloc and provider. To learn more about them, check out [Getting Started with the BLoC Pattern](https://www.raywenderlich.com/4074597-getting-started-with-the-bloc-pattern), [Bloc's documentation and tutorials](https://bloclibrary.dev/#/gettingstarted) or learn about [State Management With Provider](https://www.raywenderlich.com/6373413-state-management-with-provider).

- [Getting Started](#getting-started)
- [Refreshing Key Terms](#refreshing-key-terms)
- [Handling Game State Changes](#handling-game-state-changes)
- [Recognizing `LetterKeyPressed`](#recognizing-letterkeypressed)
- [Transforming Events](#transforming-events)
- [Adding a New Cubit](#adding-a-new-cubit) [Instruction]
- [Monitoring a Bloc](#monitoring-a-bloc) [Instruction]
- [Where to Go From Here?](#where-to-go-from-here)

## Getting Started

Download the starter project by clicking **Download Materials** at the top or bottom of the tutorial. Then, open the starter project in VS Code 1.66 or later. You can also use Android Studio, but you’ll have to adapt the instructions below as needed.

Use a recent version of **Flutter**, 2.10 or above. VS Code should show a notification prompting you to click on it to get the dependencies for the project.

If VS Code doesn’t get the dependencies automatically, then download them by opening **pubspec.yaml** and clicking the **get package** icon on the top-right corner or by running the command `flutter pub get` from the terminal.

You'll develop an app called **Plingo**. It is a word-guessing game like Wordle. You have to guess a five-letter word within five attempts to win. There’s a new random word each time you play for guessing; if the user guesses the word they will start or increase a winning streak; if the user fails to guess then the streak resets. The game will also store the times you have played, the times you have won a game, the longest winning streak, and the current winning streak.

Here’s a quick rundown of how the project is set up:

- **main.dart**: Standard main file required for Flutter projects.
- **domain.dart**: Contains the game logic and corresponding class definitions.
- **data.dart**: Contains the classes that interact with storage and allows for better data handling.
- **app**: A folder with the app widget and also a helper file with colors defined by the brand guidelines.
- **monitoring**: A folder with a helper class that will help you track your Blocs and Cubits.
- **presentation**: Contains different folders that build the game's UI:
  - **bloc** has a bloc definition for handling game interactions and possible outcomes from it like winning or losing.
  - **cubit** has a cubit definition for handling the stats displayed in an in-game dialog.
  - **pages** has all the pages.
  - **widgets** contains all the reusable widgets.
  - **dialogs** has all the game’s dialog.

Build and run the starter project using the emulator of your preference or a mobile device. At this point, you’ll see the following:

[IMAGES]

As you can tell, the most important aspects of the game are missing. Plingo does not display anything when you tap on a key on the on-screen keyboard. Also, all the stats show as a negative number when you tap on the stats icon in the top right corner of the screen to see the stats dialog.

In summary, all the logic of the game is missing; you will work on implementing it by using Bloc 8.0 in this tutorial.

## Refreshing Key Terms

Plingo looks great right now, even though it does not provide interaction for the players the game does have a complete UI in it. This will give you enough time to refresh a couple of key terms that are crucial for understanding the plugin's implementation of the **BLoC** pattern.

BLoC stands for **B**usiness **Lo**gic **C**omponent and is a design pattern created for state management in apps. The general idea of how BLoC interacts in your app is that the user (or a process) triggers an event; then, a component takes the event and applies business logic to it (for example by communicating with an external API) transforming the information into a new state; in turn, this state change should trigger a change in the UI or another part of your app.

In the end, what Bloc attempts to make is that control when a state change can occur and enforce a single way to change state throughout an entire application.

`bloc` is a plugin that has a built-in implementation of BLoC; it has two different variants of these types of components: `Bloc`s and `Cubit`s. Using either option will help you separate presentation from business logic, making your code fast, predictable, easy to test, and reusable.

A `Bloc` is the core definition of the design pattern above, it relies on events to trigger state changes. Blocs are more complex to understand but provide better traceability and can handle advanced event transformations.

Take a look at this example implementation of `Bloc` for a counting app that you can find in the [documentation of the plugin](https://bloclibrary.dev/#/coreconcepts?id=cubit-advantages):

```dart
abstract class CounterEvent {}
class CounterIncrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
  }
}
```

A `Cubit` is a much simpler implementation of the pattern, it exposes functions to trigger state changes instead of event classes. Its simplicity makes it easier to understand and needs less code. Here's how the counting app would look with a `Cubit`:

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}
```

Okay, now you might be thinking about when to choose one over the other; if that's the case then keep in mind that a good rule of thumb is to start with a `Cubit` and refactor to a `Bloc` if you need more traceability or handle event transformation.

Note: As you see, there are different ways in which the word **bloc** refers to different things like BLoC for the pattern, bloc for the plugin, and Bloc for the implementation of the pattern inside the plugin. From now on `Bloc` refers to the class defined in the plugin, this will help you avoid confusion in the next sections.

## Handling Game State Changes

Now that you have refreshed your mind with some of the core concepts, it's time you dive into coding.

If you used the plugin before then you might remember the a new Events API introduced in v7.2.0. The motivation behind this change was predictability but it also gave extra simplicity to event handling.

Open `lib/presentation/bloc/game_event.dart` and take a look at the different events that you will proccess in `GameBloc`:

1. `LetterKeyPressed`: An event performed when the user taps a key on the onscreen keyboard (`PlingoKeyboard`).
2. `GameStarted`: An event triggered when a new game starts, either by opening the app or tapping **Play Again** when you win or lose the game.
3. `GameFinished`: This event happens when the player guesses the puzzle and wins or reaches the max attempts to guess and loses the game.

You are going to start by adding `GameStarted`, open `lib/presentation/bloc/game_bloc.dart` and replace the constructor in line 40 with the following:

```dart
GameBloc(this._statsRepository)
    : super(GameState(
        guesses: emptyGuesses(),
      )) {
  on<GameStarted>(_onGameStarted);
}
```

This code will let `GameBloc` process `GameStarted` events. At this point a compilation error should be showing in your editor since `_onGameStarted` is not yet defined; fix that by replacing `// TODO: Add logic for GameStarted` with this code:

```dart
void _onGameStarted(
  GameStarted event,
  Emitter<GameState> emit,
) {
  print('Game has started!');
  final puzzle = nextPuzzle(puzzles);
  final guesses = emptyGuesses();
  emit(GameState(
    guesses: guesses,
    puzzle: puzzle,
  ));
}
```

This function will define the logic that should happen when a game starts. First `nextPuzzle` defines a random puzzle from the list of available puzzles; then `emptyGuesses` generates a multidimensional array that will handle the letters and words guessed in the form of a 5x5 matrix of `String`s. Finally, you emit a new `GameState` with that information, this will also update the game's UI.

Right now `GameBloc` is ready to handle the start of a game but that event is not added to `GameBloc` in the app, you will now write a few lines of code for that. Open `lib/app/app.dart` and replace the line below `// TODO: Start game here!` and with:

```dart
GameBloc(ctx.read<GameStatsRepository>())..add(GameStarted()),
```

This will take care of starting a game whenever the app starts. Open `lib/presentation/pages/main_page.dart` and replace the definition of `onPressed` below `// TODO: Restart game here!` with the following code:

```dart
onPressed: () => context.read<GameBloc>().add(const GameStarted()),
```

This `onPressed` gets called when the player wants to play again at the end of a game.

If you build and run the project you will see no difference yet, but if you check the debug console you will see that `_onGameStarted` got called because the print statement you added before is showing.

[IMAGES]

## Recognizing `LetterKeyPressed`

Now that the game has started, you are going to tackle the `LetterKeyPressed` event. Open `game_bloc.dart` again and add the event handler on the constructor, the end result should look like this:

```dart
GameBloc(this._statsRepository)
    : super(GameState(
        guesses: emptyGuesses(),
      )) {
  on<GameStarted>(_onGameStarted);
  on<LetterKeyPressed>(_onLetterKeyPressed);
}
```

Go ahead and add replace `// TODO: Add logic for LetterKeyPressed` with the following code:

```dart
Future<void> _onLetterKeyPressed(
  LetterKeyPressed event,
  Emitter<GameState> emit,
) async {
  final guesses = addLetterToGuesses(state.guesses, event.letter);

  emit(state.copyWith(
    guesses: guesses,
  ));

  // TODO: check if the game ended.
}
```

With this code, every time you receive a `LetterKeyPressed` event, you will add the letter to the current guesses by checking for the first empty slot and setting its value equal to the letter pressed; this is what `addLetterToGuesses` does. Finally, you emit a new state with the new guesses list and this, in turn, updates the UI via `provider`'s helper `context.watch()`.

Like before, you will need to add the event for `GameBloc` to process it. Open `lib/presentation/widgets/plingo_key.dart` and replace `onTap` with the following code:

```dart
onTap: () => context.read<GameBloc>().add(LetterKeyPressed(letter)),
```

Remember to add the corresponding imports for `flutter_bloc` and `GameBloc` at the top.

Build and run the app. You should be able to use the keyboard to type a couple of words like **CRAVE**, **LINGO** or **MUMMY**; this is will give you a couple of hints about what the five-letter word is and it might look like this:

[IMAGES]

Great job! You have added a second event to the game. But there is one caveat to the current implementation: concurrency. You will tackle this problem next.

## Transforming Events

To make this bug more noticeable open `game_bloc.dart` and change `_onLetterKeyPressed` to emit a state in the future. Don't forget to add the corresponding `import 'dart:math';` at the top of the file. Here's what the end result should look like:

```dart
Future<void> _onLetterKeyPressed(
  LetterKeyPressed event,
  Emitter<GameState> emit,
) async {
  final guesses = addLetterToGuesses(state.guesses, event.letter);

  final randGenerator = Random();
  final shouldHold = randGenerator.nextBool();
  await Future.delayed(Duration(seconds: shouldHold ? 2 : 0), () {
    emit(state.copyWith(
      guesses: guesses,
    ));
  });

  // TODO: check if the game ended.
}
```

Build and run again. Use the keyboard to type **CRAZY**.

[GIF ABOUT CONCURRENCY]

Notice the bug now? `Bloc`s treat events concurrently now instead of doing it sequentially. This means that if an event takes too long to complete, another one might be able to override the changes leading to unexpected behaviors like the one in your app.

`Bloc`s let you define the way to handle events by setting `transformer` in the event handler definition on the constructor.

Normally, defining your own transformer function could become difficult or hard to maintain so you should only do it when required. Luckily, there is a companion library called `bloc_concurrency` containing a set of opinionated transformer functions that allow you to handle events in the way that you want. Here's a small list of the ones included in `bloc_concurrency`:

- `concurrent()`: process events concurrently.
- `sequential()`: process events sequentially.
- `droppable()`: ignore any events added while an event is processing.
- `restartable()`: process only the latest event and cancel previous event handlers.

For this project, `bloc_concurrency` is already added to the `dependencies` in your `pubspec.yaml`, so you can jump straight into using it. Open `game_bloc.dart` and add `import 'package:bloc_concurrency/bloc_concurrency.dart';` at the top of the file; then change the corresponding event handler for `LetterKeyPressed` in the constructor and replace it with the following:

```dart
on<LetterKeyPressed>(_onLetterKeyPressed, transformer: sequential());
```

Using `sequential()` allows you to handle events in a sequence, this will help you avoid events from overriding one another.

Build and run the app again and try to type **CRAZY** again.

[GIF ABOUT SEQUENTIAL ]

As you can see, the events are now processed in the order you add them despite taking some of them taking longer that their predecessor.

Now, it's time you finish adding the last event that `GameBloc` will process. Add the event handler for `GameFinished`, it should look like this:

```dart
on<GameFinished>(_onGameFinished);
```

Then, replace `// TODO: Add logic for GameFinished` with the following code:

```dart
// 1.
Future<void> _onGameFinished(
  GameFinished event,
  Emitter<GameState> emit,
) async {
  // 2.
  await _statsRepository.addGameFinished(hasWon: event.hasWon);
  // 3.
  emit(state.copyWith(
    status: event.hasWon ? GameStatus.success : GameStatus.failure,
  ));
}
```

Here's a quick overview of the code you wrote:

1. Notice that you are using `Future` as a return value for `_onGameFinished` since `Bloc` supports this type of return types.
2. Then, `_statsRepository.addGameFinished` interacts with local storage for updating the different statistics.
3. Finally, you are emitting a new state with the corresponding game result: success for winning or failure for losing.

As a final step, replace `_onLetterKeyPressed` with the following code:

```dart
Future<void> _onLetterKeyPressed(
  LetterKeyPressed event,
  Emitter<GameState> emit,
) async {
  final puzzle = state.puzzle;
  final guesses = addLetterToGuesses(state.guesses, event.letter);

  // 1.
  emit(state.copyWith(
    guesses: guesses,
  ));

  // 2.
  final words = guesses
      .map((guess) => guess.join())
      .where((word) => word.isNotEmpty)
      .toList();

  final hasWon = words.contains(puzzle);
  final hasMaxAttempts = words.length == kMaxGuesses &&
      words.every((word) => word.length == kWordLength);
  if (hasWon || hasMaxAttempts) {
    add(GameFinished(hasWon: hasWon));
  }
}
```

With this code you are doing two things:

1. `emit` is no longer wrapped with a `Future` the way it was before.
2. Determining if the game ended after the guesses have updated, you do this by checking if the user guessed the word puzzle (Plingo's win condition) or if the user reached the max amount of attempts without guessing the word puzzle. If the game meets any of both conditions then you add a new `GameFinished` event.

## Adding a New Cubit

You are almost done with Plingo, but there are a couple more things still missing. Remember the negative numbers shown when opening the `StatsDialog`? You will fix this next.

Open `lib/presentation/cubit/stats_cubit.dart` and add the following functions to `StatsCubit`:

```dart
/// Fetches the current stats of the game.
Future<void> fetchStats() async {
  final stats = await _statsRepository.fetchStats();

  emit(state.copyWith(stats: stats));
}

/// Resets the stats stored.
Future<void> resetStats() async {
  await _statsRepository.resetStats();

  await fetchStats();
}
```

These functions are the way that `StatsCubit` will change the state. First, `fetchStats` retrieves the stats from local storage and emits a change with the updated stats. Then, `resetStats` resets the stats stored locally and then fetches the stats to update the state.

Now you need to call those functions from `StatsDialog`. Open `lib/presentation/widgets/plingo_appbar.dart` and call `fetchStats` with cascade notation on line 63. Here's what the `StatsCubit` definition should look like:

```dart
IconButton(
  onPressed: () => showDialog<void>(
    context: context,
    builder: (dContext) => BlocProvider(
      create: (bContext) => StatsCubit(
        context.read<GameStatsRepository>(),
      )..fetchStats(),
      child: const GameStatsDialog(),
    ),
  ),
  icon: const Icon(Icons.leaderboard_rounded),
)
```

Now open `lib/presentation/dialogs/stats_dialog.dart` and change the line below `// TODO: Reset stats here!` to this:

```dart
onPressed: () => context.read<StatsCubit>().resetStats(),
```

Build and run the app, then tap on the stats icon in the top right corner of the screen to see the stats dialog. You should see the real statistics in the dialog like this:

[IMAGE]

And if you tap on **Reset**, then you should see the stats reset back to zero:

[IMAGE]

## Monitoring a Bloc

Now that the game is functional, you need to start thinking about monitoring your app. A good way of doing this is to pay attention to all the different state changes throughout your app. `bloc` also provides a great way for you to do this with the new `BlocOverrides` API. It allows you to have many `BlocObserver` or `EventTransformer` implementations scoped to different parts of the application; so you could track changes on a specific feature or on the whole app.

Open `lib/monitoring/bloc_monitor.dart` and place the following code into it:

```dart
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' as foundation;

/// [BlocObserver] for the application which
/// observes all state changes.
class BlocMonitor extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    foundation.debugPrint('${bloc.runtimeType} $change');
  }
}
```

`BlocMonitor` is a custom `BlocObserver` that overrides `onChange`; this will help you track all the different state changes and prints them to the console via `debugPrint`. Using this function from `foundation` allows you to only print to the console when the app is been run in debug mode and also makes them available via `flutter logs` command later on.

There's a variety of different `Bloc` hooks that you could track as well. Here's a list of the ones provided:

- `onCreate`: Called whenever you instantiate`Bloc`. Often, a cubit may be lazily instantiated and `onCreate` can observe exactly when the cubit instance is created.
- `onEvent`: Called whenever you add an event to any `Bloc`.
- `onChange`: Called whenever you emit a new state in any `Bloc`. `onChange` gets called before a bloc's state has updates.
- `onTransition`:  Called whenever a transition occurs in any `Bloc`. A transition occurs when you add a new event and then emit a new state from a corresponding `EventHandler`. `onTransition` gets called before a `Bloc`'s state updates.
- `onError`: Called whenever any `Bloc` or `Cubit` throws an error.
- `onClose`: Called whenever a `Bloc` closes. It gets called before the `Bloc` closes and indicates that the particular instance will no longer emit new states.

Alright, continue by opening `main.dart` and replace the contents with the following:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'data.dart';
import 'monitoring/bloc_monitor.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(RepositoryProvider(
      create: (context) => GameStatsRepository(GameStatsSharedPrefProvider()),
      child: const PlingoApp(),
    )),
    blocObserver: BlocMonitor(),
  );
}
```

With this, you are creating a new `BlocMonitor` and tracking all `Bloc`s that run in the zoned override, this means that both `GameBloc` and `StatsCubit` report changes to your `BlocMonitor`.

Build and run your app and check your debug console, you should see logs like the following:

[LOGS Screenshot]

## Where to Go From Here?

Are you wondering where to go next? Take a good look at `bloc`'s [documentation](https://bloclibrary.dev), it's a great place to go when you have any questions. You can also refer to the [library's release notes](https://github.com/felangel/bloc/releases/tag/bloc-v8.0.0) too, since they are full of details and guides for migrating apps from previous versions.

Want to learn more about `bloc` and concurrency? Take a look at this article about [How to use `Bloc` with streams and concurrency written by Joanna May from VeryGoodVentures](https://verygood.ventures/blog/how-to-use-bloc-with-streams-and-concurrency).

Hop into the Flutter desktop hype train with [Flutter Desktop Apps: Getting Started](https://www.raywenderlich.com/21546762-flutter-desktop-apps-getting-started), a great video course by Kevin Moore.
