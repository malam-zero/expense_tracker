enum Category {
  all,
  grocery,
  food,
  work,
  entertainment,
  travelling,
  others;

  String toJson() => name;
  static Category fromJson(String json) => values.byName(json);
}

extension CategoryModel on Category {
  String get toName => switch (this) {
    Category.all => 'All',
    Category.entertainment => 'Entertainment',
    Category.food => 'Food',
    Category.grocery => 'Grocery',
    Category.others => 'Others',
    Category.travelling => 'Traveling',
    Category.work => 'Work',
  };
}
