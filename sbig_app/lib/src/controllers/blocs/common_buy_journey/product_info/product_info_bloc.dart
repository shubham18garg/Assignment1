import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_product_info_model.dart';


import '../../base_bloc.dart';
import 'product_info_api_provider.dart';

class ProductInfoBloc extends BaseBloc  {

  BehaviorSubject<DialogEvent> _eventStreamController = BehaviorSubject();
  Observable<DialogEvent> get eventStream => _eventStreamController.stream;
  Function(DialogEvent) get changeEventStream => _eventStreamController.add;

  BehaviorSubject<bool> _isLoadingController = BehaviorSubject.seeded(false);
  Observable<bool> get isLoadingStream => _isLoadingController.stream;
  bool get isLoading => _isLoadingController.value;

  Future<ProductInfoResModel> getProductInfo (int isFrom) async {
    _isLoadingController.add(true);
    var response = await ProductInfoApiProvider.getInstance().getProductInfo(isFrom);
    _isLoadingController.add(false);
    if (response.apiErrorModel != null) {
      if (response.apiErrorModel.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      } else if (response.apiErrorModel.statusCode == ApiResponseListenerDio.MAINTENANCE) {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
      } else {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }



  @override
  void dispose() async {
    await _eventStreamController.drain();
    _eventStreamController.close();
    await _isLoadingController.drain();
    _isLoadingController.close();

  }
}
