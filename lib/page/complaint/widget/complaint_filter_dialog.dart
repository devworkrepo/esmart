import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/res/style.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/drop_down.dart';

class ComplaintFilterDialog extends StatefulWidget {
  final String selectedInbox;
  final String selectedCategory;

  const ComplaintFilterDialog(
      {required this.selectedInbox, required this.selectedCategory, Key? key})
      : super(key: key);

  @override
  State<ComplaintFilterDialog> createState() => _ComplaintFilterDialogState();
}

class _ComplaintFilterDialogState extends State<ComplaintFilterDialog> {
  var selectedCategory = "";
  var selectedInbox = "";

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
    selectedInbox = widget.selectedInbox;
  }

  static const _categoryList = [
    "Money Transfer",
    "Utility",
    "AEPS/MATM/MPOS",
    "Credit Card",
    "Aadhar Pay",
    "Money Requests",
    "Statement",
    "Charges & Commission",
    "Other",
    "All Services"
  ];

  static const _inboxList = [
    "Complaint Inbox",
    "Open Complaints",
    "Closed Complaints",

  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyle.bottomSheetDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Filter",
              style: Get.theme.textTheme.headline5,
            ),
            AppDropDown(
              list: _inboxList,
              onChange: (value) {
                selectedInbox = value;
              },
              selectedItem:
                  (widget.selectedInbox.isEmpty) ? null : widget.selectedInbox,
              label: "Complaint Inbox",
              hint: "Select Inbox",
            ),
            const SizedBox(
              height: 12,
            ),
            AppDropDown(
              list: _categoryList,
              onChange: (value) {
                selectedCategory = value;
              },
              selectedItem: (widget.selectedCategory.isEmpty)
                  ? null
                  : widget.selectedCategory,
              label: "Service Category",
              hint: "Select Category",
            ),
            const SizedBox(
              height: 24,
            ),
            AppButton(
                text: "Filter",
                onClick: () {
                  Get.back(result: {
                    "category": selectedCategory,
                    "inbox": selectedInbox
                  });
                })
          ],
        ),
      ),
    );
  }
}
