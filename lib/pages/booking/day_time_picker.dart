import 'package:flutter/material.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';

class DayTimePicker extends StatefulWidget {
  final Function(String day, String time) callback;


  DayTimePicker({Key? key, required this.callback}) : super(key: key);

  @override
  _DayTimePickerState createState() => _DayTimePickerState();
}

class _DayTimePickerState extends State<DayTimePicker> {

  String selectedDay = "";
  String time = "";

  @override
  Widget build(BuildContext context) {
    List<String> listDays = AppConstant.dayList;
    List<String> listHours = AppConstant.hourList;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 250,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              height: 40,
              width: double.maxFinite,
              child: ListView.builder(itemBuilder: (context,index)=>InkWell(
                onTap: (){
                  setState(() {
                    selectedDay = listDays[index];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 120,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(colorBlueGray)),
                    borderRadius: BorderRadius.circular(30),
                    color: selectedDay == listDays[index] ? const Color(colorBlueGray) : Colors.white
                  ),
                  child: Center(child: Text(listDays[index], style: TextStyle(color: selectedDay == listDays[index] ? Colors.white : Colors.black),)),
                ),
              ),itemCount: listDays.length,scrollDirection: Axis.horizontal,),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 40,
              width: double.maxFinite,
              child: ListView.builder(itemBuilder: (context,index)=>InkWell(
                onTap: (){
                  setState(() {
                    time = listHours[index];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 120,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(colorBlueGray)),
                    borderRadius: BorderRadius.circular(30),
                    color: time == listHours[index] ? const Color(colorBlueGray) : Colors.white
                  ),
                  child: Center(child: Text(listHours[index], style: TextStyle(color: time == listHours[index] ? Colors.white : Colors.black))),
                ),
              ),itemCount: listHours.length,scrollDirection: Axis.horizontal),
            ),
            SizedBox(height: 20,),
            MaterialButton(onPressed: ()=>widget.callback(selectedDay, time),child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Valider", style: TextStyle(color: Colors.white),)],
            ),color: Color(colorBlueGray),)
          ],
        ),
      ),
    );
  }
}
