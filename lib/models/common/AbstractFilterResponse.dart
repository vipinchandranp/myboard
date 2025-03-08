import '../../utils/ItemType.dart';

class AbstractFilterResponse {
  final String id;
  final ItemType itemType;
  final String name;

  AbstractFilterResponse({
    required this.id,
    required this.itemType,
    required this.name,
  });

  /// Factory method to create an instance from JSON.
  factory AbstractFilterResponse.fromJson(Map<String, dynamic> json) {
    return AbstractFilterResponse(
      id: json['id'],
      itemType: ItemTypeExtension.fromJson(json['itemType']),
      name: json['name']
    );
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemType': itemType.toJson(),
      'name': name
    };
  }
}
