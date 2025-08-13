import 'dart:ffi';

void main() {
  Pointer<Int32>.fromAddress(0).value = 10;
}
