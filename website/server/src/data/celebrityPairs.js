const apiKey = '68bbae5435ef0a5d327177f781201b93';
const baseImageUrl = 'https://image.tmdb.org/t/p/w300_and_h450_bestv2';

const celebrityPairs = [
  {
    "pairId": 1,
    "description": "Hollywood A-listers",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/wo2hJpn04vbtmh0B9utCFdsQhxM.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/cckcYc2v0yh1tc9QjRelptcOBko.jpg",
    "sameName": "Leonardo DiCaprio",
    "oddName": "Brad Pitt"
  },
  {
    "pairId": 2,
    "description": "Pop superstars",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/1mYLjd2LQlN5Ok5Yr5LZJdJU2Jz.jpg",  // Taylor Swift - updated to a valid TMDb profile image
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/1YjdSym1jTG7xjHSI0yGGWEsw5i.jpg",  // Ariana Grande (original, valid)
    "sameName": "Taylor Swift",
    "oddName": "Ariana Grande"
  },
  {
    "pairId": 3,
    "description": "Marvel heroes",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/5qHNjhtjMD4YWH3UP0rm4tKwxCL.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/3bOGNsHlrswhyW79uvIHH1V43JI.jpg",
    "sameName": "Robert Downey Jr.",
    "oddName": "Chris Evans"
  },
  {
    "pairId": 4,
    "description": "Action stars",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/kuqFzlYMc2IrsOyPznMd1FroeGq.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/eOh4ubpOm2Igdg0QH2ghj0mFtC.jpg",
    "sameName": "Dwayne Johnson",
    "oddName": "Tom Cruise"
  },
  {
    "pairId": 5,
    "description": "Comedy legends",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/j1VdmftAir0hdeWKadDuIpfmWFd.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/2qhIDp44cAqP2clOgt2afQI07X8.jpg",  // Kevin Hart - fixed
    "sameName": "Will Smith",
    "oddName": "Kevin Hart"
  },
  {
    "pairId": 6,
    "description": "Oscar winners",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/wJiGedOCZat0n55v1i2s5p2wT46.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/qJ2tW6WMUDux911r6m7haRef0WH.jpg",  // Emma Stone - fixed
    "sameName": "Jennifer Lawrence",
    "oddName": "Emma Stone"
  },
  {
    "pairId": 7,
    "description": "Music icons",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/3oM06d2t1Hag395I2kLp5OcfPBe.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/j9hI2MYsm9RHL6jpOieJPu6Vt2V.jpg",  // Rihanna - fixed
    "sameName": "Beyoncé",
    "oddName": "Rihanna"
  },
  {
    "pairId": 8,
    "description": "Young stars",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/yBcwJRZB3Kb0pOKVZHb6p9tbczU.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/3Wj0WtBkUfb3pnWG8YBv2kTp75R.jpg",  // Tom Holland - fixed
    "sameName": "Zendaya",
    "oddName": "Tom Holland"
  },
  {
    "pairId": 9,
    "description": "Netflix stars",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/v2O4HUdy1OKdAn2v2gC14Msm5nC.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/h9yqR85zFDUp7v6g7h2AVWNs3DG.jpg",  // Finn Wolfhard - fixed
    "sameName": "Millie Bobby Brown",
    "oddName": "Finn Wolfhard"
  },
  {
    "pairId": 10,
    "description": "DC heroes",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/cGOPbv9wA5gEejkUN892JrveARt.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/oYFy0zIjFQXLR9q8ErseW2rDrVG.jpg",  // Gal Gadot - fixed
    "sameName": "Henry Cavill",
    "oddName": "Gal Gadot"
  },
  {
    "pairId": 11,
    "description": "Horror icons",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/3KhcVdxGNHWJbILQvJm0v9jTRwg.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/g5f4JJfIFr9NZ45s5yNq0RsqX0f.jpg",  // Neve Campbell - fixed
    "sameName": "Jamie Lee Curtis",
    "oddName": "Neve Campbell"
  },
  {
    "pairId": 12,
    "description": "The Two Ryans",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/4SYq1623yvs9T1Tq9v9yv942IQP.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/4a0IyiFMMiQzTy2Uk16x20cyzWD.jpg",  // Ryan Gosling - fixed
    "sameName": "Ryan Reynolds",
    "oddName": "Ryan Gosling"
  },
  {
    "pairId": 13,
    "description": "Fashion icons",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/o08MSs9gWAMBg9sJM7m0kbHAVJz.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/6p2tFwmyk2LgA0M5Yy3W7aK3sY2.jpg",
    "sameName": "Margot Robbie",
    "oddName": "Scarlett Johansson"
  },
  {
    "pairId": 14,
    "description": "British legends",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/fysotBiT5tcn9T2yG1i2o2I6S7s.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/6aCJBVoH7yHN7PxbRSK8q8pTX9f.jpg",
    "sameName": "Benedict Cumberbatch",
    "oddName": "Daniel Craig"
  },
  {
    "pairId": 15,
    "description": "Rising stars",
    "sameImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/hJhCOUUKhPtUhEWgppqGFsO7zSm.jpg",
    "oddImage": "https://image.tmdb.org/t/p/w300_and_h450_bestv2/z3mKDSJ9v4f2y2yVwXG6d3s22k0.jpg",
    "sameName": "Florence Pugh",
    "oddName": "Timothée Chalamet"
  }
];

async function checkImageUrl(url) {
  try {
    const res = await fetch(url, { method: 'HEAD' });
    return res.status !== 404;
  } catch {
    return false;
  }
}

// Fetch fallback image URL from TMDb API by person name
async function getFallbackImageUrl(name) {
  try {
    const res = await fetch(`https://api.themoviedb.org/3/search/person?api_key=${apiKey}&query=${encodeURIComponent(name)}`);
    const data = await res.json();
    if (data.results && data.results.length > 0) {
      const profilePath = data.results[0].profile_path;
      if (profilePath) {
        return baseImageUrl + profilePath;
      }
    }
  } catch {
    // ignore errors
  }
  return null;
}

// Returns a valid image URL, falling back if original 404s
async function getValidImageUrl(originalUrl, name) {
  const exists = await checkImageUrl(originalUrl);
  if (exists) {
    return originalUrl;
  }
  const fallback = await getFallbackImageUrl(name);
  return fallback || originalUrl;
}

// Example usage: update one pair’s images (async)
async function updatePairImages(pair) {
  pair.sameImage = await getValidImageUrl(pair.sameImage, pair.sameName);
  pair.oddImage = await getValidImageUrl(pair.oddImage, pair.oddName);
  return pair;
}

// Function to get a random celebrity pair with verified images
async function getCelebrityPair() {
  const randomIndex = Math.floor(Math.random() * celebrityPairs.length);
  const pair = celebrityPairs[randomIndex];
  return await updatePairImages(pair);
}

module.exports = {
  celebrityPairs,
  getCelebrityPair,
  getValidImageUrl,    // exporting in case you want to use elsewhere
  updatePairImages
};
