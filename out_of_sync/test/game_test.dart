import 'package:flutter_test/flutter_test.dart';
import 'package:out_of_symc/main.dart';

void main() {
  setUp(() {
    for (final image in ImageManager.getCustomImages().toList()) {
      ImageManager.removeCustomImage(image);
    }
    ImageManager.setCategory(ImageCategory.animals);
  });

  test('fallback pairs always contain distinct images', () async {
    for (var i = 0; i < 100; i++) {
      final pair = await ImageManager.getCelebrityPair();
      expect(pair['same'], isNot(pair['odd']));
    }
  });

  test('duplicate or single-image collections still produce a distinct odd image', () {
    expect(ImageManager.getOddImage(['same', 'same'], 'same'), isNot('same'));
    expect(ImageManager.getOddImage(['same'], 'same'), isNot('same'));
    expect(ImageManager.getOddImage([], 'same'), isNot('same'));
    expect(ImageManager.getOddImage(['same', 'other'], 'same'), 'other');
  });

  test('custom images are deduplicated and can be removed', () async {
    await ImageManager.addCustomImage('/local/example.jpg');
    await ImageManager.addCustomImage('/local/example.jpg');
    ImageManager.setCategory(ImageCategory.custom);
    expect(await ImageManager.getAvailableImages(), ['/local/example.jpg']);
    ImageManager.removeCustomImage('/local/example.jpg');
    expect(await ImageManager.getAvailableImages(), ImageManager.defaultImages);
  });

  test('local game state deduplicates players and waits for everyone to be ready', () {
    final game = Game(code: 'TEST', hostName: 'Host');
    addTearDown(game.dispose);
    game.addPlayer('Guest');
    game.addPlayer('Guest');
    expect(game.players, ['Host', 'Guest']);
    game.readyToVote('Host');
    expect(game.votingStarted, isFalse);
    game.readyToVote('Guest');
    expect(game.votingStarted, isTrue);
  });

  test('local voting produces a result after every player votes', () {
    final game = Game(code: 'TEST', hostName: 'Host');
    addTearDown(game.dispose);
    game.addPlayer('Guest');
    game.vote('Host', 'Guest');
    expect(game.voteResult, isNull);
    game.vote('Guest', 'Guest');
    expect(game.voteResult, 'Guest');
  });
}
