
import 'package:newhorizontrav/utils/enums.dart';

class AirportModel {
  final int id;
  final String code;
  final Map<String, dynamic> name;
  final Map<String, dynamic> body;
  final String? image;
  final LocationType? type;

  const AirportModel({
    required this.id,
    required this.code,
    required this.name,
    required this.body,
    this.image,
    this.type,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) => AirportModel(
    id: json['id'],
    code: json['code'],
    name: json['name'],
    body: json['body'],
    image: json['image'],
    type: json['type'] == 'city' ? LocationType.city : json['type'] == 'airport' ? LocationType.airport : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'body': body,
    'image': image,
    'type': type == LocationType.city ? 'city' : type == LocationType.airport ? 'airport' : null,
  };

  @override
  String toString() => '$code — $name (${body ?? ''})';
}
