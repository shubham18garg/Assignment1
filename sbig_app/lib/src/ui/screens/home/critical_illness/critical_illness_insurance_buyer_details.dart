import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/buyer_details/buyer_details_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/recalculate_premium.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/quick_quote_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/appointee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/communication_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/dob_format_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';

import 'package:sbig_app/src/models/widget_models/home/arogya_plus/nominee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/proposer_details_model.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/resources/string_description.dart';

import 'package:sbig_app/src/ui/screens/home/critical_illness/eia_number_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/appointee_details_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/communication_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/nominee_details_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/proposer_details_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/page_indicator_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class CriticalIllnessInsuranceBuyerDetailsScreen extends StatelessWidget {
  static const double EXTRA_SPACE = 100;
  static const ROUTE_NAME = "/critical_illness/insurance_buyer_details_screen";
  static const PROPOSER_DETAILS_WIDGET = 1;
  static const COMMUNICATION_DETAILS_WIDGET = 2;
  static const NOMINEE_DETAILS_WIDGET = 3;
  static const APPOINTEE_DETAILS_WIDGET = 4;
  static const TO_POLICY_SUMMERY_SCREEN = 5;

  final CriticalIllnessModel criticalIllnessModel;

  CriticalIllnessInsuranceBuyerDetailsScreen(this.criticalIllnessModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: CriticalIllnessInsuranceBuyerDetails(criticalIllnessModel),
      bloc: BuyerDetailsBloc(),
    );
  }
}

class CriticalIllnessInsuranceBuyerDetails extends StatefulWidgetBase {
  final CriticalIllnessModel criticalIllnessModel;

  CriticalIllnessInsuranceBuyerDetails(this.criticalIllnessModel);

  @override
  _State createState() => _State();
}

