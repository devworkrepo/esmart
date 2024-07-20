import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/drop_down.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/date_util.dart';

class CommonReportSearchDialog2 extends StatefulWidget {
  final String fromDate;
  final String toDate;
  final String? status;
  final String? inputFieldOneTile;
  final String? inputFieldTwoTile;
  final bool isMobileSearch;
  final List<String>? statusList;
  final List<String>? typeList;
  final bool isDateSearch;

  final Function(
      String fromDate,
      String toDate,
      String searchInputOne,
      String searchInputTwo,
      String searchInputType,
      String status,
      String rechargeType,
      String mobile) onSubmit;

  const CommonReportSearchDialog2(
      {Key? key,
      required this.onSubmit,
      required this.fromDate,
      required this.toDate,
      this.status,
      this.inputFieldOneTile,
      this.inputFieldTwoTile,
      this.isMobileSearch = false,
      this.statusList,
      this.typeList,
      this.isDateSearch = true})
      : super(key: key);

  @override
  _SearchDialogWidgetState createState() => _SearchDialogWidgetState();
}

class _SearchDialogWidgetState extends State<CommonReportSearchDialog2> {
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  var inputOneController = TextEditingController();
  var inputTwoController = TextEditingController();
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
                (widget.typeList != null)
                    ? AppDropDown(
                        maxHeight: 240,
                        list: widget.typeList!,
                        label: "Select Recharge Type",
                        hint: "Select Recharge Type",
                        mode: Mode.BOTTOM_SHEET,
                        searchMode: false,
                        validator: (value) {
                          return null;
                        },
                        onChange: (value) {
                          rechargeType = value;
                        },
                      )
                    : const SizedBox(),
                (widget.inputFieldOneTile == null)
                    ? const SizedBox()
                    : AppTextField(
                        controller: inputOneController,
                        label: widget.inputFieldOneTile,
                        hint: "Enter ${widget.inputFieldOneTile}",
                      ),
                (widget.inputFieldTwoTile == null)
                    ? const SizedBox()
                    : AppTextField(
                  controller: inputTwoController,
                  label: widget.inputFieldTwoTile,
                  hint: "Enter ${widget.inputFieldTwoTile}",
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
                  var searchInputOne = inputOneController.text.toString();
                  var searchInputTwo = inputTwoController.text.toString();
                  Get.back();
                  widget.onSubmit(
                      fromDate,
                      tomDate,
                      searchInputOne,
                      searchInputTwo,
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
    inputOneController.dispose();
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
