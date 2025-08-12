const celebrityPairs = [
  {
    pairId: 1,
    description: 'Professional businesspeople',
    sameImage: 'https://picsum.photos/id/1011/300/300',
    oddImage: 'https://picsum.photos/id/1012/300/300',
    sameName: 'Alex Johnson',
    oddName: 'Jordan Smith',
  },
  {
    pairId: 2,
    description: 'Young professionals',
    sameImage: 'https://picsum.photos/id/1027/300/300',
    oddImage: 'https://picsum.photos/id/1025/300/300',
    sameName: 'Casey Taylor',
    oddName: 'Morgan Lee',
  },
  {
    pairId: 3,
    description: 'Creative artists',
    sameImage: 'https://picsum.photos/id/1005/300/300',
    oddImage: 'https://picsum.photos/id/1006/300/300',
    sameName: 'Riley Davis',
    oddName: 'Avery Wilson',
  },
  {
    pairId: 4,
    description: 'Tech workers',
    sameImage: 'https://picsum.photos/id/91/300/300',
    oddImage: 'https://picsum.photos/id/177/300/300',
    sameName: 'Sam Chen',
    oddName: 'Drew Martinez',
  },
  {
    pairId: 5,
    description: 'Marketing experts',
    sameImage: 'https://picsum.photos/id/1074/300/300',
    oddImage: 'https://picsum.photos/id/1073/300/300',
    sameName: 'Quinn Anderson',
    oddName: 'Blake Garcia',
  },
  {
    pairId: 6,
    description: 'Design specialists',
    sameImage: 'https://picsum.photos/id/996/300/300',
    oddImage: 'https://picsum.photos/id/1000/300/300',
    sameName: 'Sage Rodriguez',
    oddName: 'River Thompson',
  },
  {
    pairId: 7,
    description: 'Content creators',
    sameImage: 'https://picsum.photos/id/804/300/300',
    oddImage: 'https://picsum.photos/id/836/300/300',
    sameName: 'Phoenix Brown',
    oddName: 'Dakota White',
  },
  {
    pairId: 8,
    description: 'Finance professionals',
    sameImage: 'https://picsum.photos/id/453/300/300',
    oddImage: 'https://picsum.photos/id/342/300/300',
    sameName: 'Skylar Collins',
    oddName: 'Cameron Parker',
  },
  {
    pairId: 9,
    description: 'Healthcare workers',
    sameImage: 'https://picsum.photos/id/236/300/300',
    oddImage: 'https://picsum.photos/id/237/300/300',
    sameName: 'Jamie Mitchell',
    oddName: 'Emery Cooper',
  },
  {
    pairId: 10,
    description: 'Education specialists',
    sameImage: 'https://picsum.photos/id/251/300/300',
    oddImage: 'https://picsum.photos/id/256/300/300',
    sameName: 'Blake Murphy',
    oddName: 'Hayden Reed',
  },
  {
    pairId: 11,
    description: 'Legal professionals',
    sameImage: 'https://picsum.photos/id/287/300/300',
    oddImage: 'https://picsum.photos/id/294/300/300',
    sameName: 'Reese Bell',
    oddName: 'Finley Price',
  },
  {
    pairId: 12,
    description: 'Architecture experts',
    sameImage: 'https://picsum.photos/id/338/300/300',
    oddImage: 'https://picsum.photos/id/349/300/300',
    sameName: 'Marlowe Foster',
    oddName: 'Sawyer Gray',
  },
  {
    pairId: 13,
    description: 'Research scientists',
    sameImage: 'https://picsum.photos/id/375/300/300',
    oddImage: 'https://picsum.photos/id/399/300/300',
    sameName: 'Briar Hughes',
    oddName: 'Tatum Ward',
  },
  {
    pairId: 14,
    description: 'Media specialists',
    sameImage: 'https://picsum.photos/id/433/300/300',
    oddImage: 'https://picsum.photos/id/447/300/300',
    sameName: 'Raven Brooks',
    oddName: 'Story Wells',
  },
  {
    pairId: 15,
    description: 'Fashion consultants',
    sameImage: 'https://picsum.photos/id/485/300/300',
    oddImage: 'https://picsum.photos/id/494/300/300',
    sameName: 'Indie Stone',
    oddName: 'Nova Rivers',
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