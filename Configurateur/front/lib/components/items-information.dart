// ignore_for_file: file_names, dangling_library_doc_comments

/// ItemList
///
/// Define the data of item in back end
/// [id] : Item's id
/// [name] : Item's name
/// [available] : Define if item is available or not
/// [container] : Container where the item is stored
/// [createdAt] : Creation of the item
/// [containerId] : Container's id
/// [price] : Item's price
/// [image] : Image of the item
/// [description] : Describe the item

class ItemList {
  final int? id;
  final dynamic name;
  final bool? available;
  final int? container;
  final dynamic createdAt;
  final dynamic containerId;
  final double? price;
  final String? image;
  final String? description;
  final String? category;

  ItemList({
    required this.id,
    required this.name,
    required this.available,
    required this.container,
    required this.createdAt,
    required this.containerId,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      id: json['id'],
      name: json['name'],
      available: json['available'],
      container: json['container'],
      createdAt: json['createdAt'],
      containerId: json['containerId'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'available': available,
      'container': container,
      'createdAt': createdAt,
      'containerId': containerId,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
    };
  }
}
