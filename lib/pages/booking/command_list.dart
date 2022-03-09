// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/components/custom_dialog.dart';
import 'package:my_clean/components/loader.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/img_urls.dart';
import 'package:my_clean/models/entities/booking/booking.dart';
import 'package:my_clean/models/responses/get-booking-response/get_booking_response.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/booking/components/command_list_item.dart';
import 'package:my_clean/services/booking_api.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:velocity_x/src/extensions/iterable_ext.dart';

class CommandList extends StatefulWidget {
  const CommandList({Key? key}) : super(key: key);

  @override
  CommandListState createState() => CommandListState();
}

class CommandListState extends State<CommandList> {
  bool loading = true;
  bool loadingMoreLoader = false;

  List<Booking>? commands = [];

  int page = 1;

  final BookingApi bookingApi = Ioc().use('bookingApi');

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialog(contextProp: context, messageProp: message);
      },
    );
  }

  _getUser() async {
    String? data = await UtilsFonction.getData(AppConstant.USER_INFO);
    final User? user = data != null ? User.fromJson(jsonDecode(data)) : null;
    if (user != null) {
      getUserCommandsList(user.id);
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void getUserCommandsList(String? userId) async {
    try {
      GetBookingResponse bookingResponse =
          await bookingApi.getCommandList(id: userId!.substring(7), page: 1);

      if (bookingResponse.hydraMember!.isNotEmpty) {
        setState(() {
          loading = false;
          commands = bookingResponse.hydraMember;
        });
      } else {
        setState(() {
          loading = false;
          commands = [];
        });
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      _showDialog(error.toString());
    }
  }

  Widget _buildCommandList() {
    return commands!.isEmpty
        ? Container(
            alignment: Alignment.center,
            child: Text(AppLocalizations.current.noOrders),
          )
        : Column(
            children: commands!
                .mapIndexed((command, index) => Container(
                      margin: const EdgeInsets.all(5),
                      child: CommandListItem(command: command),
                    ))
                .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorGreyShadeLight,
      appBar: TabAppBar(
          titleProp: AppLocalizations.current.myOrders,
          titleFontSize: 18,
          context: context,
          centerTitle: true,
          showBackButton: false),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    loading = true;
                  });
                  _getUser();
                },
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          loading
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width / 2.1 +
                                          37 +
                                          20,
                                  child: Center(
                                      child: Loader(size: 40, strokeWidth: 4)),
                                )
                              : _buildCommandList()
                        ],
                      )),
                )),
          )
        ],
      )),
    );
  }
}
