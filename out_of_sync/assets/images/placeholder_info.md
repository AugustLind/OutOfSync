# Image assets: current behavior

The app currently selects image pairs from the hardcoded list in
[`ImageManager`](../../lib/src/image_manager.dart). It does not enumerate
category folders or load `similar_people/image_pairs.json` at runtime.

- Similar People uses the hardcoded remote celebrity/lookalike pairs.
- Animals, Objects, People, and Colors currently use shared remote placeholders.
- Custom images are chosen through the platform picker and kept as local paths
  for the session. Files are not transferred to other players or persisted.

The JSON file is legacy example material, not a supported image catalog.
Adding `animals_1.jpg` or another category-like filename does not register it.
To add bundled assets, update both the selection code and `pubspec.yaml` with
the actual files/subdirectories, then test on the intended platform.

Prefer reliably hosted or bundled images with known sources, permissions, and
attribution. The current remote URLs and example JSON are not a verified media
collection. Device-local paths are unsuitable for cross-device play without an
explicit image-transfer mechanism.
