
class ErrorMsg {
  dynamic e;
  String eMsg;

  ErrorMsg({
    this.e,
    this.eMsg
  });

  @override
  String toString() {
    return '${e.toString()} : $eMsg';
  }
}