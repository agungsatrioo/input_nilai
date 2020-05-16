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
import '../../utils/util_notifications.dart';
import '../../utils/util_useragent.dart';
import '../widgets/bottom_sheet/widget_bottomsheet_confirmation.dart';
import '../widgets/home_menu/widget_home_menus.dart';
import '../widgets/user_box/widget_userbox_dosen.dart';
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
  PackageInfo packageInfo;

  @override
  void initState() {
    super.initState();

    _ua = UserAgent();
    _initPackageInfo();
  }

  _initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  _getMenuDosen() => [
        HomeMenuItem(
          name: "Sidang Proposal",
          description: "Lihat dan beri penilaian proposal mahasiswa.",
          route: UPHomePageDosen(),
          icon: LineIcons.binoculars,
          iconColor: iconBlue1,
        ),
        HomeMenuItem(
          name: "Sidang Komprehensif",
          description: "Lihat dan beri penilaian komprehensif mahasiswa.",
          route: KomprehensifHomePageDosen(),
          icon: LineIcons.book,
          iconColor: iconGreen1,
        ),
        HomeMenuItem(
          name: "Sidang Munaqosah",
          description: "Lihat dan beri penilaian munaqosah mahasiswa.",
          route: MunaqosahHomeDosen(),
          icon: LineIcons.file_text,
          iconColor: iconRed1,
        ),
      ];

  _getMenuMahasiswa() => [
        HomeMenuItem(
          name: "Sidang Proposal",
          description: "Lihat penilaian proposal Anda.",
          route: UPHomePageMahasiswa(),
          icon: LineIcons.binoculars,
          iconColor: iconBlue1,
        ),
        HomeMenuItem(
          name: "Sidang Komprehensif",
          description: "Lihat penilaian komprehensif Anda.",
          route: KompreHomePageMahasiswa(),
          icon: LineIcons.book,
          iconColor: iconGreen1,
        ),
        HomeMenuItem(
          name: "Sidang Munaqosah",
          description: "Lihat dan beri penilaian munaqosah Anda.",
          route: MunaqosahHomePageMahasiswa(),
          icon: LineIcons.file_text,
          iconColor: iconRed1,
        ),
      ];

  _getMenuCommon() => [
        HomeMenuItem(
          name: "Ganti Tema",
          description: "Memungkinkan Anda untuk mengganti tema aplikasi.",
          route: () {
            showDialog(
                context: context,
                builder: (_) => ThemeConsumer(child: ThemeDialog()));
          },
          icon: LineIcons.paint_brush,
          iconColor: iconOrange1,
        ),
        HomeMenuItem(
          name: "Al Quran",
          description: "Baca Al-Quran sebelum sidang agar berkah.",
          route: QuranHomePage(),
          icon: Image.asset("assets/images/quran.png"),
        ),
        HomeMenuItem(
          name: "Juz Amma",
          description: "Baca Juz Amma sebelum sidang agar berkah.",
          route: QuranHomePage(
            juzAmma: true,
          ),
          icon: Image.asset("assets/images/juz_amma.gif"),
        ),
        HomeMenuItem(
            name: "Tentang Aplikasi Ini",
            description: "Melihat informasi aplikasi ini.",
            route: () {
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
            },
            icon: LineIcons.info_circle,
            iconColor: iconBlue3),
      ];

  @override
  Widget build(BuildContext context) {
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
              var homeWidgets = <Widget>[];

              if (state is UserLevelDosen) {
                homeWidgets.addAll([
                  UserBoxDosen(_ua),
                  HomeMenuGridListWidget(
                      menuList: [..._getMenuDosen(), ..._getMenuCommon()])
                ]);
              } else if (state is UserLevelMahasiswa) {
                homeWidgets.addAll([
                  UserBoxDosen(_ua),
                  HomeMenuGridListWidget(
                      menuList: [..._getMenuMahasiswa(), ..._getMenuCommon()])
                ]);
              } else if (state is InitializingState) {
                return LoadingWidget();
              }

              return Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...homeWidgets,
                  ],
                ),
              );
            },
          ),
        ));
  }
}
