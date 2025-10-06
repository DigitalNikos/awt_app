// lib/presentation/widgets/footer/app_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      child: Column(
        children: [
          // Main footer content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 0),
            constraints: const BoxConstraints(maxWidth: 600),
            child: _buildMobileFooter(context, localizations),
          ),

          // Copyright section
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 48),
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              localizations.translate('footer.copyright'),
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF888888),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFooter(
      BuildContext context, AppLocalizations? localizations) {
    return Column(
      children: [
        _buildCompanyColumn(context, localizations),
        const SizedBox(height: 48),
        _buildNavigationColumn(context, localizations),
        const SizedBox(height: 48),
        _buildUsefulLinksColumn(context, localizations),
        const SizedBox(height: 48),
        _buildContactColumn(context, localizations),
      ],
    );
  }

  Widget _buildCompanyColumn(
      BuildContext context, AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: SvgPicture.asset(
            'assets/images/footer/logo.svg',
            width: 240,
            height: 60,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => Image.asset(
              'assets/images/logo.png',
              width: 240,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 240,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'AWT',
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Company info
        Text(
          '${localizations?.translate('footer.company_label') ?? 'Firma:'} ${localizations?.translate('footer.company_name') ?? 'Airport Wien Taxi'}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF666666),
            fontSize: 15,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          localizations?.translate('footer.company_info') ??
              'Professional Airport Transfer Service',
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF666666),
            fontSize: 15,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Address
        Text(
          localizations?.translate('footer.company_address') ??
              'Musterstraße 123',
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF666666),
            fontSize: 15,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${localizations?.translate('footer.company_zipcode') ?? '1010'} ${localizations?.translate('footer.company_city') ?? 'Wien'}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF666666),
            fontSize: 15,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'UID: ${localizations?.translate('footer.uid_number') ?? 'ATU12345678'}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF666666),
            fontSize: 15,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // Social media links
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(
              'assets/images/footer/facebook_icon.svg',
              () => _launchUrl('https://facebook.com'),
              localizations?.translate('footer.facebook_label') ??
                  'Visit our Facebook page',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              'assets/images/footer/instagram_icon.svg',
              () => _launchUrl('https://www.instagram.com/awt.transfer/'),
              localizations?.translate('footer.instagram_label') ??
                  'Follow us on Instagram',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              'assets/images/footer/whatsapp_icon.svg',
              () => _launchUrl('https://wa.me/+43123456789'),
              localizations?.translate('footer.whatsapp_label') ??
                  'Contact us via WhatsApp',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationColumn(
      BuildContext context, AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildFooterHeading(
          localizations?.translate('footer.navigation_title') ?? 'Navigation',
        ),
        const SizedBox(height: 24),
        _buildFooterLink(
          localizations?.translate('to_airport') ?? 'Taxi zum Flughafen',
          () => Navigator.pushNamed(context, '/to-airport'),
        ),
        _buildFooterLink(
          localizations?.translate('from_airport') ?? 'Taxi vom Flughafen',
          () => Navigator.pushNamed(context, '/from-airport'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.faq') ?? 'F.A.Q.',
          () => Navigator.pushNamed(context, '/faq'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.about_us') ?? 'Über uns',
          () => Navigator.pushNamed(context, '/about'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.terms') ?? 'AGB',
          () => Navigator.pushNamed(context, '/terms'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.privacy') ?? 'Datenschutz',
          () => Navigator.pushNamed(context, '/privacy'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.imprint') ?? 'Impressum',
          () => Navigator.pushNamed(context, '/imprint'),
        ),
      ],
    );
  }

  Widget _buildUsefulLinksColumn(
      BuildContext context, AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildFooterHeading(
          localizations?.translate('footer.useful_links_title') ??
              'Nützliche Links',
        ),
        const SizedBox(height: 24),
        _buildFooterLink(
          localizations?.translate('footer.vienna_airport') ?? 'Flughafen Wien',
          () => _launchUrl('https://www.viennaairport.com/'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.arrivals') ?? 'Aktuelle Ankünfte',
          () => _launchUrl(
              'https://www.viennaairport.com/passagiere/ankunft__abflug/ankuenfte'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.departures') ?? 'Aktuelle Abflüge',
          () => _launchUrl(
              'https://www.viennaairport.com/passagiere/ankunft__abflug/abfluege'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.airlines') ?? 'Fluglinien',
          () => _launchUrl(
              'https://www.viennaairport.com/passagiere/flughafen/fluglinien'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.airport_info') ??
              'Flughafen Information',
          () => _launchUrl(
              'https://www.viennaairport.com/passagiere/flughafen/airport-info'),
        ),
        _buildFooterLink(
          localizations?.translate('footer.airport_map') ?? 'Flughafen Karte',
          () => _launchUrl('https://maps.viennaairport.com/apps/index.html'),
        ),
      ],
    );
  }

  Widget _buildContactColumn(
      BuildContext context, AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildFooterHeading(
          localizations?.translate('footer.contact_title') ?? 'Kontakt',
        ),
        const SizedBox(height: 24),
        Text(
          localizations?.translate('footer.contact_intro') ??
              'Wenn Sie Fragen haben, können Sie uns telefonisch oder per E-Mail kontaktieren.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF666666),
            fontSize: 15,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _buildContactItem(
          'assets/images/footer/location_icon.svg',
          localizations?.translate('footer.company_full_address') ??
              'Musterstraße 123, 1010 Wien',
          null,
        ),
        _buildContactItem(
          'assets/images/footer/mobile_icon.svg',
          localizations?.translate('footer.phone') ?? '+43 123 456 789',
          () => _launchUrl('tel:+43123456789'),
        ),
        _buildContactItem(
          'assets/images/footer/icon_at_sign.svg',
          localizations?.translate('footer.email') ?? 'info@airportwinetaxi.at',
          () => _launchUrl('mailto:info@airportwinetaxi.at'),
        ),
        _buildContactItem(
          'assets/images/footer/globe_pointer_icon.svg',
          localizations?.translate('footer.website') ??
              'www.airportwinetaxi.at',
          () => _launchUrl('https://www.airportwinetaxi.at'),
        ),
      ],
    );
  }

  Widget _buildFooterHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles.heading3.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                const Color.fromARGB(0, 255, 255, 255)
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF666666),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(String iconPath, String text, VoidCallback? onTap) {
    Widget content = Column(
      children: [
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                const Color(0xFF666666).withOpacity(0.7),
                BlendMode.srcIn,
              ),
              placeholderBuilder: (context) => Icon(
                Icons.language,
                size: 16,
                color: const Color(0xFF666666).withOpacity(0.7),
              ),
            ),
          ),
        ),
        Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF666666),
            fontSize: 15,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: onTap != null ? InkWell(onTap: onTap, child: content) : content,
    );
  }

  Widget _buildSocialIcon(String iconPath, VoidCallback onTap, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                const Color(0xFF666666).withOpacity(0.7),
                BlendMode.srcIn,
              ),
              placeholderBuilder: (context) => Icon(
                _getIconForPath(iconPath),
                size: 20,
                color: const Color(0xFF666666).withOpacity(0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForPath(String iconPath) {
    if (iconPath.contains('facebook')) return Icons.facebook;
    if (iconPath.contains('instagram')) return Icons.camera_alt;
    if (iconPath.contains('whatsapp')) return Icons.chat;
    if (iconPath.contains('location')) return Icons.location_on;
    if (iconPath.contains('mobile')) return Icons.phone;
    if (iconPath.contains('at_sign')) return Icons.email;
    if (iconPath.contains('globe')) return Icons.language;
    return Icons.info;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
