import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/drop_down.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/date_util.dart';

class CommonReportSearchDialog extends StatefulWidget {
  final String fromDate;
  final String toDate;
  final String? status;
  final String? serviceType;
  final String? inputFieldOneTile;
  final bool isMobileSearch;
  final List<String>? statusList;
  final List<String>? serviceTypeList;
  final bool isDateSearch;


  final Function(
      String fromDate,
      String toDate,
      String searchInput,
      String searchInputType,
      String status,
      String serviceType,
      String mobile) onSubmit;

  const CommonReportSearchDialog(
      {Key? key,
      required this.onSubmit,
      required this.fromDate,
      required this.toDate,
      this.status,
      this.inputFieldOneTile,
      this.isMobileSearch = false,
      this.statusList,
      this.serviceTypeList,
      this.serviceType = "All"  ,
      this.isDateSearch = true})
      : super(key: key);

  @override
  _SearchDialogWidgetState createState() => _SearchDialogWidgetState();
}

class _SearchDialogWidgetState extends State<CommonReportSearchDialog> {
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  var searchInputController = TextEditingController();
  var mobileController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var searchInput = "";
  var status = "";
  var searchInputType = "";
  var rechargeType = "";

  @override
  void initState() {
    super.initState();
    status = widget.status ?? "All";
    rechargeType = widget.serviceType ?? "All";
    fromDateController.text = widget.fromDate;
    toDateController.text = widget.toDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                filterTitleAndIcon(),
                if (widget.isDateSearch)
                  AppTextField(
                    controller: fromDateController,
                    label: "From Date",
                    onFieldTab: () {
                      DateUtil.showDatePickerDialog((dateInString) {
                        fromDateController.text = dateInString;
                      });
                    },
                  ),
                if (widget.isDateSearch)
                  AppTextField(
                    controller: toDateController,
                    label: "To Date",
                    onFieldTab: () {
                      DateUtil.showDatePickerDialog((dateInString) {
                        toDateController.text = dateInString;
                      });
                    },
                  ),
                (widget.status != null)
                    ? AppDropDown(
                        maxHeight: Get.height / 0.75,
                        list: widget.statusList ?? _listOfStatus,
                        label: "Select Status",
                        hint: "Select Status Search",
                        mode: Mode.BOTTOM_SHEET,
                        searchMode: false,
                        selectedItem:
                            (widget.status!.isNotEmpty) ? widget.status : null,
                        validator: (value) {
                          return null;
                        },
                        onChange: (value) {
                          status = value;
                        },
                      )
                    : SizedBox(),
                (widget.serviceTypeList != null)
                    ? AppDropDown(
                        maxHeight: 240,
                        list: widget.serviceTypeList!,
                        label: "Select Service Type",
                        hint: "Select Service Type",
                        mode: Mode.BOTTOM_SHEET,
                        searchMode: false,
                        selectedItem: rechargeType,
                        validator: (value) {
                          return null;
                        },
                        onChange: (value) {
                          rechargeType = value;
                          print("testDropDown : "+value);
                        },
                      )
                    : const SizedBox(),
                (widget.inputFieldOneTile == null)
                    ? const SizedBox()
                    : AppTextField(
                        controller: searchInputController,
                        label: widget.inputFieldOneTile,
                        hint: "Enter ${widget.inputFieldOneTile}",
                      ),
                (!widget.isMobileSearch)
                    ? const SizedBox()
                    : MobileTextField(
                        controller: mobileController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length == 10) {
                            return null;
                          } else {
                            return "Enter 10 digits mobile number";
                          }
                        },
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  var fromDate = fromDateController.text.toString();
                  var tomDate = toDateController.text.toString();
                  var searchInput = searchInputController.text.toString();
                  Get.back();
                  widget.onSubmit(
                      fromDate,
                      tomDate,
                      searchInput,
                      searchInputType,
                      (status == "All") ? "" : status,
                      rechargeType,
                      mobileController.text);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search),
                      Text("Search"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterTitleAndIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.filter_list),
          Text(
            "Filter",
            style: Get.textTheme.headline4,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    fromDateController.dispose();
    searchInputController.dispose();
    toDateController.dispose();
    super.dispose();
  }
}

var _listOfStatus = <String>[
  "All",
  "Success",
  "InProgress",
  "Initiated",
  "Failed",
  "Declined",
  "Refund Pending",
  "Refunded",
  "Scheduled",
];