class _State extends State<CriticalIllnessInsuranceBuyerDetails>
    with CommonWidget {
  ScrollController _controller = ScrollController();
  BuyerDetailsBloc _bloc;
  int startIndex, _pageCount, _currentIndex;
  bool isAllPagesLoaded = false;
  List<Widget> pages;

  //final SwiperController _swiperController = SwiperController();
  static const isFromToolbarBack = 1, bottomNavigationBarBack = 2;
  String quoteNumber = "";

  ProposerDetailsModel proposerDetailsModel;
  CommunicationDetailsModel communicationDetailsModel;
  NomineeDetailsModel nomineeDetailsModel;
  AppointeeDetailsModel appointeeDetailsModel;
  DateTime currentDate = DateTime.now();
  CriticalIllnessBuyerDetails buyerDetails;
  bool isProposerEditable = true;

  PageController _pageController;
  PageIndicatorController _pageIndicatorController = PageIndicatorController();

  @override
  void initState() {
    _bloc = SbiBlocProvider.of<BuyerDetailsBloc>(context);
    proposerDetailsModel = ProposerDetailsModel();
    communicationDetailsModel = CommunicationDetailsModel();
    nomineeDetailsModel = NomineeDetailsModel();
    appointeeDetailsModel = AppointeeDetailsModel();
    buyerDetails = CriticalIllnessBuyerDetails();
    _pageController = PageController(initialPage: 0);

    //Below logic is to skip Proposer Screen
//    pages = [
//      CommunicationWidget(_focusNode, childWidgetListener,
//          _bloc.buyerDetailsController, _controller, communicationDetailsModel),
//      NomineeDetailsWidget(_focusNode, childWidgetListener,
//          _bloc.buyerDetailsController, _controller, nomineeDetailsModel),
//      AppointeeDetailsWidget(_focusNode, childWidgetListener,
//          _bloc.buyerDetailsController, _controller, appointeeDetailsModel)
//    ];
//
//    if (null != widget.selectedMemberDetails.isProposerSelf) {
//      if (!widget.selectedMemberDetails.isProposerSelf) {
//        pages.insert(
//          0,
//          ProposerDetailsWidget(_focusNode, childWidgetListener,
//              _bloc.buyerDetailsController, _controller, proposerDetailsModel),
//        );
//      }
//    }

    if (null != widget.criticalIllnessModel.isProposerSelf) {
      if (widget.criticalIllnessModel.isProposerSelf) {
          MemberDetailsModel memberDetailsModel = widget.criticalIllnessModel.policyCoverMemberModel.memberDetailsModel;
          if (memberDetailsModel.relation.compareTo("Self") == 0) {
            AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;
            proposerDetailsModel.firstName = memberDetailsModel.firstName;
            proposerDetailsModel.lastName = memberDetailsModel.lastName;
            proposerDetailsModel.gender = ageGenderModel.gender;
            proposerDetailsModel.dobFormat = DobFormat(
                dob: ageGenderModel.dob,
                dob_yyyy_mm_dd: ageGenderModel.dob_yyyy_mm_dd,
                dateTime: ageGenderModel.dateTime);
            isProposerEditable = false;
          }

      }
    }

    pages = [
      ProposerDetailsWidget(childWidgetListener, _bloc.proposerDetailsWidgetSC,
        _controller, proposerDetailsModel, isProposerEditable,isFrom: StringConstants.FROM_CRITICAL_ILLNESS,quickFact: StringDescription.quick_fact26,),
      CommunicationWidget(childWidgetListener, _bloc.communicationWidgetSC,
          _controller, communicationDetailsModel,quickFact: StringDescription.quick_fact27,),
      NomineeDetailsWidget(childWidgetListener, _bloc.nominieeDetailsWidgetSC,
          _controller, nomineeDetailsModel,quickFact: StringDescription.quick_fact28,),
      AppointeeDetailsWidget(childWidgetListener,
          _bloc.appointeeDetailsWidgetSC, _controller, appointeeDetailsModel,quickFact: StringDescription.quick_fact29,)
    ];

    _pageCount = pages.length;
    startIndex = 0;
    _currentIndex = startIndex;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    try {
      quoteNumber = S.of(context).quote_number.toUpperCase() + ": ";
      if (null != widget.criticalIllnessModel.quoteNumber) {
        quoteNumber = quoteNumber + widget.criticalIllnessModel.quoteNumber;
      }

      int redirection = prefsHelper.getRedirection();
      if (redirection != null) {
        if (redirection ==
            CriticalIllnessInsuranceBuyerDetailsScreen.COMMUNICATION_DETAILS_WIDGET) {
//        Future.delayed(Duration(milliseconds: 300), () {
//          _swiperController.move(_currentIndex = 1, animation: true);
//        });
          _pageController.animateToPage(_currentIndex = 1,
              duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        } else if (redirection ==
            CriticalIllnessInsuranceBuyerDetailsScreen.NOMINEE_DETAILS_WIDGET) {
          _pageController.animateToPage(_currentIndex = 2,
              duration: Duration(milliseconds: 500), curve: Curves.decelerate);
//        Future.delayed(Duration(milliseconds: 300), () {
//          _swiperController.move(_currentIndex = 2, animation: true);
//        });
        }
        prefsHelper.setRedirection(null);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    super.didChangeDependencies();
  }

  Future<bool> _onBackPressed(int from) {
    FocusScope.of(context).unfocus();
    if (_currentIndex == 0) {
      if (from == isFromToolbarBack) {
        Navigator.pop(context);
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      _currentIndex--;
      //_swiperController.move(_currentIndex, animation: true);
      _pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onBackPressed(bottomNavigationBarBack);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.arogya_plus_si_edit_color,
        appBar: getAppBar(context, S.of(context).insured_details.toUpperCase(),
            onBackPressed: _onBackPressed, isFrom: isFromToolbarBack),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                child: Container(
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// Quote number not available from QuickQuote API. If needed uncomment below code
                       /* Container(
                          width: double.maxFinite,
                          color: ColorConstants.arogya_plus_quote_number_color,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              quoteNumber,
                              style:
                                  TextStyle(fontSize: 12.0, letterSpacing: 1.0),
                            ),
                          ),
                        ),*/
                        //communicationWidget(),
                        Container(
                          height:
                              ScreenUtil.getInstance(context).screenHeightDp +
                                  CriticalIllnessInsuranceBuyerDetailsScreen.EXTRA_SPACE,
                          width: double.maxFinite,
                          child: PageView(
                            controller: _pageController,
                            physics: NeverScrollableScrollPhysics(),
                            children: pages,
                            onPageChanged: (currPage) {
                              this._currentIndex = currPage;
                              _pageIndicatorController
                                  .notifyPageChange(_currentIndex);
                            },
                          ),
//                          child: Swiper(
//                            index: _currentIndex,
//                            controller: _swiperController,
//                            itemCount: _pageCount,
//                            autoplay: false,
//                            physics: isAllPagesLoaded
//                                ? null
//                                : NeverScrollableScrollPhysics(),
//                            onIndexChanged: (index) {
//                              _currentIndex = index;
//                            },
//                            loop: false,
//                            itemBuilder: (context, index) {
//                              return pages[index];
//                            },
//                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter, child: _showNextButton()),
            ],
          ),
        ),
      ),
    );
  }

  childWidgetListener(
      int from, bool isDataValid, bool showLoader, dynamic object) {
    print("from " + from.toString());
    switch (from) {
      case CriticalIllnessInsuranceBuyerDetailsScreen.PROPOSER_DETAILS_WIDGET:
        //_swiperController.move(_currentIndex = 0, animation: true);
        _pageController.animateToPage(_currentIndex = 0,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        break;
      case CriticalIllnessInsuranceBuyerDetailsScreen.COMMUNICATION_DETAILS_WIDGET:
        if (object is ProposerDetailsModel) {
          proposerDetailsModel = object;
        }
//        _swiperController.move(
//            _pageCount == 4 ? _currentIndex = 1 : _currentIndex = 0,
//            animation: true);
        _pageController.animateToPage(
            _pageCount == 4 ? _currentIndex = 1 : _currentIndex = 0,
            duration: Duration(milliseconds: 500),
            curve: Curves.decelerate);
        break;
      case CriticalIllnessInsuranceBuyerDetailsScreen.NOMINEE_DETAILS_WIDGET:
        if (object is CommunicationDetailsModel) {
          communicationDetailsModel = object;
        } else {
          nomineeDetailsModel = object;
        }
//        _swiperController.move(
//            _pageCount == 4 ? _currentIndex = 2 : _currentIndex = 1,
//            animation: true);
        _pageController.animateToPage(
            _pageCount == 4 ? _currentIndex = 2 : _currentIndex = 1,
            duration: Duration(milliseconds: 500),
            curve: Curves.decelerate);
        break;
      case CriticalIllnessInsuranceBuyerDetailsScreen.APPOINTEE_DETAILS_WIDGET:
        if (object is NomineeDetailsModel) {
          nomineeDetailsModel = object;
        } else {
          appointeeDetailsModel = object;
        }

        DateTime dob = nomineeDetailsModel.dobFormat.dateTime;
        if (dob != null) {
          int day = currentDate.day;
          int month = currentDate.month;
          int year = currentDate.year;
          DateTime minorAge = DateTime(year - 18, month = month, day = day);

          print(minorAge.year.toString());
          print(minorAge.month.toString());
          print(minorAge.day.toString());

          Duration duration = dob.difference(minorAge);
          if (duration.inDays > 0) {
//            _swiperController.move(
//                _pageCount == 4 ? _currentIndex = 3 : _currentIndex = 2,
//                animation: true);
            _pageController.animateToPage(
                _pageCount == 4 ? _currentIndex = 3 : _currentIndex = 2,
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate);
          } else {
            updateData(false);
            CriticalIllnessModel model = widget.criticalIllnessModel;
            Navigator.of(context).pushNamed(EIANumberScreen.ROUTE_NAME,
                arguments: model);
          }
        }
        break;
      case CriticalIllnessInsuranceBuyerDetailsScreen.TO_POLICY_SUMMERY_SCREEN:
        appointeeDetailsModel = object;
        updateData(true);
        CriticalIllnessModel model = widget.criticalIllnessModel;
        Navigator.of(context).pushNamed(EIANumberScreen.ROUTE_NAME,
            arguments: model);
        break;
    }
  }

  updateData(bool isNomineeMinor) {
    buyerDetails.communicationDetailsModel = communicationDetailsModel;
    //Proposer page is not available
    /// need to check with page 3 condition
    if (_pageCount == 3) {
      QuickQuoteReqModel quickQuoteReqModel = widget.criticalIllnessModel.quickQuoteReqModel;
      proposerDetailsModel.gender = quickQuoteReqModel.genderCode;
      proposerDetailsModel.lastName = quickQuoteReqModel.lastname;
      proposerDetailsModel.firstName = quickQuoteReqModel.firstname;
      proposerDetailsModel.dobFormat.dob_yyyy_mm_dd = quickQuoteReqModel.dateOfBirth;
    }
    buyerDetails.proposerDetails = proposerDetailsModel;
    buyerDetails.nomineeDetailsModel = nomineeDetailsModel;
    buyerDetails.isNomineeMinor = isNomineeMinor;
    if (isNomineeMinor) {
      buyerDetails.appointeeDetailsModel = appointeeDetailsModel;
    } else {
      buyerDetails.appointeeDetailsModel = null;
    }
    widget.criticalIllnessModel.buyerDetails = buyerDetails;
  }

  Widget _showNextButton() {
    onClick() {
      switch (_pageCount == 4 ? _currentIndex : _currentIndex + 1) {
        case 0:
          _bloc.proposerDetailsWidgetSC.sink
              .add(CriticalIllnessInsuranceBuyerDetailsScreen.PROPOSER_DETAILS_WIDGET);
          break;
        case 1:
          _bloc.communicationWidgetSC.sink
              .add(CriticalIllnessInsuranceBuyerDetailsScreen.COMMUNICATION_DETAILS_WIDGET);
          break;
        case 2:
          _bloc.nominieeDetailsWidgetSC.sink
              .add(CriticalIllnessInsuranceBuyerDetailsScreen.NOMINEE_DETAILS_WIDGET);
          break;
        case 3:
          _bloc.appointeeDetailsWidgetSC.sink
              .add(CriticalIllnessInsuranceBuyerDetailsScreen.APPOINTEE_DETAILS_WIDGET);
          break;
      }
    }

    return BlackButtonWidget(
      onClick,
      S.of(context).next.toUpperCase(),
      bottomBgColor: ColorConstants.arogya_plus_si_edit_color,
    );
  }
}
