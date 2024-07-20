import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDropDown extends StatelessWidget {
  final List<String> list;
  final String hint;
  final String label;
  final Mode mode;
  final bool searchMode;
  final double? maxHeight;
  final Function(String?)? validator;
  final Function(String) onChange;
  final String? selectedItem;
  final bool hideLabel;

  const AppDropDown(
      {required this.list,
        required this.onChange,
        this.hint = "Required*",
        this.label = "Label",
        this.validator,
        this.hideLabel = false,
        this.searchMode = true,
        this.maxHeight,
        this.mode = Mode.BOTTOM_SHEET,
        this.selectedItem,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownSearch<String>(
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration:  InputDecoration(
              errorStyle: TextStyle(color: Colors.red[900],fontWeight: FontWeight.w500,fontSize: 12),
              prefixIcon: const Icon(Icons.input),
              label: Text(label),
              labelStyle: const TextStyle(fontWeight: FontWeight.w500,fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              alignLabelWithHint: false,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                ),
            )
        ),
        //showSelectedItems: true,
        items: list,
        dropdownBuilder:  (context,item){
          if(item == null) return const SizedBox();
          return Text(item.toString(),style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400),);
        },

        autoValidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (validator != null) {
            return validator!(value);
          } else {
            if (value == null) {
              return "select $label";
            }
            if (value == "") {
              return "select $label";
            } else {
              return null;
            }
          }
        },
        selectedItem: selectedItem,
        onChanged: (value) => onChange(value.toString()),
        popupProps: const PopupProps.modalBottomSheet(
            showSearchBox: true,
            searchDelay: Duration.zero,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(hintText: "Search"),
            ),

            modalBottomSheetProps: ModalBottomSheetProps(
                constraints: BoxConstraints.expand(),
                useSafeArea: true
            )
        ),
      ),
    );
  }
}
