class Model {
  final int id;
  final String imagePath;
  final String name;

  Model({
    required this.id,
    required this.imagePath,
    required this.name,
  });
}

List<Model> navBtn = [
  Model(id: 0, imagePath: 'assets/home.png', name: 'Home'),
  Model(id: 1, imagePath: 'assets/search.png', name: 'Search'),
  Model(id: 2, imagePath: 'assets/notification.png', name: 'notification'),
  Model(id: 3, imagePath: 'assets/user.png', name: 'Profile'),
];
