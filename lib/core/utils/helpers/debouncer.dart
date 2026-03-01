import 'dart:async';

// debouncer - waits until the user stops typing before firing the search
// saved me from spamming the api on every keypress lol
class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 500)});

  final Duration delay;
  Timer? _timer;

  // run the action after the delay, cancels any previous pending call
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  // cancel without running
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  // check if theres a pending call
  bool get isPending => _timer?.isActive ?? false;
}
