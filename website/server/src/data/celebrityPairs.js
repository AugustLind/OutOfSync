const celebrityPairs = [
  {
    pairId: 1,
    description: 'Professional headshots',
    sameImage: 'https://picsum.photos/300/300?random=1',
    oddImage: 'https://picsum.photos/300/300?random=2',
    sameName: 'Alex Thompson',
    oddName: 'Jordan Blake',
  },
  {
    pairId: 2,
    description: 'Creative professionals',
    sameImage: 'https://picsum.photos/300/300?random=3',
    oddImage: 'https://picsum.photos/300/300?random=4',
    sameName: 'Sam Rivera',
    oddName: 'Casey Morgan',
  },
  {
    pairId: 3,
    description: 'Business leaders',
    sameImage: 'https://picsum.photos/300/300?random=5',
    oddImage: 'https://picsum.photos/300/300?random=6',
    sameName: 'Taylor Chen',
    oddName: 'Riley Parker',
  },
  {
    pairId: 4,
    description: 'Tech innovators',
    sameImage: 'https://picsum.photos/300/300?random=7',
    oddImage: 'https://picsum.photos/300/300?random=8',
    sameName: 'Morgan Davis',
    oddName: 'Avery Johnson',
  },
  {
    pairId: 5,
    description: 'Marketing experts',
    sameImage: 'https://picsum.photos/300/300?random=9',
    oddImage: 'https://picsum.photos/300/300?random=10',
    sameName: 'Quinn Wilson',
    oddName: 'Drew Martinez',
  },
  {
    pairId: 6,
    description: 'Design specialists',
    sameImage: 'https://picsum.photos/300/300?random=11',
    oddImage: 'https://picsum.photos/300/300?random=12',
    sameName: 'Sage Anderson',
    oddName: 'Rowan Garcia',
  },
  {
    pairId: 7,
    description: 'Content creators',
    sameImage: 'https://picsum.photos/300/300?random=13',
    oddImage: 'https://picsum.photos/300/300?random=14',
    sameName: 'Phoenix Lee',
    oddName: 'River Taylor',
  },
  {
    pairId: 8,
    description: 'Finance professionals',
    sameImage: 'https://picsum.photos/300/300?random=15',
    oddImage: 'https://picsum.photos/300/300?random=16',
    sameName: 'Skylar Brown',
    oddName: 'Cameron White',
  },
  {
    pairId: 9,
    description: 'Healthcare workers',
    sameImage: 'https://picsum.photos/300/300?random=17',
    oddImage: 'https://picsum.photos/300/300?random=18',
    sameName: 'Jamie Collins',
    oddName: 'Emery Stone',
  },
  {
    pairId: 10,
    description: 'Education specialists',
    sameImage: 'https://picsum.photos/300/300?random=19',
    oddImage: 'https://picsum.photos/300/300?random=20',
    sameName: 'Blake Mitchell',
    oddName: 'Hayden Cooper',
  },
  {
    pairId: 11,
    description: 'Legal professionals',
    sameImage: 'https://picsum.photos/300/300?random=21',
    oddImage: 'https://picsum.photos/300/300?random=22',
    sameName: 'Reese Murphy',
    oddName: 'Finley Reed',
  },
  {
    pairId: 12,
    description: 'Architecture experts',
    sameImage: 'https://picsum.photos/300/300?random=23',
    oddImage: 'https://picsum.photos/300/300?random=24',
    sameName: 'Marlowe Bell',
    oddName: 'Sawyer Price',
  },
  {
    pairId: 13,
    description: 'Research scientists',
    sameImage: 'https://picsum.photos/300/300?random=25',
    oddImage: 'https://picsum.photos/300/300?random=26',
    sameName: 'Briar Foster',
    oddName: 'Tatum Gray',
  },
  {
    pairId: 14,
    description: 'Media specialists',
    sameImage: 'https://picsum.photos/300/300?random=27',
    oddImage: 'https://picsum.photos/300/300?random=28',
    sameName: 'Raven Hughes',
    oddName: 'Dakota Ward',
  },
  {
    pairId: 15,
    description: 'Fashion consultants',
    sameImage: 'https://picsum.photos/300/300?random=29',
    oddImage: 'https://picsum.photos/300/300?random=30',
    sameName: 'Indie Brooks',
    oddName: 'Story Wells',
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