import 'dart:async';

class DateBloc {
  final _dateController = StreamController<DateTime>();
  Stream<DateTime> get dateStream => _dateController.stream;

  void selectDate(date) {
    _dateController.sink.add(date);
  }

  void dispose() {
    _dateController.close();
  }
}
