import 'package:flutter_chen_common/widgets/base/base_widget.dart';
import 'package:get/get.dart';

class StatusLogic extends GetxController {
  final status = LayoutStatus.success.obs;
  final statusArr = [
    LayoutStatus.empty,
    LayoutStatus.error,
    LayoutStatus.loading,
    LayoutStatus.noNetwork,
    LayoutStatus.success
  ];

  void changeStatus(val) {
    status.value = val;
  }
}
