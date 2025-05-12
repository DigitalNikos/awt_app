// lib/presentation/widgets/bottom_navbar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/providers/auth_provider.dart';
import 'package:vienna_airport_taxi/presentation/screens/auth/login_screen.dart';
import 'package:vienna_airport_taxi/core/utils/url_launcher_helper.dart';
import 'package:vienna_airport_taxi/core/localization/language_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final LanguageProvider? languageProvider;

  const CustomBottomNavBar({
    Key? key,
    this.languageProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no provider is passed, get it from the context
    final langProvider =
        languageProvider ?? Provider.of<LanguageProvider>(context);

    return Container(
      height: 72, // Increased height to match your web design
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: 'assets/images/header/phone_menu_icon.svg',
            label: 'Telefon',
            onTap: () async {
              await UrlLauncherHelper.launchPhone('+436763941949');
            },
          ),
          _buildNavItem(
            context,
            icon: 'assets/images/header/email_menu_icon.svg',
            label: 'Email',
            onTap: () async {
              await UrlLauncherHelper.launchEmail(
                  'office@airport-wien-taxi.com');
            },
          ),
          _buildNavItem(
            context,
            icon: 'assets/images/header/whatsapp_menu_icon.svg',
            label: 'WhatsApp',
            onTap: () async {
              await UrlLauncherHelper.launchWhatsApp('+436763941949');
            },
          ),
          // Language selector button (moved from app bar)
          _buildLanguageItem(context, langProvider),
          // Login/Logout button
          _buildLoginItem(context),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required String icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(
      BuildContext context, LanguageProvider langProvider) {
    return InkWell(
      onTap: () {
        langProvider.changeLanguage(langProvider.oppositeLocale);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Using the flag as icon
          Text(
            langProvider.oppositeLanguageFlag,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            // Show EN or DE depending on current language
            langProvider.locale.languageCode == 'de' ? 'EN' : 'DE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginItem(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) => InkWell(
        onTap: () async {
          if (auth.isAuthenticated) {
            await auth.logout();
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use SVG icon instead of Icon widget
            SvgPicture.asset(
              auth.isAuthenticated
                  ? 'assets/images/header/logout_icon.svg' // Use your custom logout icon
                  : 'assets/images/header/login_icon.svg', // Use your custom login icon
              width: 24,
              height: 24,
              // You can set a color override if needed
              // colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              auth.isAuthenticated ? 'Logout' : 'Login',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
