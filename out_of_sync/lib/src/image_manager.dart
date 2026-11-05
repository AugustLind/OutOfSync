part of '../main.dart';

enum ImageCategory {
  animals('Dyr', 'assets/images/animals/'),
  objects('Objekter', 'assets/images/objects/'),
  people('Personer', 'assets/images/people/'),
  similarPeople('Like personer', 'assets/images/similar_people/'),
  colors('Farger', 'assets/images/colors/'),
  custom('Egne bilder', '');

  const ImageCategory(this.displayName, this.assetPath);
  final String displayName;
  final String assetPath;
}

class CelebrityPair {
  final int pairId;
  final String description;
  final String sameImage;
  final String oddImage;
  final String sameName;
  final String oddName;
  
  CelebrityPair({
    required this.pairId,
    required this.description,
    required this.sameImage,
    required this.oddImage,
    required this.sameName,
    required this.oddName,
  });
  
  factory CelebrityPair.fromJson(Map<String, dynamic> json) {
    return CelebrityPair(
      pairId: json['pair_id'],
      description: json['description'],
      sameImage: json['same_image'],
      oddImage: json['odd_image'],
      sameName: json['same_name'],
      oddName: json['odd_name'],
    );
  }
}

class ImageManager {
  static const List<String> defaultImages = [
    'https://i.pravatar.cc/300?img=1',
    'https://i.pravatar.cc/300?img=2',
    'https://i.pravatar.cc/300?img=3',
    'https://i.pravatar.cc/300?img=4',
    'https://i.pravatar.cc/300?img=5',
  ];

  static final List<CelebrityPair> _celebrityPairs = [
    CelebrityPair(
      pairId: 1,
      description: 'Norske TV-profiler - lignende ansiktstrekk',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Fredrik_Solvang_2019.jpg/300px-Fredrik_Solvang_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Daniel_Choi_2020.jpg/300px-Daniel_Choi_2020.jpg',
      sameName: 'Fredrik Solvang',
      oddName: 'Daniel Choi',
    ),
    CelebrityPair(
      pairId: 2,
      description: 'Hollywood skuespillere - lignende profil',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Matt_Damon_2019.jpg/300px-Matt_Damon_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Mark_Wahlberg_2018.jpg/300px-Mark_Wahlberg_2018.jpg',
      sameName: 'Matt Damon',
      oddName: 'Mark Wahlberg',
    ),
    CelebrityPair(
      pairId: 3,
      description: 'Blonde skuespillerinner - samme hårfarge',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Scarlett_Johansson_2019.jpg/300px-Scarlett_Johansson_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Charlize_Theron_2019.jpg/300px-Charlize_Theron_2019.jpg',
      sameName: 'Scarlett Johansson',
      oddName: 'Charlize Theron',
    ),
    CelebrityPair(
      pairId: 4,
      description: 'Britiske skuespillere - same stil',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Benedict_Cumberbatch_2019.jpg/300px-Benedict_Cumberbatch_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Tom_Hiddleston_2019.jpg/300px-Tom_Hiddleston_2019.jpg',
      sameName: 'Benedict Cumberbatch',
      oddName: 'Tom Hiddleston',
    ),
    CelebrityPair(
      pairId: 5,
      description: 'Amerikanske komikere - lignende utseende',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Will_Ferrell_2019.jpg/300px-Will_Ferrell_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Steve_Carell_2019.jpg/300px-Steve_Carell_2019.jpg',
      sameName: 'Will Ferrell',
      oddName: 'Steve Carell',
    ),
    CelebrityPair(
      pairId: 6,
      description: 'Marvel-skuespillere - helteansikt',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Chris_Evans_2019.jpg/300px-Chris_Evans_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Chris_Hemsworth_2019.jpg/300px-Chris_Hemsworth_2019.jpg',
      sameName: 'Chris Evans',
      oddName: 'Chris Hemsworth',
    ),
    CelebrityPair(
      pairId: 7,
      description: 'Actionstjerner - tøffe uttrykk',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Dwayne_Johnson_2019.jpg/300px-Dwayne_Johnson_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Vin_Diesel_2019.jpg/300px-Vin_Diesel_2019.jpg',
      sameName: 'Dwayne Johnson',
      oddName: 'Vin Diesel',
    ),
    CelebrityPair(
      pairId: 8,
      description: 'Pop-artister - unge stjerner',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Justin_Bieber_2019.jpg/300px-Justin_Bieber_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Shawn_Mendes_2019.jpg/300px-Shawn_Mendes_2019.jpg',
      sameName: 'Justin Bieber',
      oddName: 'Shawn Mendes',
    ),
    CelebrityPair(
      pairId: 9,
      description: 'Kvinnelige sangere - kraftige stemmer',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Adele_2019.jpg/300px-Adele_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Amy_Winehouse_2007.jpg/300px-Amy_Winehouse_2007.jpg',
      sameName: 'Adele',
      oddName: 'Amy Winehouse',
    ),
    CelebrityPair(
      pairId: 10,
      description: 'Norske artister - folkemusikk',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Ari_Behn_2015.jpg/300px-Ari_Behn_2015.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Lars_Winnerbäck_2018.jpg/300px-Lars_Winnerbäck_2018.jpg',
      sameName: 'Ari Behn',
      oddName: 'Lars Winnerbäck',
    ),
    CelebrityPair(
      pairId: 11,
      description: 'Fotballspillere - norske helter',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Martin_Ødegaard_2021.jpg/300px-Martin_Ødegaard_2021.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Erling_Haaland_2021.jpg/300px-Erling_Haaland_2021.jpg',
      sameName: 'Martin Ødegaard',
      oddName: 'Erling Haaland',
    ),
    CelebrityPair(
      pairId: 12,
      description: 'Norske skuespillere - kjente ansikter',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Aksel_Hennie_2019.jpg/300px-Aksel_Hennie_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Nikolaj_Coster-Waldau_2019.jpg/300px-Nikolaj_Coster-Waldau_2019.jpg',
      sameName: 'Aksel Hennie',
      oddName: 'Nikolaj Coster-Waldau',
    ),
    CelebrityPair(
      pairId: 13,
      description: 'Kvinnelige komikere - morsomme damer',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Amy_Poehler_2019.jpg/300px-Amy_Poehler_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Tina_Fey_2019.jpg/300px-Tina_Fey_2019.jpg',
      sameName: 'Amy Poehler',
      oddName: 'Tina Fey',
    ),
    CelebrityPair(
      pairId: 14,
      description: 'Regissører - filmskapere',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Steven_Spielberg_2018.jpg/300px-Steven_Spielberg_2018.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/George_Lucas_2019.jpg/300px-George_Lucas_2019.jpg',
      sameName: 'Steven Spielberg',
      oddName: 'George Lucas',
    ),
    CelebrityPair(
      pairId: 15,
      description: 'Tech-gründere - teknologiledere',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Mark_Zuckerberg_2019.jpg/300px-Mark_Zuckerberg_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Elon_Musk_2015.jpg/300px-Elon_Musk_2015.jpg',
      sameName: 'Mark Zuckerberg',
      oddName: 'Elon Musk',
    ),
  ];

