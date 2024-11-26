import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/theme_service.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_search()],
      ),
    );
  }

  Widget _search() {
    return Row(
      children: [
        Container(
          width: 300,
          height: 36,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              // label: Text(''),
              hintText: S.current.pleaseInput + S.current.search,
              hintStyle: TextStyle(color: ThemeService.color.textSecondColor),
              prefix: Icon(Icons.search),
              filled: true,
              fillColor: ThemeService.color.secondBgColor,
              contentPadding: EdgeInsets.all(0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeService.color.secondBgColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeService.color.secondBgColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
            ),
            onTap: () {
              Get.toNamed(Routes.SEARCH);
            },
            onSubmitted: (val) {
              if (_searchController.text != "") {
                // activeID.value = _searchController.text;
                // indexValue.value = 10;
              }
              //  _getSongsbyName();
            },
          ),
        ),
      ],
    );
  }
}
