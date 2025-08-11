const celebrityPairs = [
  {
    pairId: 1,
    description: 'Hollywood actors with similar looks',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Matt_Damon_2019.jpg/300px-Matt_Damon_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Mark_Wahlberg_2018.jpg/300px-Mark_Wahlberg_2018.jpg',
    sameName: 'Matt Damon',
    oddName: 'Mark Wahlberg',
  },
  {
    pairId: 2,
    description: 'Blonde actresses with similar style',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Scarlett_Johansson_2019.jpg/300px-Scarlett_Johansson_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Charlize_Theron_2019.jpg/300px-Charlize_Theron_2019.jpg',
    sameName: 'Scarlett Johansson',
    oddName: 'Charlize Theron',
  },
  {
    pairId: 3,
    description: 'British actors with distinctive looks',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Benedict_Cumberbatch_2019.jpg/300px-Benedict_Cumberbatch_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Tom_Hiddleston_2019.jpg/300px-Tom_Hiddleston_2019.jpg',
    sameName: 'Benedict Cumberbatch',
    oddName: 'Tom Hiddleston',
  },
  {
    pairId: 4,
    description: 'Comedy legends',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Will_Ferrell_2019.jpg/300px-Will_Ferrell_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Steve_Carell_2019.jpg/300px-Steve_Carell_2019.jpg',
    sameName: 'Will Ferrell',
    oddName: 'Steve Carell',
  },
  {
    pairId: 5,
    description: 'Marvel superheroes',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Chris_Evans_2019.jpg/300px-Chris_Evans_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Chris_Hemsworth_2019.jpg/300px-Chris_Hemsworth_2019.jpg',
    sameName: 'Chris Evans',
    oddName: 'Chris Hemsworth',
  },
  {
    pairId: 6,
    description: 'Action movie stars',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Dwayne_Johnson_2019.jpg/300px-Dwayne_Johnson_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Vin_Diesel_2019.jpg/300px-Vin_Diesel_2019.jpg',
    sameName: 'Dwayne Johnson',
    oddName: 'Vin Diesel',
  },
  {
    pairId: 7,
    description: 'Pop music sensations',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Justin_Bieber_2019.jpg/300px-Justin_Bieber_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Shawn_Mendes_2019.jpg/300px-Shawn_Mendes_2019.jpg',
    sameName: 'Justin Bieber',
    oddName: 'Shawn Mendes',
  },
  {
    pairId: 8,
    description: 'Powerful female voices',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Adele_2019.jpg/300px-Adele_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Amy_Winehouse_2007.jpg/300px-Amy_Winehouse_2007.jpg',
    sameName: 'Adele',
    oddName: 'Amy Winehouse',
  },
  {
    pairId: 9,
    description: 'Comedy queens',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Amy_Poehler_2019.jpg/300px-Amy_Poehler_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Tina_Fey_2019.jpg/300px-Tina_Fey_2019.jpg',
    sameName: 'Amy Poehler',
    oddName: 'Tina Fey',
  },
  {
    pairId: 10,
    description: 'Legendary filmmakers',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Steven_Spielberg_2018.jpg/300px-Steven_Spielberg_2018.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/George_Lucas_2019.jpg/300px-George_Lucas_2019.jpg',
    sameName: 'Steven Spielberg',
    oddName: 'George Lucas',
  },
  {
    pairId: 11,
    description: 'Tech innovators',
    sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Mark_Zuckerberg_2019.jpg/300px-Mark_Zuckerberg_2019.jpg',
    oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Elon_Musk_2015.jpg/300px-Elon_Musk_2015.jpg',
    sameName: 'Mark Zuckerberg',
    oddName: 'Elon Musk',
  },
  {
    pairId: 12,
    description: 'Animated movie voices',
    sameImage: 'https://i.pravatar.cc/300?img=15',
    oddImage: 'https://i.pravatar.cc/300?img=25',
    sameName: 'Voice Actor A',
    oddName: 'Voice Actor B',
  },
  {
    pairId: 13,
    description: 'Sports legends',
    sameImage: 'https://i.pravatar.cc/300?img=35',
    oddImage: 'https://i.pravatar.cc/300?img=45',
    sameName: 'Athlete A',
    oddName: 'Athlete B',
  },
  {
    pairId: 14,
    description: 'TV show hosts',
    sameImage: 'https://i.pravatar.cc/300?img=55',
    oddImage: 'https://i.pravatar.cc/300?img=65',
    sameName: 'Host A',
    oddName: 'Host B',
  },
  {
    pairId: 15,
    description: 'Fashion icons',
    sameImage: 'https://i.pravatar.cc/300?img=75',
    oddImage: 'https://i.pravatar.cc/300?img=85',
    sameName: 'Model A',
    oddName: 'Model B',
  }
];

function getCelebrityPair() {
  const randomIndex = Math.floor(Math.random() * celebrityPairs.length);
  return celebrityPairs[randomIndex];
}

module.exports = {
  celebrityPairs,
  getCelebrityPair
};