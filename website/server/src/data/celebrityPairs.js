const celebrityPairs = [
  {
    pairId: 1,
    description: 'Hollywood A-listers',
    sameImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&h=300&fit=crop&crop=face',
    sameName: 'Leonardo DiCaprio',
    oddName: 'Brad Pitt',
  },
  {
    pairId: 2,
    description: 'Pop superstars',
    sameImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b093?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&h=300&fit=crop&crop=face',
    sameName: 'Taylor Swift',
    oddName: 'Ariana Grande',
  },
  {
    pairId: 3,
    description: 'Marvel heroes',
    sameImage: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=300&h=300&fit=crop&crop=face',
    sameName: 'Robert Downey Jr.',
    oddName: 'Chris Evans',
  },
  {
    pairId: 4,
    description: 'Comedy legends',
    sameImage: 'https://images.unsplash.com/photo-1566492031773-4f4e44671d66?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1581803118522-7b72a50f7e9f?w=300&h=300&fit=crop&crop=face',
    sameName: 'Will Smith',
    oddName: 'Kevin Hart',
  },
  {
    pairId: 5,
    description: 'Oscar winners',
    sameImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1534751516642-a1af1ef26a56?w=300&h=300&fit=crop&crop=face',
    sameName: 'Jennifer Lawrence',
    oddName: 'Emma Stone',
  },
  {
    pairId: 6,
    description: 'Action stars',
    sameImage: 'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&h=300&fit=crop&crop=face',
    sameName: 'Dwayne Johnson',
    oddName: 'Tom Cruise',
  },
  {
    pairId: 7,
    description: 'Music icons',
    sameImage: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1595152772835-219674b2a8a6?w=300&h=300&fit=crop&crop=face',
    sameName: 'Beyoncé',
    oddName: 'Rihanna',
  },
  {
    pairId: 8,
    description: 'British royalty',
    sameImage: 'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1522075469751-3847ae2e4c66?w=300&h=300&fit=crop&crop=face',
    sameName: 'Prince William',
    oddName: 'Prince Harry',
  },
  {
    pairId: 9,
    description: 'Disney stars',
    sameImage: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=300&h=300&fit=crop&crop=face',
    sameName: 'Zendaya',
    oddName: 'Selena Gomez',
  },
  {
    pairId: 10,
    description: 'Late night hosts',
    sameImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=300&h=300&fit=crop&crop=face',
    sameName: 'Jimmy Fallon',
    oddName: 'Stephen Colbert',
  },
  {
    pairId: 11,
    description: 'Netflix stars',
    sameImage: 'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=300&h=300&fit=crop&crop=face',
    sameName: 'Millie Bobby Brown',
    oddName: 'Noah Schnapp',
  },
  {
    pairId: 12,
    description: 'Grammy winners',
    sameImage: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face',
    sameName: 'John Legend',
    oddName: 'Bruno Mars',
  },
  {
    pairId: 13,
    description: 'Fashion icons',
    sameImage: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300&h=300&fit=crop&crop=face',
    sameName: 'Gigi Hadid',
    oddName: 'Bella Hadid',
  },
  {
    pairId: 14,
    description: 'Sports legends',
    sameImage: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=300&h=300&fit=crop&crop=face',
    sameName: 'LeBron James',
    oddName: 'Michael Jordan',
  },
  {
    pairId: 15,
    description: 'Tech billionaires',
    sameImage: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=300&h=300&fit=crop&crop=face',
    sameName: 'Elon Musk',
    oddName: 'Bill Gates',
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