import 'dart:collection';
import 'dart:io';

class TransferQueue {
  final Queue<File> _queue = Queue<File>();

  void addToQueue(File file) {
    _queue.add(file);
  }

  File? getNext() {
    if (_queue.isNotEmpty) {
      return _queue.removeFirst();
    }
    return null;
  }

  bool get isEmpty => _queue.isEmpty;
}
