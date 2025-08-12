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
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/bC4d0I4nNOy5oU5A1b2Vf0m5p2s.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/yCiEf4sNCws9g2G3bXT4Jq02Ek3.jpg",
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
    "description": "The Two Ryans",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/4SYq1623yvs9T1Tq9v9yv942IQP.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/9cUrSV5S1J8IVyZPuRNLnpIBUfQ.jpg",
    "sameName": "Ryan Reynolds",
    "oddName": "Ryan Gosling"
  },
  {
    "pairId": 13,
    "description": "Fashion icons",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/o08MSs9gWAMBg9sJM7m0kbHAVJz.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/6p2tFwmyk2LgA0M5Yy3W7aK3sY2.jpg",
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
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/iN4dSoO1JLE2pT12D321p48l1s.jpg",
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
  },
  {
    "pairId": 24,
    "description": "The Two Chrises",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/cMD9Ygz11zjJzAovURpO75Qg7rT.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/xnopI5Xtky18MPhK40cZAGAOVeV.jpg",
    "sameName": "Chris Hemsworth",
    "oddName": "Chris Pratt"
  },
  {
    "pairId": 25,
    "description": "Korean superstars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/jSkGS6IHRhwZqPKCwxn8gUrCHH3.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/je3HUhfGTyWpX8IzL2hiCul8pLA.jpg",
    "sameName": "Park Seo-joon",
    "oddName": "Son Heung-min"
  },
  {
    "pairId": 26,
    "description": "'Barbie' stars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/o08MSs9gWAMBg9sJM7m0kbHAVJz.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/9cUrSV5S1J8IVyZPuRNLnpIBUfQ.jpg",
    "sameName": "Margot Robbie",
    "oddName": "Ryan Gosling"
  },
  {
    "pairId": 27,
    "description": "Billionaire tech titans",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/rFkN0r3apV5fPjpKYdF6gBXhGRU.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/vOo2Q0K6T7O5gYYIyzLNxjc2Voz.jpg",
    "sameName": "Elon Musk",
    "oddName": "Jeff Bezos"
  },
  {
    "pairId": 28,
    "description": "Legendary comedians",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/uKHEpHSuvJgVLETrU0BxcaorySE.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/oo8IeDY2sl1g2MDfNgOFh8J1neT.jpg",
    "sameName": "Eddie Murphy",
    "oddName": "Jim Carrey"
  },
  {
    "pairId": 29,
    "description": "Tennis legends",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/iZ6mAd1pDmMa3lBuJSQV5bfYizh.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/qsYMCcJznZQSIxJSgvHwcBW9KyC.jpg",
    "sameName": "Serena Williams",
    "oddName": "Venus Williams"
  },
  {
    "pairId": 30,
    "description": "Soccer superstars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/b0G4Rk0JDBx1yJsFEpm2XjRRVvT.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/tO7nD6MH7H8fZ8ekPxsQ3d0Pcbz.jpg",
    "sameName": "Lionel Messi",
    "oddName": "Cristiano Ronaldo"
  },
  {
    "pairId": 31,
    "description": "Female rap queens",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/5m9njwZqRDvW6VxI2fN1ae5Zkha.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/3A15l2PcAshSBjiFwD76KkKJcyO.jpg",
    "sameName": "Nicki Minaj",
    "oddName": "Cardi B"
  },
  {
    "pairId": 32,
    "description": "The Hemsworths",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/cMD9Ygz11zjJzAovURpO75Qg7rT.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/eybN4AxwRJ3O8wEM7WoaHRJPV5g.jpg",
    "sameName": "Chris Hemsworth",
    "oddName": "Liam Hemsworth"
  },
  {
    "pairId": 33,
    "description": "Vintage Hollywood",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/qW5vtrj97slKOMwU5VUEQwEqnHL.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/h2xRo1eyN1p8gNYRjhAraqp5IKz.jpg",
    "sameName": "Marilyn Monroe",
    "oddName": "Audrey Hepburn"
  },
  {
    "pairId": 34,
    "description": "K-pop idols",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/a7pJj0KfrXEY6XhauhdGuf3Yx8L.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/rD8aaIyXnJJy7CDdqFnJ9vt3Ksf.jpg",
    "sameName": "Lisa (BLACKPINK)",
    "oddName": "Jennie (BLACKPINK)"
  },
  {
    "pairId": 35,
    "description": "Streaming era artists",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/aSvHDpJvMv5D9z2sSu0gz9VzIgL.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/oTdzKvU2pKPJOSMPdtCW7wAcZfV.jpg",
    "sameName": "Billie Eilish",
    "oddName": "Olivia Rodrigo"
  },
  {
    "pairId": 36,
    "description": "WWE superstars",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/yv7n3Tyn3CnmShd8xIcrUOJaLEu.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/cgoy7t5Ve075naBPcewZrc08qGw.jpg",
    "sameName": "John Cena",
    "oddName": "Dave Bautista"
  },
  {
    "pairId": 37,
    "description": "Late night hosts",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/gYkKrpbSzyP1L8jKJ8qBDDBqpxN.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/u6AMJ3q7OSXJ5asGPtsAIJZY1Bb.jpg",
    "sameName": "Jimmy Fallon",
    "oddName": "Jimmy Kimmel"
  },
  {
    "pairId": 38,
    "description": "Sci-fi icons",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/mh1z9Ay5u9ScIwJfmP6TitdZ6N8.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/cmclOgRkkepSNBhJGVKlWq2Bgjr.jpg",
    "sameName": "Harrison Ford",
    "oddName": "Mark Hamill"
  },
  {
    "pairId": 39,
    "description": "Gen Z icons",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/k3W1XXddDOH2zibPkNotIh5amHo.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/8YI1IMMX1vRPfHwLAixPadlKJJj.jpg",
    "sameName": "Charli D'Amelio",
    "oddName": "Addison Rae"
  },
  {
    "pairId": 40,
    "description": "Formula 1 champions",
    "sameImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/2ts1JkL9pM7Qoh3jRu8Pr93Xqko.jpg",
    "oddImage": "https://www.themoviedb.org/t/p/w300_and_h450_bestv2/vg1HvgCL8fJyV9l0CgEA4fzMcoK.jpg",
    "sameName": "Lewis Hamilton",
    "oddName": "Max Verstappen"
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