  static List<String> _customImages = [];
  static ImageCategory _selectedCategory = ImageCategory.similarPeople;

  static ImageCategory get selectedCategory => _selectedCategory;
  static void setCategory(ImageCategory category) {
    _selectedCategory = category;
  }

  static Future<List<String>> getAvailableImages() async {
    switch (_selectedCategory) {
      case ImageCategory.similarPeople:
        // Return all images from similar pairs for random selection
        final List<String> allImages = [];
        for (final pair in _celebrityPairs) {
          allImages.add(pair.sameImage);
          allImages.add(pair.oddImage);
        }
        return allImages;
      case ImageCategory.custom:
        return _customImages.isNotEmpty ? _customImages : defaultImages;
      default:
        // For other categories, return default images
        return defaultImages;
    }
  }

  static Future<Map<String, String>> getCelebrityPair() async {
    if (_selectedCategory == ImageCategory.similarPeople && _celebrityPairs.isNotEmpty) {
      final selectedPair = _celebrityPairs[Random().nextInt(_celebrityPairs.length)];
      return {
        'same': selectedPair.sameImage,
        'odd': selectedPair.oddImage,
        'same_name': selectedPair.sameName,
        'odd_name': selectedPair.oddName,
        'description': selectedPair.description,
      };
    }
    // Fallback to random selection
    final images = await getAvailableImages();
    final sameImage = getRandomImage(images);
    return {
      'same': sameImage,
      'odd': getOddImage(images, sameImage),
      'same_name': 'Ukjent',
      'odd_name': 'Ukjent',
      'description': 'Random selection',
    };
  }

  static Future<void> addCustomImage(String imagePath) async {
    if (!_customImages.contains(imagePath)) {
      _customImages.add(imagePath);
    }
  }

  static List<String> getCustomImages() => _customImages;

  static void removeCustomImage(String imagePath) {
    _customImages.remove(imagePath);
  }

  static String getRandomImage(List<String> images) {
    if (images.isEmpty) return defaultImages.first;
    return images[Random().nextInt(images.length)];
  }

  static String getOddImage(List<String> images, String sameImage) {
    final alternatives = images.where((image) => image != sameImage).toSet().toList();
    if (alternatives.isEmpty) {
      return defaultImages.firstWhere((image) => image != sameImage);
    }
    return alternatives[Random().nextInt(alternatives.length)];
  }

  static List<CelebrityPair> getCelebrityPairs() => _celebrityPairs;
}
