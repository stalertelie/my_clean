import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_clean/constants/img_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Country {
  final String? iso2Code;
  final String? iso3Code;
  final String? name;
  final String? dialCode;
  final double latitude;
  final double longitude;

  Country(
      {required this.iso2Code,
      required this.iso3Code,
      required this.name,
      required this.dialCode,
      required this.latitude,
      required this.longitude});
}

class SelectLanguageItem extends StatefulWidget {
  final VoidCallback? onTap;
  final BuildContext context;

  const SelectLanguageItem({Key? key, this.onTap, required this.context})
      : super(key: key);

  @override
  SelectLanguageItemState createState() => SelectLanguageItemState();
}

class SelectLanguageItemState extends State<SelectLanguageItem> {
  List<Country> countriesList = [];
  @override
  void initState() {
    _fetchCountryData().then((list) {
      setState(() {
        countriesList = list;
      });
    });
    super.initState();
  }

  Future<List<Country>> _fetchCountryData() async {
    var list = await DefaultAssetBundle.of(widget.context)
        .loadString('lib/assets/countries.json');
    List<dynamic> jsonList = json.decode(list);

    List<Country> countries = List<Country>.generate(jsonList.length, (index) {
      Map<String, dynamic> elem = Map<String, dynamic>.from(jsonList[index]);

      return Country(
          iso2Code: elem['alpha_2_code'],
          iso3Code: elem['alpha_3_code'],
          name: elem['en_short_name'],
          dialCode: elem['dial_code'],
          latitude: elem['latitude'],
          longitude: elem['longitude']);
    });

    countries.removeWhere((value) => value == null);

    return countries;
  }

  String getCountryFlag(String isoCode) {
    switch (isoCode) {
      case "CI":
        return ciFlag;
      case "RW":
        return rwandaFlag;
      case "SN":
        return senegalFlag;
      default:
        return tchadFlag;
    }
  }

  Future<void> storeCoordinates(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: countriesList.isNotEmpty
              ? countriesList
                  .map((country) => InkWell(
                        onTap: () async {
                          await storeCoordinates(
                              country.latitude, country.longitude);
                          if (widget.onTap != null) {
                            widget.onTap!();
                          }
                        },
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  country.name.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Image.asset(
                                  getCountryFlag(country.iso2Code.toString()),
                                  fit: BoxFit.fill,
                                  width: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList()
              : [Container()]),
    );
  }
}
