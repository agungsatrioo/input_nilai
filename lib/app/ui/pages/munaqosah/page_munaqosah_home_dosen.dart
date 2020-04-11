import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:input_nilai/app/models/model_akademik.dart';
import 'package:input_nilai/app/ui/pages/munaqosah/page_munaqosah_detail.dart';
import 'package:input_nilai/app/ui/widgets/fancy_stuff/fancy_search_bar.dart';
import 'package:input_nilai/app/ui/widgets/widget_basic.dart';
import 'package:input_nilai/app/ui/widgets/widget_list_sidang.dart';
import 'package:input_nilai/app/utils/util_akademik.dart';
import 'package:line_icons/line_icons.dart';
import 'package:theme_provider/theme_provider.dart';

class MunaqosahHomeDosen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MunaqosahHomeDosenState();
}

class _MunaqosahHomeDosenState extends State<MunaqosahHomeDosen>
    with SingleTickerProviderStateMixin {
  final key = GlobalKey<ScaffoldState>();

  Future<List<ModelMhsSidang>> _myFuture;
  RESTAkademik rest;

  String _query = "";
  bool _isHistory = false;
  List<bool> _isTabSelected;

  @override
  void initState() {
    super.initState();

    rest = RESTAkademik();

    _myFuture = rest.list_munaqosah;
    _isTabSelected = [!_isHistory, _isHistory];
  }

  cancelSearch() {
    setState(() {
      _query = "";
    });
  }

  onSearchQueryChange(String query) {
    setState(() {
      _query = query;
    });
  }

  onHistoryToggle(int index) {
    setState(() {
      if (index == 0) {
        _isHistory = false;
        _isTabSelected = [true, false];
      } else if (index == 1) {
        _isHistory = true;
        _isTabSelected = [false, true];
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "Ujian Munaqosah",
          onCancelSearch: cancelSearch,
          onSearchQueryChanged: onSearchQueryChange,
          widgetList: <Widget>[
            IconButton(
              icon: Icon(LineIcons.refresh),
              onPressed: _refreshList,
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ToggleButtons(
                children: <Widget>[
                  Container(
                      width: (MediaQuery.of(context).size.width - 20) / 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("Belum sidang")),
                      )),
                  Container(
                      width: (MediaQuery.of(context).size.width - 20) / 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("Sudah sidang")),
                      )),
                ],
                isSelected: _isTabSelected,
                onPressed: (int index) {
                  onHistoryToggle(index);
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshList,
                child: FutureBuilder<List<ModelMhsSidang>>(
                  future: _myFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ModelMhsSidang>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return loading();
                      default:
                        if (snapshot.hasError) {
                          print(snapshot.error.toString());
                          return center_text(
                              "Gagal memuat daftar mahasiswa Ujian Munaqosah.");
                        } else if (snapshot.data.length < 1)
                          return center_text("Tidak ada data.");
                        else {
                          return makeSidangListView(context, snapshot.data,
                              query: _query,
                              isHistory: _isHistory,
                              onRefresh: () => _refreshList(),
                              onTap: (item) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ThemeConsumer(
                                            child:
                                                PageMunaqosahDetails(item))));
                              });
                        }
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _refreshList() async {
    onHistoryToggle(0);
    setState(() async {
      _myFuture = rest.list_munaqosah;
    });
  }

  @override
  dispose() {
    super.dispose();
  }
}
