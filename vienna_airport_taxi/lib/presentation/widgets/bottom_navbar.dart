import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/presentation/providers/auth_provider.dart';
import 'package:vienna_airport_taxi/core/utils/url_launcher_helper.dart';
import 'package:vienna_airport_taxi/core/localization/language_provider.dart';

class CustomBottomNavBar extends StatefulWidget {
  final LanguageProvider? languageProvider;

  const CustomBottomNavBar({super.key, this.languageProvider});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  // Start with no selection (-1). 'Logout' (index 4) will still appear active when logged in.
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final langProvider =
        widget.languageProvider ?? Provider.of<LanguageProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
              color: Color.fromARGB(218, 224, 224, 224), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNavItem(
            index: 0,
            icon: 'assets/images/header/phone_menu_icon.svg',
            label: 'Telefon',
            onTap: () async {
              await UrlLauncherHelper.launchPhone('+436763941949');
            },
          ),
          _buildNavItem(
            index: 1,
            icon: 'assets/images/header/email_menu_icon.svg',
            label: 'Email',
            onTap: () async {
              await UrlLauncherHelper.launchEmail(
                  'office@airport-wien-taxi.com');
            },
          ),
          _buildNavItem(
            index: 2,
            icon: 'assets/images/header/whatsapp_menu_icon.svg',
            label: 'WhatsApp',
            onTap: () async {
              await UrlLauncherHelper.launchWhatsApp('+436763941949');
            },
          ),
          _buildNavItem(
            index: 3,
            iconWidget: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SvgPicture.asset(
                langProvider.oppositeLanguageFlag,
                width: 24,
                height: 24,
              ),
            ),
            label: langProvider.locale.languageCode == 'de' ? 'EN' : 'DE',
            onTap: () {
              langProvider.changeLanguage(langProvider.oppositeLocale);
            },
          ),
          // _buildNavItem(
          //   index: 4,
          //   icon: auth.isAuthenticated
          //       ? 'assets/images/header/logout_icon.svg'
          //       : 'assets/images/header/login_icon.svg',
          //   label: auth.isAuthenticated ? 'Logout' : 'Login',
          //   onTap: () async {
          //     if (auth.isAuthenticated) {
          //       await auth.logout();
          //     } else {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(builder: (_) => const LoginScreen()),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    String? icon,
    Widget? iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    final auth = Provider.of<AuthProvider>(context);
    // Selected if tapped, or always if logged in for the Logout tab (index 4)
    final bool isSelected = _selectedIndex == index ||
        (auth.isAuthenticated && index == 4 && _selectedIndex < 0);
    final Color color =
        isSelected ? AppColors.primary : AppColors.textSecondary;
    final TextStyle textStyle = TextStyle(
      fontSize: 12,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      color: color,
    );

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          onTap();
        },
        child: Container(
          height: 85,
          padding: const EdgeInsets.only(bottom: 8),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget ??
                  SvgPicture.asset(
                    icon!,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
              const SizedBox(height: 4),
              Text(
                label,
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
