import 'package:logger/logger.dart';

import 'isolate_file_output.dart';

class SilentFileOutput extends LogOutput {
  final IsolateFileOutput _fileOutput;

  SilentFileOutput(this._fileOutput);

  @override
  void output(OutputEvent event) {
    _fileOutput.output(event);
  }
}
