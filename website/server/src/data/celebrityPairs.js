const celebrityPairs = [
  {
    "pairId": 1,
    "description": "Hollywood A-listers",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/wo2hJpn04vbtmh0B9utCFdsQhxM.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/cckcYc2v0yh1tc9QjRelptcOBko.jpg",
    "sameName": "Leonardo DiCaprio",
    "oddName": "Brad Pitt"
  },
  {
    "pairId": 2,
    "description": "Pop superstars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/Ia3dzj7kJdvsT19ynAG8bJkDVPu.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/r3vBjPyuMCBQ0Y0x3IqVcZRzweO.jpg",
    "sameName": "Taylor Swift",
    "oddName": "Ariana Grande"
  },
  {
    "pairId": 3,
    "description": "Marvel heroes",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/im9SAqJPZKEbVZGmjXuLI4jIQem.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/3bOGNsHlrswhyW79uvIHH1V43JI.jpg",
    "sameName": "Robert Downey Jr.",
    "oddName": "Chris Evans"
  },
  {
    "pairId": 4,
    "description": "Action stars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/kuqFzlYMc2IrsOyPznMd1FroeGq.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/eOh4ubpOm2Igdg0QH2ghj0mFtC.jpg",
    "sameName": "Dwayne Johnson",
    "oddName": "Tom Cruise"
  },
  {
    "pairId": 5,
    "description": "Comedy legends",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/j1VdmftAir0hdeWKadDuIpfmWFd.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/h1tuwPONorCelQceEUVdiCACnQO.jpg",
    "sameName": "Will Smith",
    "oddName": "Kevin Hart"
  },
  {
    "pairId": 6,
    "description": "Oscar winners",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/qJr5JcIhb2qb7yrpJsOFpBcgJMa.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/wqEypkRUUZEcFmPV4O4JpZznmNk.jpg",
    "sameName": "Jennifer Lawrence",
    "oddName": "Emma Stone"
  },
  {
    "pairId": 7,
    "description": "Music icons",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/kJpPJOKS6YvQz0dYWjRVPu7UiM2.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/ehg6Zo1tDgD3dPgqxfHAr6xdQAM.jpg",
    "sameName": "Beyoncé",
    "oddName": "Rihanna"
  },
  {
    "pairId": 8,
    "description": "Young stars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/yBcwJRZB3Kb0pOKVZHb6p9tbczU.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/xdnstENLdWMPWt9qyhtf695L4t6.jpg",
    "sameName": "Zendaya",
    "oddName": "Tom Holland"
  },
  {
    "pairId": 9,
    "description": "Netflix stars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/pM15j4QQU8oUxVAFmRh4ghFCOOB.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/h8RlQyBkqy7wG1jwgLo3xaslA4D.jpg",
    "sameName": "Millie Bobby Brown",
    "oddName": "Finn Wolfhard"
  },
  {
    "pairId": 10,
    "description": "DC heroes",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/cGOPbv9wA5gEejkUN892JrveARt.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/eLB8z8jdJOKXGAWZTmsMzJagTZm.jpg",
    "sameName": "Henry Cavill",
    "oddName": "Gal Gadot"
  },
  {
    "pairId": 11,
    "description": "Horror icons",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/3KhcVdxGNHWJbILQvJm0v9jTRwg.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/rCj6n4yY12M2aX8n2iVOJ60aGg.jpg",
    "sameName": "Jamie Lee Curtis",
    "oddName": "Neve Campbell"
  },
  {
    "pairId": 12,
    "description": "Streaming giants",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/ywNEKJi7oXJzrr8wHSAVcMnLqWv.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/9cUrSV5S1J8IVyZPuRNLnpIBUfQ.jpg",
    "sameName": "Ryan Reynolds",
    "oddName": "Ryan Gosling"
  },
  {
    "pairId": 13,
    "description": "Fashion icons",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/o08MSs9gWAMBg9sJM7m0kbHAVJz.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/dQx8kHSoHhIc6HwGnRUZnPSHPD1.jpg",
    "sameName": "Margot Robbie",
    "oddName": "Scarlett Johansson"
  },
  {
    "pairId": 14,
    "description": "British legends",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/uexxgOtudXQNTvTbckTCkBfDnF6.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/6aCJBVoH7yHN7PxbRSK8q8pTX9f.jpg",
    "sameName": "Benedict Cumberbatch",
    "oddName": "Daniel Craig"
  },
  {
    "pairId": 15,
    "description": "Rising stars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/hJhCOUUKhPtUhEWgppqGFsO7zSm.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/z3mKDSJ9v4f2y2yVwXG6d3s22kS.jpg",
    "sameName": "Timothée Chalamet",
    "oddName": "Austin Butler"
  },
  {
    "pairId": 16,
    "description": "Acclaimed directors",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/1gjcpKc_I2a43sZ2i_Q6e13I05w.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/3U2w4S06yv7Y3SAb33SgMMNbS4m.jpg",
    "sameName": "Quentin Tarantino",
    "oddName": "Christopher Nolan"
  },
  {
    "pairId": 17,
    "description": "'Friends' stars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/uHht2L1Umsc3a9e4I2wnRS2v35A.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/24LdE51H2Vw3Wt1n5dM2iP03g3a.jpg",
    "sameName": "Jennifer Aniston",
    "oddName": "Courteney Cox"
  },
  {
    "pairId": 18,
    "description": "Musical collaborators",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/4o813i5c0zPAbI90iW2GzTviRVO.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/i7dM4i3CS56dW2g7m2Vj2S4cwvd.jpg",
    "sameName": "Ed Sheeran",
    "oddName": "Justin Bieber"
  },
  {
    "pairId": 19,
    "description": "Spanish power couple",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/8iEW2n2h79fFj25T3cfIeP0t5qG.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/k66t8Kke2a5iA02s0f6C76w1yvT.jpg",
    "sameName": "Penélope Cruz",
    "oddName": "Javier Bardem"
  },
  {
    "pairId": 20,
    "description": "Norwegian actors",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/g23vCS2gHIRyO1QYd5kvL1E2L2c.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/342jI4P0Dgi52Gc1gTmXg4pEaTU.jpg",
    "sameName": "Kristofer Hivju",
    "oddName": "Aksel Hennie"
  },
  {
    "pairId": 21,
    "description": "'The Worst Person in the World' co-stars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/9n21d5Icj2yvKz2Gzoce2x23T1M.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/hW2r9Zp3a9wLgPlhI3rXwAhkZFP.jpg",
    "sameName": "Renate Reinsve",
    "oddName": "Anders Danielsen Lie"
  },
  {
    "pairId": 22,
    "description": "Norwegian DJs",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/p0Ojj53fS2gVzP1k821UfBfqGv9.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/s9e3UE2ihT3wP629r5u8Yp5WpD8.jpg",
    "sameName": "Kygo",
    "oddName": "Alan Walker"
  },
  {
    "pairId": 23,
    "description": "Scandinavian actors",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/72mqfb6b3c0H2a5H6mFp2hCfuDk.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/hOUA6s2Hg9unQ7sT1qT3h2S2YpU.jpg",
    "sameName": "Mads Mikkelsen",
    "oddName": "Pål Sverre Hagen"
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