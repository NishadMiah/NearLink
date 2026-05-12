import 'dart:convert';
import 'dart:typed_data';

enum PacketType { heartbeat, text, meta, fileChunk }

class PacketFormatter {
  static Uint8List encodePacket(PacketType type, dynamic payload) {
    List<int> payloadBytes;
    if (payload is String) {
      payloadBytes = utf8.encode(payload);
    } else if (payload is List<int>) {
      payloadBytes = payload;
    } else {
      payloadBytes = utf8.encode(jsonEncode(payload));
    }

    final length = payloadBytes.length + 1; // 1 byte for type
    final builder = BytesBuilder();
    
    // Write 4 bytes for length
    final lengthBytes = Uint8List(4);
    final byteData = ByteData.view(lengthBytes.buffer);
    byteData.setInt32(0, length, Endian.big);
    builder.add(lengthBytes);

    // Write 1 byte for type
    builder.addByte(type.index);

    // Write payload
    builder.add(payloadBytes);

    return builder.toBytes();
  }

  static dynamic decodePacket(Uint8List data) {
    // Basic decoding, assume full packet is received for simplicity in this example
    if (data.length < 5) return null;
    
    final typeIndex = data[4];
    final payloadBytes = data.sublist(5);
    
    if (typeIndex == PacketType.text.index || typeIndex == PacketType.meta.index) {
      return utf8.decode(payloadBytes);
    }
    return payloadBytes; // return raw bytes for chunks
  }
}
