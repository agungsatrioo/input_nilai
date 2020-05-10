import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../models/menus.dart';
import '../../utils/blocs/auth/util_authevent.dart';
import '../../utils/blocs/user_level/util_levelevent.dart';
import '../../utils/blocs/user_level/util_levelstate.dart';
import '../../utils/util_blocs.dart';
import '../../utils/util_colors.dart';
import '../../utils/util_common.dart';
import '../../utils/util_notifications.dart';
import '../../utils/util_useragent.dart';
import '../widgets/bottom_sheet/widget_bottomsheet_confirmation.dart';
import '../widgets/home_menu/widget_home_menus.dart';
import '../widgets/user_box/widget_userbox_dosen.dart';
import '../widgets/user_box/widget_userbox_mhs.dart';
import '../widgets/widget_loading.dart';
import '../widgets/widget_univ_logo.dart';
import 'kompre/page_kompre_home_dosen.dart';
import 'kompre/page_kompre_home_mhs.dart';
import 'munaqosah/page_munaqosah_home_dosen.dart';
import 'munaqosah/page_munaqosah_home_mhs.dart';
import 'quran/page_quran_home.dart';
import 'up/page_up_home_dosen.dart';
import 'up/page_up_home_mhs.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  createState() {
    flutterLocalNotificationsPlugin =
        NotificationUtils.object.flutterLocalNotificationsPlugin;

    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  UserAgent _ua;
  List<HomeMenu> _menuList;

  @override
  void initState() {
    super.initState();
    _ua = UserAgent();
    _menuList = List();
  }

  _addMenuDosen() {
    _menuList.add(HomeMenu(
        "Sidang Proposal",
        "Lihat dan beri penilaian proposal mahasiswa.",
        LineIcons.binoculars,
        UPHomePageDosen(),
        iconBlue1));

    _menuList.add(HomeMenu(
        "Sidang Komprehensif",
        "Lihat dan beri penilaian terhadap kemampuan komprehensif mahasiswa.",
        LineIcons.book,
        KomprehensifHomePageDosen(),
        iconGreen1));

    _menuList.add(HomeMenu(
        "Sidang Munaqosah",
        "Lihat dan beri penilian terhadap munaqosah mahasiswa.",
        LineIcons.book,
        MunaqosahHomeDosen(),
        iconPurple1));

    _addMenuCommon();
  }

  _addMenuMahasiswa() {
    _menuList.add(HomeMenu(
        "Sidang Proposal",
        "Lihat penilaian terhadap proposal Anda.",
        LineIcons.binoculars,
        UPHomePageMahasiswa(),
        iconBlue1));

    _menuList.add(HomeMenu(
        "Sidang Komprehensif",
        "Lihat dan beri penilaian terhadap kemampuan komprehensif Anda.",
        LineIcons.book,
        KompreHomePageMahasiswa(),
        iconGreen1));

    _menuList.add(HomeMenu(
        "Sidang Munaqosah",
        "Lihat  penilian terhadap munaqosah Anda.",
        LineIcons.book,
        MunaqosahHomePageMahasiswa(),
        iconRed1));

    _addMenuCommon();
  }

  _addMenuCommon() {
    _menuList.addAll([
      HomeMenu("Ganti Tema", "Memungkinkan Anda untuk mengganti tema aplikasi.",
          LineIcons.paint_brush, () {
        showDialog(
            context: context,
            builder: (_) => ThemeConsumer(child: ThemeDialog()));
      }, iconOrange1),
      HomeMenu("Al Quran", "Baca Al-Quran sebelum sidang.",
          Image.asset("assets/images/quran.png"), QuranHomePage(), iconOrange1),
      HomeMenu(
          "Juz Amma",
          "Baca Juz Amma sebelum sidang.",
          Image.asset("assets/images/juz_amma.gif"),
          QuranHomePage(
            juzAmma: true,
          ),
          iconOrange1),
      HomeMenu("Tentang Aplikasi Ini", "Melihat info aplikasi ini.",
          LineIcons.info_circle, () {
        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          String appName = packageInfo.appName;
          String version = packageInfo.version;
          String buildNumber = packageInfo.buildNumber;

          showAboutDialog(
            context: context,
            applicationIcon: Image.asset(
              "assets/images/icon.png",
              scale: 10,
            ),
            applicationName: appName,
            applicationVersion: '$version.$buildNumber',
            applicationLegalese: '© 2020 Agung Satrio Budi Prakoso',
          );
        });
      }, hexToColor("#585858"))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _addMenuCommon();

    return Scaffold(
        appBar: AppBar(
          title: WidgetUnivLogo(),
          actions: <Widget>[
            IconButton(
              icon: Icon(LineIcons.sign_out,
                  color: ThemeProvider.themeOf(context).data.iconTheme.color),
              onPressed: () {
                showConfirmationBottomSheet(context,
                        isDismissible: false,
                        caption: Text(
                            "Apakah Anda yakin akan logout dari aplikasi ini? "
                                "Pastikan Anda telah menyelesaikan semua pekerjaan Anda sebelum "
                                "logout."))
                    .then((val) {
                  if (val)
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                });
              },
            )
          ],
        ),
        body: BlocProvider<UserLevelBloc>(
          create: (ctx) => UserLevelBloc(userAgent: _ua)..add(InitLevelEvent()),
          child: BlocBuilder<UserLevelBloc, UserLevelState>(
            builder: (context, state) {
              _menuList.clear();
              List homeWidgets = <Widget>[];
              if (state is UserLevelDosen) {
                _addMenuDosen();
                homeWidgets.add(UserBoxDosen(_ua));
              } else if (state is UserLevelMahasiswa) {
                _addMenuMahasiswa();
                homeWidgets.add(UserBoxMahasiswa(_ua));
              } else if (state is InitializingState) {
                return LoadingWidget();
              }

              return Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: homeWidgets..add(HomeCardMenus(_menuList)),
                ),
              );
            },
          ),
        ));
  }
}

/*

 */
