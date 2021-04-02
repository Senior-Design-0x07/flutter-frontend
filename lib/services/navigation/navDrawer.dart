import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/navigation/routes.dart' as router;


class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Colors.green,
            height: 85,
            child: Center(
              child: DrawerHeader(
                child: Text(
                  'Page Navigation',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                decoration: BoxDecoration(color: Colors.green),
              ),
            ),
          ),
          ListTile(
            title: Text('Program Manager'),
            onTap: () {
              Navigator.pushReplacementNamed(context, router.ProgramManagerRoute);
            },
          ),
          ListTile(
            title: Text('Pin Manager'),
            onTap: () {
              Navigator.pushReplacementNamed(context, router.PinManagerRoute);
            },
          ),
          ListTile(
            title: Text('Connect to Wifi'),
            onTap: () {
              Navigator.pushReplacementNamed(context, router.WifiRoute);
            },
          ),
          ListTile(
            title: Text('Home Page'),
            onTap: () {
              Navigator.pushReplacementNamed(context, router.HomeRoute);
            },
          )
        ],
      ),
    );
  }
}
