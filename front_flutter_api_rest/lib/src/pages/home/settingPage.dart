import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_shop.dart';
import 'package:front_flutter_api_rest/src/components/button_bar.dart';
import 'package:front_flutter_api_rest/src/components/drawers.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    final isLight = themeProvider.isDiurno;

    return Scaffold(
      appBar: AppBarShow(
        appBarColor: isLight ? themeColors[6] : themeColors[7],
      ),
      drawer: NavigationDrawerWidget(),
      backgroundColor: isLight ? themeColors[6] : themeColors[7],
      bottomNavigationBar: BottomNavBarFlex(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              'Configuración general',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isLight ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 25),

            // Tema claro/oscuro
            settingTile(
              context,
              icon: isLight ? CupertinoIcons.moon : CupertinoIcons.sun_max,
              label: 'Modo ${isLight ? "Oscuro" : "Claro"}',
              trailing: Switch(
                value: isLight,
                activeColor: Colors.greenAccent,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),

            const SizedBox(height: 15),
            settingTile(
              context,
              icon: Icons.notifications_none,
              label: 'Notificaciones',
              trailing: Icon(Icons.chevron_right, color: getTextColor(isLight)),
            ),
            settingTile(
              context,
              icon: Icons.language,
              label: 'Idioma',
              trailing: Text(
                'Español',
                style: TextStyle(color: getTextColor(isLight)),
              ),
            ),
            settingTile(
              context,
              icon: Icons.lock_outline,
              label: 'Privacidad',
              trailing: Icon(Icons.chevron_right, color: getTextColor(isLight)),
            ),
            settingTile(
              context,
              icon: Icons.security,
              label: 'Seguridad',
              trailing: Icon(Icons.chevron_right, color: getTextColor(isLight)),
            ),
            settingTile(
              context,
              icon: Icons.help_outline,
              label: 'Centro de ayuda',
              trailing: Icon(Icons.chevron_right, color: getTextColor(isLight)),
            ),
            settingTile(
              context,
              icon: Icons.info_outline,
              label: 'Acerca de la app',
              trailing: Icon(Icons.chevron_right, color: getTextColor(isLight)),
            ),
            InkWell(
              onTap: () {
                ShareApiTokenController.logout(context);
              },
              child: settingTile(
                context,
                icon: Icons.logout,
                label: 'Cerrar la sesión',
                trailing: Icon(
                  Icons.chevron_right,
                  color: getTextColor(isLight),
                ),
              ),
            ),
            // settingTile(
            //   context,
            //   icon: Icons.logout,
            //   label: '',
            //   trailing: Text(
            //     'Cerrar la sesión',
            //     style: TextStyle(color: getTextColor(isLight)),
            //   ),
            // ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Versión 1.0.0',
                style: TextStyle(
                  color: isLight ? Colors.black45 : Colors.white60,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget para cada ítem de configuración
  Widget settingTile(BuildContext context,
      {required IconData icon, required String label, Widget? trailing}) {
    final themeProvider = context.watch<ThemeProvider>();
    final isLight = themeProvider.isDiurno;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: isLight ? Colors.grey[200] : Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: isLight ? Colors.black87 : Colors.white70),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isLight ? Colors.black87 : Colors.white,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Color getTextColor(bool isLight) {
    return isLight ? Colors.black87 : Colors.white70;
  }
}
