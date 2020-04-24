import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:input_nilai/src/models/model_akademik.dart';
import 'package:input_nilai/src/ui/pages/munaqosah/page_munaqosah_detail.dart';
import 'package:input_nilai/src/ui/widgets/fancy_stuff/fancy_search_bar.dart';
import 'package:input_nilai/src/ui/widgets/widget_basic.dart';
import 'package:input_nilai/src/ui/widgets/widget_list_sidang.dart';
import 'package:input_nilai/src/utils/util_akademik.dart';
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
  bool _isHistory = false,
      _isRevisi = false;
  List<bool> _isTabSelected;
  List<int> tabNumbers;

  @override
  void initState() {
    super.initState();

    rest = RESTAkademik();

    _isTabSelected = [!_isHistory, _isRevisi, _isHistory];
    tabNumbers = [0, 0, 0];

    _refreshList();
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
        _isRevisi = false;
        _isTabSelected = [true, false, false];
      } else if (index == 1) {
        _isHistory = true;
        _isRevisi = true;
        _isTabSelected = [false, true, false];
      } else if (index == 2) {
        _isHistory = true;
        _isRevisi = false;
        _isTabSelected = [false, false, true];
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "Sidang Munaqosah",
          onCancelSearch: cancelSearch,
          onSearchQueryChanged: onSearchQueryChange,
          widgetList: <Widget>[
            IconButton(
              icon: Icon(LineIcons.refresh),
              onPressed: () {
                _refreshList();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
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
                    getStats(snapshot.data,
                      query: _query,
                      jmlBelumSidang: (val) {
                        tabNumbers[0] = val;
                      },
                      jmlRevisiSidang: (val) {
                        tabNumbers[1] = val;
                      },
                      jmlTuntasSidang: (val) {
                        tabNumbers[2] = val;
                      },
                    );
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ToggleButtons(
                            children: <Widget>[
                              Container(
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width - 36) / 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(
                                        "Belum sidang (${tabNumbers[0]})")),
                                  )),
                              Container(
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width - 36) / 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(
                                        "Revisi (${tabNumbers[1]})")),
                                  )),
                              Container(
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width - 36) / 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(
                                        "Tuntas sidang (${tabNumbers[2]})")),
                                  )),
                            ],
                            isSelected: _isTabSelected,
                            onPressed: (int index) {
                              onHistoryToggle(index);
                            },
                          ),
                        ),
                        Expanded(
                          child: makeSidangListView(context, snapshot.data,
                            query: _query,
                            isHistory: _isHistory,
                            isRevisi: _isRevisi,
                            onRefresh: () => _refreshList(),
                            onTap: (item) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ThemeConsumer(
                                              child: PageMunaqosahDetails(
                                                  item)))).then((val) {
                                if (val) _refreshList();
                              });
                            },
                          ),
                        )
                      ],
                    );
                  }
              }
            },
          ),
        ));
  }

  Future<void> _refreshList() async {
    onHistoryToggle(0);

    setState(() {
      _myFuture = rest.list_munaqosah;
    });
  }

  @override
  dispose() {
    super.dispose();
  }
}

