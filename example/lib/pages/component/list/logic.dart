import 'package:flutter_chen_common/widgets/refresh/refresh_controller.dart';
import 'package:flutter_chen_common/widgets/refresh/refresh_state.dart';
import 'package:get/get.dart';

class ListLogic extends PagingController<dynamic> {
  @override
  Future<PagingResponse> loadData() async {
    // TODO: implement loadData
    dynamic result = {"current": 1, "total": 3, "records": []};
    await Future.delayed(2000.milliseconds, () {
      for (var i = 0; i < 20; ++i) {
        result["records"]?.add(i);
      }
    });
    return PagingResponse.fromMapJson(result);
  }
}
