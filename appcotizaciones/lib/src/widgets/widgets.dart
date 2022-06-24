import 'package:appcotizaciones/src/utils/constants.dart';
import 'package:appcotizaciones/src/utils/size_config.dart';
import 'package:flutter/material.dart';

export 'package:appcotizaciones/src/widgets/auth_background.dart';
export 'package:appcotizaciones/src/widgets/card_container.dart';

Widget regularText(String title) {
  return Text(
    title,
  );
}

Widget regularTexthide2(String title) {
  return Container(
    color: Colors.grey,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget textField(
    String title, TextEditingController _controller, Function action) {
  return InkWell(
    onTap: () {
      print("tappped");
      action;
    },
    child: IgnorePointer(
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_today),
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          hintText: title,
          hintStyle: TextStyle(
            color: Constants.lightGrey,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Constants.secondaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Constants.secondaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Constants.secondaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Constants.secondaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}

Widget normalField(
    {String? hint,
    TextEditingController? controller,
    int? maxLine,
    TextInputType? inputType,
    Function? action,
    FormFieldValidator<String>? validator,
    bool? readOnly}) {
  return TextFormField(
    onChanged: (text) {
      try {
        action!(text);
      } catch (e) {}
    },
    readOnly: readOnly ?? false,
    keyboardType: inputType,
    maxLines: maxLine,
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      hintText: hint ?? "",
      hintStyle: TextStyle(
        color: Constants.lightGrey,
      ),
      border: (maxLine == 5)
          ? OutlineInputBorder(
              borderSide: BorderSide(
                  color: Constants.secondaryColor,
                  style: BorderStyle.solid,
                  width: 1),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(
                color: Constants.secondaryColor,
              ),
              // borderRadius: BorderRadius.circular(10),
            ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Constants.secondaryColor),
        // // borderRadius: BorderRadius.circular(10),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Constants.secondaryColor),
        // // borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Constants.secondaryColor),
        // // borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Widget greyField(
    {String? hint,
    TextEditingController? controller,
    FormFieldValidator<String>? validator}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    readOnly: true,
    decoration: InputDecoration(
      fillColor: Colors.grey.shade200,
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      hintText: hint ?? "",
      hintStyle: TextStyle(
        color: Constants.lightGrey,
      ),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    ),
  );
}

Widget coloredText(title) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(8),
    color: Colors.grey.shade400,
    child: Text(
      title,
      style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.4),
    ),
  );
}

Widget coloredTextHide(title) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(8),
    //color: Colors.grey.shade400,
    child: Text(
      title,
      style: TextStyle(
        fontSize: SizeConfig.textMultiplier * 1.4,
      ),
    ),
  );
}
