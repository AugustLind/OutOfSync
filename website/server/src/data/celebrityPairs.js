const celebrityPairs = [
  {
    pairId: 1,
    description: 'Hollywood actors with similar looks',
    sameImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&h=300&fit=crop&crop=face',
    sameName: 'Actor A',
    oddName: 'Actor B',
  },
  {
    pairId: 2,
    description: 'Professional models',
    sameImage: 'https://images.unsplash.com/photo-1494790108755-2616b4ade6d0?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300&h=300&fit=crop&crop=face',
    sameName: 'Model A',
    oddName: 'Model B',
  },
  {
    pairId: 3,
    description: 'Business professionals',
    sameImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=300&h=300&fit=crop&crop=face',
    sameName: 'Professional A',
    oddName: 'Professional B',
  },
  {
    pairId: 4,
    description: 'Creative artists',
    sameImage: 'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&h=300&fit=crop&crop=face',
    sameName: 'Artist A',
    oddName: 'Artist B',
  },
  {
    pairId: 5,
    description: 'Young entrepreneurs',
    sameImage: 'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1521119989659-a83eee488004?w=300&h=300&fit=crop&crop=face',
    sameName: 'Entrepreneur A',
    oddName: 'Entrepreneur B',
  },
  {
    pairId: 6,
    description: 'Fitness enthusiasts',
    sameImage: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1566492031773-4f4e44671d66?w=300&h=300&fit=crop&crop=face',
    sameName: 'Athlete A',
    oddName: 'Athlete B',
  },
  {
    pairId: 7,
    description: 'Young professionals',
    sameImage: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=300&h=300&fit=crop&crop=face',
    sameName: 'Professional A',
    oddName: 'Professional B',
  },
  {
    pairId: 8,
    description: 'Creative women',
    sameImage: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&h=300&fit=crop&crop=face',
    sameName: 'Creative A',
    oddName: 'Creative B',
  },
  {
    pairId: 9,
    description: 'Stylish individuals',
    sameImage: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&h=300&fit=crop&crop=face',
    sameName: 'Stylist A',
    oddName: 'Stylist B',
  },
  {
    pairId: 10,
    description: 'Tech workers',
    sameImage: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=300&h=300&fit=crop&crop=face',
    sameName: 'Developer A',
    oddName: 'Developer B',
  },
  {
    pairId: 11,
    description: 'Smart innovators',
    sameImage: 'https://images.unsplash.com/photo-1556157382-97eda2d62296?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1590086782792-42dd2350140d?w=300&h=300&fit=crop&crop=face',
    sameName: 'Innovator A',
    oddName: 'Innovator B',
  },
  {
    pairId: 12,
    description: 'Creative professionals',
    sameImage: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=300&h=300&fit=crop&crop=face',
    sameName: 'Creative A',
    oddName: 'Creative B',
  },
  {
    pairId: 13,
    description: 'Outdoor enthusiasts',
    sameImage: 'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1559548331-f9cb98001426?w=300&h=300&fit=crop&crop=face',
    sameName: 'Explorer A',
    oddName: 'Explorer B',
  },
  {
    pairId: 14,
    description: 'Media professionals',
    sameImage: 'https://images.unsplash.com/photo-1629425733761-caae3b5f2e50?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1636041293178-808a6762ab39?w=300&h=300&fit=crop&crop=face',
    sameName: 'Media Pro A',
    oddName: 'Media Pro B',
  },
  {
    pairId: 15,
    description: 'Fashion designers',
    sameImage: 'https://images.unsplash.com/photo-1664575602276-acd073f104c1?w=300&h=300&fit=crop&crop=face',
    oddImage: 'https://images.unsplash.com/photo-1665686376173-ada7a0031a85?w=300&h=300&fit=crop&crop=face',
    sameName: 'Designer A',
    oddName: 'Designer B',
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