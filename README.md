# Out of Sync

A Norwegian-language Flutter party-game prototype. Most players receive the
same image, one player receives a different image, and the group discusses
and votes on who is out of sync.

**Status: local UI and game-state prototype; cross-device multiplayer is not
complete.** The host-to-client broadcast path is a placeholder, so the current
code must not be presented as a working multiplayer release.

## Repository layout

The Flutter project is inside **`out_of_sync/`**, not the repository root.
Run Flutter commands from that directory.

```text
out_of_sync/
  lib/main.dart          Entry point, shared imports, and app shell
  lib/src/               Theme, widgets, image selection, game state,
                         networking, and screens
  test/                  Game/image-selection and widget regression tests
  assets/images/         Asset notes and legacy example pair data
  android/, ios/, ...    Native/platform scaffolding
  pubspec.yaml           Dependencies and asset configuration
  pubspec.lock           Committed dependency resolution
```

## Setup

Install a Flutter SDK that bundles **Dart 3.8.1 or later, below 4.0**, matching
`pubspec.yaml`. Use the [official Flutter setup instructions](https://docs.flutter.dev/get-started/install)
for your host and target platform.

```bash
git clone git@github.com:AugustLind/OutOfSync.git
cd OutOfSync/out_of_sync
flutter doctor
flutter pub get
flutter devices
flutter run -d <device-id>
```

Replace `<device-id>` with a device listed by `flutter devices`. Repository
access is required while the project is private. Use a native device/emulator;
the current source imports `dart:io` and raw sockets, so the included web
scaffolding does not establish browser support.

The package and native identifiers retain the historical spelling
`out_of_symc` / `com.example.out_of_symc`. Visible Android/iOS display names use
**Out of Sync**. Renaming installed application identifiers is a separate change;
Dart test imports intentionally use `package:out_of_symc/...`.

## Current features

- Name entry and host/join/lobby screens.
- Odd-player selection, reveal, ready-to-vote state, and local voting state.
- Norwegian UI with Cupertino-style controls.
- Hardcoded celebrity/lookalike image pairs, remote placeholder images, and
  custom image selection through the platform picker.

Game state, custom-image selections, and settings are held in memory. There
is no account backend, durable game storage, or cloud synchronization.

## Multiplayer limitations

The networking prototype uses **UDP 8888** for discovery and **TCP 8889** for
messages. It needs completion and multi-device testing:

- Discovery currently binds to loopback rather than a suitable LAN listener.
- The host does not maintain a client collection or broadcast state to clients.
- TCP reads assume one JSON message per socket event; framing is not implemented.
- Player-list synchronization, join/disconnect handling, asynchronous errors,
  and lifecycle transitions need further work.
- Messages have no authentication or encryption. The game code is not a
  security credential. Keep development on a trusted local network.

Image paths selected on one device are not transferred to other devices.
Custom-image multiplayer therefore also needs an image-sharing strategy.
Same-Wi-Fi labels in the UI describe intended behavior, not verified operation.

Before using native plugins on Apple platforms, review the required photo-library
and local-network usage descriptions/permissions. macOS sandbox network
entitlements also need review. Android release configuration still uses the
template debug signing setup; it is not store-release configuration.

## Images and assets

Image pairs currently come from `ImageManager` in
[image_manager.dart](out_of_sync/lib/src/image_manager.dart), not from
`assets/images/similar_people/image_pairs.json`. That JSON is legacy sample
material and is not loaded by the app.

The Animals, Objects, People, and Colors categories currently use the same
remote placeholders; adding files with category-like names does not register
them automatically. Custom images are selected with the picker and kept as
local paths for the running session.

Remote images need internet access and may be unavailable or replaced upstream.
Review image sources, permissions, and attribution before distributing the app.
There is no bundled, verified offline image collection. See the
[asset notes](out_of_sync/assets/images/placeholder_info.md) before extending it.

## Source organization

The former large `main.dart` has been split into Dart `part` files under
`lib/src/`. They remain one library so existing private state handlers and
cross-screen references keep their visibility. Imports belong in `main.dart`;
part files use `part of '../main.dart';`.

| File | Responsibility |
|---|---|
| `app_theme.dart`, `ios_widgets.dart` | Styling and shared controls |
| `image_manager.dart` | Categories, image pairs, and custom-image choices |
| `network_manager.dart` | UDP discovery and TCP prototype |
| `game.dart` | Game discovery record and observable game state |
| `home_page.dart`, `lobby_page.dart` | Entry and lobby screens |
| `game_page.dart` | Image reveal, readiness, and voting screen |
| `image_settings_page.dart` | Image category and picker UI |

## Checks

From `out_of_sync/`:

```bash
flutter pub get
flutter analyze
flutter test
```

The added tests cover distinct image choices, duplicate/single-image edge
cases, custom-image lists, local readiness/voting, and the home screen. They do
not establish working LAN multiplayer or native plugin permissions.

The cleanup environment had no Flutter/Dart SDK, so analyzer, Flutter tests,
and device builds were **not run**. Source-extraction preservation, part paths,
YAML/JSON/XML structure, and ignore rules were checked separately. Run Flutter
checks and test on real target devices before treating this cleanup as verified
application behavior.

## Next priorities

1. Complete and test framed TCP messaging and host/client synchronization.
2. Implement LAN discovery and proper reconnect/disconnect handling.
3. Replace remote placeholder data with a reliable image catalog and attribution.
4. Validate native permissions and release signing for intended targets.
5. Decide on a project license before presenting the code as reusable software;
   no project-wide license is currently provided.
