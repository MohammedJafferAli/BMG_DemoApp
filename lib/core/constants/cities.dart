class City {
  final String name;
  final String image;
  final String description;

  const City({
    required this.name,
    required this.image,
    required this.description,
  });
}

const List<City> popularCities = [
  City(
    name: 'Mumbai',
    image: 'https://images.unsplash.com/photo-1595658658481-d53d3f999875?w=400',
    description: 'The City of Dreams',
  ),
  City(
    name: 'Delhi',
    image: 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400',
    description: 'India\'s Capital',
  ),
  City(
    name: 'Goa',
    image: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400',
    description: 'Beach Paradise',
  ),
  City(
    name: 'Jaipur',
    image: 'https://images.unsplash.com/photo-1599661046827-dacde6976549?w=400',
    description: 'The Pink City',
  ),
  City(
    name: 'Kerala',
    image: 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=400',
    description: 'God\'s Own Country',
  ),
  City(
    name: 'Agra',
    image: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400',
    description: 'City of Taj Mahal',
  ),
];