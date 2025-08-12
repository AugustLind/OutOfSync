const celebrityPairs = [
  {
    pairId: 1,
    description: 'Professional headshots',
    sameImage: 'https://picsum.photos/id/1/300/300',
    oddImage: 'https://picsum.photos/id/2/300/300',
    sameName: 'Alex Thompson',
    oddName: 'Jordan Blake',
  },
  {
    pairId: 2,
    description: 'Creative professionals',
    sameImage: 'https://picsum.photos/id/3/300/300',
    oddImage: 'https://picsum.photos/id/4/300/300',
    sameName: 'Sam Rivera',
    oddName: 'Casey Morgan',
  },
  {
    pairId: 3,
    description: 'Business leaders',
    sameImage: 'https://picsum.photos/id/5/300/300',
    oddImage: 'https://picsum.photos/id/6/300/300',
    sameName: 'Taylor Chen',
    oddName: 'Riley Parker',
  },
  {
    pairId: 4,
    description: 'Tech innovators',
    sameImage: 'https://picsum.photos/id/7/300/300',
    oddImage: 'https://picsum.photos/id/8/300/300',
    sameName: 'Morgan Davis',
    oddName: 'Avery Johnson',
  },
  {
    pairId: 5,
    description: 'Marketing experts',
    sameImage: 'https://picsum.photos/id/9/300/300',
    oddImage: 'https://picsum.photos/id/10/300/300',
    sameName: 'Quinn Wilson',
    oddName: 'Drew Martinez',
  },
  {
    pairId: 6,
    description: 'Design specialists',
    sameImage: 'https://picsum.photos/id/11/300/300',
    oddImage: 'https://picsum.photos/id/12/300/300',
    sameName: 'Sage Anderson',
    oddName: 'Rowan Garcia',
  },
  {
    pairId: 7,
    description: 'Content creators',
    sameImage: 'https://picsum.photos/id/13/300/300',
    oddImage: 'https://picsum.photos/id/14/300/300',
    sameName: 'Phoenix Lee',
    oddName: 'River Taylor',
  },
  {
    pairId: 8,
    description: 'Finance professionals',
    sameImage: 'https://picsum.photos/id/15/300/300',
    oddImage: 'https://picsum.photos/id/16/300/300',
    sameName: 'Skylar Brown',
    oddName: 'Cameron White',
  },
  {
    pairId: 9,
    description: 'Healthcare workers',
    sameImage: 'https://picsum.photos/id/17/300/300',
    oddImage: 'https://picsum.photos/id/18/300/300',
    sameName: 'Jamie Collins',
    oddName: 'Emery Stone',
  },
  {
    pairId: 10,
    description: 'Education specialists',
    sameImage: 'https://picsum.photos/id/19/300/300',
    oddImage: 'https://picsum.photos/id/20/300/300',
    sameName: 'Blake Mitchell',
    oddName: 'Hayden Cooper',
  },
  {
    pairId: 11,
    description: 'Legal professionals',
    sameImage: 'https://picsum.photos/id/21/300/300',
    oddImage: 'https://picsum.photos/id/22/300/300',
    sameName: 'Reese Murphy',
    oddName: 'Finley Reed',
  },
  {
    pairId: 12,
    description: 'Architecture experts',
    sameImage: 'https://picsum.photos/id/23/300/300',
    oddImage: 'https://picsum.photos/id/24/300/300',
    sameName: 'Marlowe Bell',
    oddName: 'Sawyer Price',
  },
  {
    pairId: 13,
    description: 'Research scientists',
    sameImage: 'https://picsum.photos/id/25/300/300',
    oddImage: 'https://picsum.photos/id/26/300/300',
    sameName: 'Briar Foster',
    oddName: 'Tatum Gray',
  },
  {
    pairId: 14,
    description: 'Media specialists',
    sameImage: 'https://picsum.photos/id/27/300/300',
    oddImage: 'https://picsum.photos/id/28/300/300',
    sameName: 'Raven Hughes',
    oddName: 'Dakota Ward',
  },
  {
    pairId: 15,
    description: 'Fashion consultants',
    sameImage: 'https://picsum.photos/id/29/300/300',
    oddImage: 'https://picsum.photos/id/30/300/300',
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