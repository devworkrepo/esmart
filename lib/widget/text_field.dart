import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/input_validator.dart';
import 'package:esmartbazaar/util/validator.dart';

class AppTextField extends StatefulWidget {
  static var numberOnly = [FilteringTextInputFormatter.allow(RegExp("[0-9]"))];

  final String? hint;
  final String? label;
  final int? width;
  final IconData? prefixIcon;
  final int? maxLength;
  final bool focus;
  final int? fontSize;
  final FontWeight? fontWeight;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final bool enable;
  final bool allCaps;
  final VoidCallback? onFieldTab;
  final Widget? rightButton;
  final List<TextInputFormatter>? inputFormatters;
  final Function? onChange;
  final bool passwordMode;

  const AppTextField({
    this.hint,
    this.fontSize,
    this.fontWeight,
    this.width,
    this.label,
    this.maxLength,
    this.validator,
    this.focus = false,
    this.rightButton,
    this.allCaps = false,
    this.textInputAction = TextInputAction.next,
    this.enable = true,
    this.prefixIcon,
    this.inputFormatters,
    this.inputType,
    this.onFieldTab,
    this.onChange,
    this.passwordMode = false,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  var passwordVisibility = true;

  _buildSuffixIcon() {
    return InkResponse(
      onTap: () {
        setState(() {
          passwordVisibility = !passwordVisibility;
        });
      },
      child:
          Icon((passwordVisibility) ? Icons.visibility : Icons.visibility_off),
    );
  }

  @override
  Widget build(BuildContext context) {
    var maxLength = widget.maxLength ?? 256;
    var textInputType = widget.inputType ?? TextInputType.text;

    var hint = widget.hint ?? "Required*";
    var label = widget.label ?? "text";

    final decoration = buildInputDecoration(widget.passwordMode, hint, label);
    var textStyle = TextStyle(
        fontSize: widget.fontSize?.toDouble() ?? 14,
        fontWeight: widget.fontWeight ?? FontWeight.w400);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: widget.onFieldTab,
        child: IgnorePointer(
          ignoring: widget.onFieldTab != null,
          child: TextFormField(
            onChanged: (value) {
              if (widget.onChange != null) {
                widget.onChange!(value);
              }
            },
            inputFormatters: widget.inputFormatters,
            textCapitalization: (widget.allCaps)
                ? TextCapitalization.characters
                : TextCapitalization.none,
            autofocus: widget.focus,
            enabled: widget.enable,
            textInputAction: widget.textInputAction,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            controller: widget.controller,
            maxLines: 1,
            maxLength: maxLength,
            keyboardType: textInputType,
            obscureText: (widget.passwordMode && passwordVisibility),
            style: textStyle,
            decoration: decoration,
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(
      bool isPassword, String hint, String label) {
    return InputDecoration(
      counterStyle: const TextStyle(
        height: double.minPositive,
      ),
      counterText: "",
      label: Text(label),
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      errorStyle:
          TextStyle(fontWeight: FontWeight.w500, color: Colors.red[800],fontSize: 12),
      hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey),
      prefixIcon: Icon(widget.prefixIcon ?? Icons.input),
      suffixIcon: (isPassword)
          ? _buildSuffixIcon()
          : (widget.rightButton != null)
              ? Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: (widget.rightButton! is CircularProgressIndicator)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [CircularProgressIndicator()],
                        )
                      : widget.rightButton!,
                )
              : null,
      hintText: hint,
      border: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
    )
    );
  }
}

class AmountTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?)? validator;
  final bool enable;
  final bool focus;
  final String hint;
  final String label;
  final bool isDecimal;
  final Function(String)? onChange;

  const AmountTextField(
      {required this.controller,
      this.validator,
      this.focus = false,
      this.enable = true,
      this.isDecimal = false,
      this.hint = "Enter ₹ 0.0",
      this.label = "Amount",
      this.onChange,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      maxLength: 10,
      enable: enable,
      focus: focus,
      onChange: onChange,
      inputFormatters: (isDecimal)
          ? [AmountInputValidator()]
          : [FilteringTextInputFormatter.digitsOnly, AmountInputValidator()],
      hint: hint,
      label: label,
      fontSize: 24,
      inputType: TextInputType.number,
      validator: (value) {
        if (value == null) {
          return "Amount is required*";
        }
        if (value == "") {
          return "Enter amount";
        }

        if (validator == null) {
          return null;
        } else {
          var a = value.substring(2);
          return validator!(a);
        }
      },
    );
  }
}

class AmountOutlineTextField extends StatelessWidget {
  final String hint;
  final String label;
  final Function(String?)? validator;
  final TextEditingController controller;

  const AmountOutlineTextField(
      {Key? key,
      required this.controller,
      this.validator,
      this.hint = 'Enter ₹ 0.0',
      this.label = "Amount"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) {
          return "Amount is required*";
        }
        if (value == "") {
          return "Enter amount";
        }

        if (validator == null) {
          return null;
        } else {
          var a = value.substring(2);
          return validator!(a);
        }
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        AmountInputValidator()
      ],
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
        ),
        hintText: hint,
      ),
    );
  }
}

class AmountOutlineTextFieldMini extends StatelessWidget {
  final String hint;
  final String label;
  final Function(String?)? onChange;

  const AmountOutlineTextFieldMini(
      {Key? key,

        this.onChange,
        this.hint = 'Enter ₹ 0.0',
        this.label = "Amount"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value){
        if(onChange!=null) onChange!(value);
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        AmountInputValidator()
      ],
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        contentPadding:
        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
        label: Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
        ),
        hintText: hint,
      ),
    );
  }
}

class MobileTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool focus;
  final bool enable;
  final Function(String)? onChange;
  final Function(String?)? validator;
  final Widget? rightButton;
  final String label;

  const MobileTextField(
      {required this.controller,
      this.focus = false,
      this.onChange,
      this.validator,
      this.rightButton,
      this.enable = true,
      Key? key,
      this.label = "Mobile Number"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      maxLength: 10,
      enable: enable,
      focus: focus,
      prefixIcon: Icons.mobile_friendly,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      hint: "Enter 10 digits",
      label: label,
      inputType: TextInputType.number,
      rightButton: rightButton,
      onChange: onChange,
      validator: (value) => (validator == null)
          ? FormValidatorHelper.mobileNumberValidation(value)
          : validator!(value),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool focus;
  final bool enable;
  final String label;
  final String hint;
  final Function(String)? onChange;
  final Function(String?)? validator;
  final Widget? rightButton;

  const PasswordTextField(
      {required this.controller,
      this.focus = false,
      this.enable = true,
      this.onChange,
      this.validator,
      this.rightButton,
      this.label = "Password",
      this.hint = "Password is required*",
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
        controller: controller,
        prefixIcon: Icons.lock,
        enable: enable,
        onChange: onChange,
        focus: focus,
        rightButton: rightButton,
        hint: hint,
        label: label,
        passwordMode: true,
        inputType: TextInputType.visiblePassword,
        validator: (value) => (validator != null)
            ? validator!(value)
            : FormValidatorHelper.passwordValidation(value));
  }
}

class OtpTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool focus;
  final bool enable;
  final int maxLength;
  final Function(String)? onChange;
  final Widget? rightButton;

  const OtpTextField(
      {required this.controller,
      this.focus = false,
      this.enable = true,
      this.maxLength = 6,
      this.onChange,
      this.rightButton,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      maxLength: maxLength,
      enable: enable,
      focus: focus,
      prefixIcon: Icons.password,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      label: "Otp",
      hint: "Enter $maxLength digits otp",
      passwordMode: true,
      inputType: TextInputType.number,
      validator: (value) =>
          FormValidatorHelper.otpValidation(value, digit: maxLength),
    );
  }
}

class MPinTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool focus;
  final bool enable;
  final Function(String)? onChange;
  final Widget? rightButton;
  final String label;
  final String hint;

  const MPinTextField(
      {required this.controller,
      this.focus = false,
      this.enable = true,
      this.onChange,
      this.rightButton,
        this.label = "MPIN",
        this.hint = "4 - 6 digits mpin",
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      maxLength: 6,
      enable: enable,
      focus: focus,
      prefixIcon: Icons.password,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      label: label,
      hint: hint,
      passwordMode: true,
      inputType: TextInputType.number,
      validator: (value) => (value!.length > 3 && value.length < 7)
          ? null
          : "Enter valid 4 - 6 digits MPIN",
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool focus;
  final bool enable;
  final Function(String)? onChange;
  final Widget? rightButton;

  const EmailTextField(
      {required this.controller,
      this.focus = false,
      this.enable = true,
      this.onChange,
      this.rightButton,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      enable: enable,
      focus: focus,
      prefixIcon: Icons.email,
      label: "Email",
      hint: "xyz@abc.com",
      inputType: TextInputType.emailAddress,
      validator: (value) => FormValidatorHelper.emailValidation(value),
    );
  }
}

class DobTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool enable;

  const DobTextField({required this.controller, Key? key, this.enable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
        hint: "dd/mm/yyyy",
        label: "Date of Birth",
        inputType: TextInputType.datetime,
        validator: (value) {
          const msg = "Select Dob";
          if (value == null) {
            return msg;
          }
          if (value.isEmpty) {
            return msg;
          } else {
            return null;
          }
        },
        onFieldTab: () {
          if (!enable) return;
          showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime(1998),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now())
              .then((pickedDate) {
            if (pickedDate != null) {
              controller.text = pickedDate.day.toString() +
                  "/" +
                  pickedDate.month.toString() +
                  "/" +
                  pickedDate.year.toString();
            }
          });
        },
        controller: controller);
  }
}

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChange;
  final bool focus;

  const AppSearchField(
      {Key? key, this.controller, this.onChange, this.focus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        enableInteractiveSelection: false,
        onChanged: onChange,
        autofocus: focus,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding:
                EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
            suffix: Icon(
              Icons.search,
              color: Colors.grey,
            )),
      ),
    );
  }
}

class AadhaarTextField extends StatelessWidget {
  final TextEditingController controller;

  const AadhaarTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
        inputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          AadhaarInputValidator()
        ],
        maxLength: 14,
        hint: "Aadhaar number",
        label: "Aadhaar Number",
        validator: (value) {
          if (value!.length == 14) {
            return null;
          } else {
            return "Enter 12 digits aadhaar number";
          }
        },
        controller: controller);
  }
}

class CardTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool enable;

  const CardTextField({Key? key, required this.controller, this.enable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
        enable: enable,
        inputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          AadhaarInputValidator()
        ],
        maxLength: 19,
        hint: "Required*",
        label: "Card Number",
        validator: (value) {
          if (value!.length == 18 || value.length == 19) {
            return null;
          } else {
            return "Enter 15 - 16 digits card number";
          }
        },
        controller: controller);
  }

  bool validateCreditCardNumber(String input) {
    input = input.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^[0-9]+$').hasMatch(input) || input.length < 13 || input.length > 19) {
      return false;
    }
    int sum = 0;
    bool alternate = false;

    for (int i = input.length - 1; i >= 0; i--) {
      int n = int.parse(input[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return (sum % 10 == 0);
  }
}
