const celebrityPairs = [
  {
    pairId: 1,
    description: 'Hollywood A-listers',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/wo2hJpn04vbtmh0B9utCFdsQhxM.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/cckcYc2v0yh1tc9QjRelptcOBko.jpg',
    sameName: 'Leonardo DiCaprio',
    oddName: 'Brad Pitt',
  },
  {
    pairId: 2,
    description: 'Pop superstars',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/Ia3dzj7kJdvsT19ynAG8bJkDVPu.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/r3vBjPyuMCBQ0Y0x3IqVcZRzweO.jpg',
    sameName: 'Taylor Swift',
    oddName: 'Ariana Grande',
  },
  {
    pairId: 3,
    description: 'Marvel heroes',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/im9SAqJPZKEbVZGmjXuLI4jIQem.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/3bOGNsHlrswhyW79uvIHH1V43JI.jpg',
    sameName: 'Robert Downey Jr.',
    oddName: 'Chris Evans',
  },
  {
    pairId: 4,
    description: 'Action stars',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/kuqFzlYMc2IrsOyPznMd1FroeGq.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/eOh4ubpOm2Igdg0QH2ghj0mFtC.jpg',
    sameName: 'Dwayne Johnson',
    oddName: 'Tom Cruise',
  },
  {
    pairId: 5,
    description: 'Comedy legends',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/j1VdmftAir0hdeWKadDuIpfmWFd.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/h1tuwPONorCelQceEUVdiCACnQO.jpg',
    sameName: 'Will Smith',
    oddName: 'Kevin Hart',
  },
  {
    pairId: 6,
    description: 'Oscar winners',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/qJr5JcIhb2qb7yrpJsOFpBcgJMa.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/wqEypkRUUZEcFmPV4O4JpZznmNk.jpg',
    sameName: 'Jennifer Lawrence',
    oddName: 'Emma Stone',
  },
  {
    pairId: 7,
    description: 'Music icons',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/kJpPJOKS6YvQz0dYWjRVPu7UiM2.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/ehg6Zo1tDgD3dPgqxfHAr6xdQAM.jpg',
    sameName: 'Beyoncé',
    oddName: 'Rihanna',
  },
  {
    pairId: 8,
    description: 'Young stars',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/yBcwJRZB3Kb0pOKVZHb6p9tbczU.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/xdnstENLdWMPWt9qyhtf695L4t6.jpg',
    sameName: 'Zendaya',
    oddName: 'Tom Holland',
  },
  {
    pairId: 9,
    description: 'Netflix stars',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/pM15j4QQU8oUxVAFmRh4ghFCOOB.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/h8RlQyBkqy7wG1jwgLo3xaslA4D.jpg',
    sameName: 'Millie Bobby Brown',
    oddName: 'Finn Wolfhard',
  },
  {
    pairId: 10,
    description: 'DC heroes',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/cGOPbv9wA5gEejkUN892JrveARt.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/eLB8z8jdJOKXGAWZTmsMzJagTZm.jpg',
    sameName: 'Henry Cavill',
    oddName: 'Gal Gadot',
  },
  {
    pairId: 11,
    description: 'Horror icons',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/3KhcVdxGNHWJbILQvJm0v9jTRwg.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/dTJYUUC5PzFj2ZhWvYmkL0YfI3d.jpg',
    sameName: 'Jamie Lee Curtis',
    oddName: 'Scream Queen',
  },
  {
    pairId: 12,
    description: 'Streaming giants',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/ywNEKJi7oXJzrr8wHSAVcMnLqWv.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/9cUrSV5S1J8IVyZPuRNLnpIBUfQ.jpg',
    sameName: 'Ryan Reynolds',
    oddName: 'Ryan Gosling',
  },
  {
    pairId: 13,
    description: 'Fashion icons',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/o08MSs9gWAMBg9sJM7m0kbHAVJz.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/dQx8kHSoHhIc6HwGnRUZnPSHPD1.jpg',
    sameName: 'Margot Robbie',
    oddName: 'Scarlett Johansson',
  },
  {
    pairId: 14,
    description: 'British legends',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/uexxgOtudXQNTvTbckTCkBfDnF6.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/6aCJBVoH7yHN7PxbRSK8q8pTX9f.jpg',
    sameName: 'Benedict Cumberbatch',
    oddName: 'Daniel Craig',
  },
  {
    pairId: 15,
    description: 'Rising stars',
    sameImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/hJhCOUUKhPtUhEWgppqGFsO7zSm.jpg',
    oddImage: 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/tKxh3UiTwKWBW8fMr6kJu7sRbhQ.jpg',
    sameName: 'Timothée Chalamet',
    oddName: 'Michael Cera',
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