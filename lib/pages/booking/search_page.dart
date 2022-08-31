import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_clean/models/GoogleSearch/google_result.dart';
import 'package:my_clean/models/GoogleSearch/google_search_result.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/pages/booking/search_bloc.dart';
import 'package:my_clean/services/localization.dart';

class SearchPage extends StatefulWidget {
  final Function(GoogleResult feature) callBack;

  SearchPage({required this.callBack});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                hintText: AppLocalizations.current.enterAnAdress,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                prefixIconConstraints:
                    const BoxConstraints(maxHeight: 40, maxWidth: 40),
                prefixIcon: SvgPicture.asset(
                  'images/icons/map-marker.svg',
                  width: 40,
                )),
            onChanged: (String? value) {
              if (value != null && value.length >= 2) {
                _bloc.mapsearchSubject.add(value);
              }
            },
          ),
        ),
        Expanded(
            child: StreamBuilder<Loading>(
                stream: _bloc.loading,
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data!.loading! == false
                      ? StreamBuilder<GoogleSearchResult>(
                          stream: _bloc.featuresStream,
                          builder: (context, snapshot2) {
                            return snapshot2.hasData
                                ? ListView.separated(
                                    itemBuilder: (context, index) => ListTile(
                                          title: Text(snapshot2
                                                  .data!.results![index].name ??
                                              ""),
                                          onTap: () {
                                            widget.callBack(snapshot2
                                                .data!.results![index]);
                                          },
                                        ),
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    itemCount: snapshot2.data!.results!.length)
                                : Container();
                          })
                      : snapshot.hasData
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container();
                }))
      ],
    );
  }
}
