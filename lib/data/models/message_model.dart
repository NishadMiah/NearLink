import 'package:hive/hive.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart'; // Require running build_runner

@HiveType(typeId: 0)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isMine;

  @HiveField(3)
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.text,
    required this.isMine,
    required this.timestamp,
  });

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      text: entity.text,
      isMine: entity.isMine,
      timestamp: entity.timestamp,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      text: text,
      isMine: isMine,
      timestamp: timestamp,
    );
  }
}
