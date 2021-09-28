import 'package:flutter/material.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:velocity_x/velocity_x.dart';


class WidgetTemplate extends Object {
  /*static getAppBar({required String title}) => AppBar(
    title: Text(title,style: TextStyle(color: Colors.black),).tr(),
    iconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Colors.white,
  );*/

  static getInputStyle(String title) => InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: Colors.grey, width: 1)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: Colors.grey, width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: Colors.grey, width: 1)),
      labelText: title);



  static getInputStyleRounded(String title) => InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blue, width: 1)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blue, width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blue, width: 1)),
      isDense: true,
      contentPadding: EdgeInsets.all(10),
      labelText: title);

  static getActionButton({required String title, required VoidCallback callback,required Color color, double? fontSize}) => SizedBox(
      width: double.maxFinite,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        // ignore: unnecessary_null_comparison
        color: color,
        onPressed: callback,
        child: title.text.white.size(fontSize ?? 18).make(),
      ));

  static getActionButtonWithIcon({required String title, required VoidCallback callback,Color? color, IconData? ico,double? size}) => InkWell(
    child: MaterialButton(
      color: color ?? Color(0XFF02ABDE),
      onPressed: callback,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title.text.size(size ??20).bold.white.make(),
          ],
        ),
      ),
    ),
  );


  static Widget getEmptyBox({required String message, double? dimension}){
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("images/icons/empty_box.png",width: dimension ?? 200,height: dimension ?? 200,),
          SizedBox(height: 20,),
          message.text.make()
        ],
      ),
    );
  }

  static Future<DateTimeRange?> showDateRangeChooser (BuildContext ctx,DateTimeRange range) => showDateRangePicker(
    context: ctx,
    initialDateRange: range,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 30)),
    locale: Locale("fr"),
    saveText: "Valider",
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark(),
        child: child!,
      );
    },
  );

  static Future<TimeOfDay?> showTimeChoooser( BuildContext ctx) =>  showTimePicker(
    context: ctx,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark(),
        child: child!,
      );
    },
  );
}