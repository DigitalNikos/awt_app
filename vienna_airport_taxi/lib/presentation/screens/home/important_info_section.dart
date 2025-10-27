// lib/presentation/screens/home/important_info_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';

class ImportantInfoSection extends StatelessWidget {
  const ImportantInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      color: Colors.transparent, // No background color
      child: Column(
        children: [
          // Section Header
          _SectionHeader(
            title: t.translate('important_info_title') ?? 'Wichtige Info!',
            subtitle: t.translate('important_info_subtitle') ??
                'Treffpunkt am Flughafen Wien',
          ),

          const SizedBox(height: 32),

          // Content
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 1025) {
                // Desktop layout - side by side
                return _DesktopInfoLayout();
              } else {
                // Mobile layout - stacked
                return _MobileInfoLayout();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF222222), Color(0xFF444444)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            title,
            style: AppTextStyles.heading1.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: Colors.white, // This will be masked by the gradient
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
            subtitle,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _DesktopInfoLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1440),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column - Info cards
          Expanded(
            flex: 3,
            child: _InfoCardsColumn(),
          ),
          const SizedBox(width: 32),
          // Right column - Airport map
          Expanded(
            flex: 2,
            child: _AirportMapCard(),
          ),
        ],
      ),
    );
  }
}

class _MobileInfoLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoCardsColumn(),
        const SizedBox(height: 24),
        _AirportMapCard(),
      ],
    );
  }
}

class _InfoCardsColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _InfoCard(cardNumber: 1),
        SizedBox(height: 20),
        _InfoCard(cardNumber: 2),
        SizedBox(height: 20),
        _InfoCard(cardNumber: 3),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final int cardNumber;

  const _InfoCard({required this.cardNumber});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cardData = _getCardData(cardNumber, t);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 720),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 16),
                child: SvgPicture.asset(
                  cardData['icon']!,
                  width: 40,
                  height: 40,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                  placeholderBuilder: (context) => Icon(
                    cardData['fallbackIcon'] as IconData,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),

              // Title
              Expanded(
                child: Text(
                  cardData['title']!,
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF323232),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Content
          ...cardData['content'] as List<Widget>,
        ],
      ),
    );
  }

  Map<String, dynamic> _getCardData(int cardNumber, AppLocalizations t) {
    switch (cardNumber) {
      case 1:
        return {
          'icon': 'assets/images/important_section/clock-solid.svg',
          'fallbackIcon': Icons.access_time,
          'title': t.translate('reservation_deadlines_title') ??
              'Reservierungsfristen',
          'content': [
            _buildStrongText(t.translate('reservation_same_day') ??
                'Fahrten, die bis 22:00 Uhr am selben Tag stattfinden sollen, bitte mindestens 3 Stunden vorher reservieren.'),
            const SizedBox(height: 12),
            _buildStrongText(t.translate('reservation_night') ??
                'Fahrten, die zwischen 22:00 und 06:00 Uhr stattfinden sollen, bitte mindestens 8 Stunden vorher reservieren.'),
          ],
        };
      case 2:
        return {
          'icon': 'assets/images/important_section/plane-arrival-solid.svg',
          'fallbackIcon': Icons.flight_land,
          'title':
              t.translate('airport_arrival_title') ?? 'Ankunft am Flughafen',
          'content': [
            _buildStrongText(t.translate('turn_on_phone') ??
                'Bitte nach der Landung Handy einschalten.'),
            const SizedBox(height: 12),
            _buildStrongText(t.translate('driver_contact') ??
                'Bei Ihrer Ankunft am Flughafen Wien Schwechat wird Ihr Fahrer Sie telefonisch kontaktieren. Wenn ein Namensschild bestellt wurde, wartet Ihr Fahrer damit auf Sie.'),
          ],
        };
      case 3:
        return {
          'icon': 'assets/images/important_section/circle-info-solid.svg',
          'fallbackIcon': Icons.info,
          'title':
              t.translate('additional_info_title') ?? 'Weitere Informationen',
          'content': [
            _buildStrongText(t.translate('round_trip_info') ??
                'Für "Hin & Retour" - Buchungen gelten unsere speziellen Paketpreise, die Ihnen einen vergünstigten Tarif für die Hin - und Rückreise bieten.'),
            const SizedBox(height: 12),
            _buildStrongText(t.translate('contact_help') ??
                'Falls Sie Schwierigkeiten mit dem Formular haben, können Sie uns jederzeit über E-Mail, Telefon oder WhatsApp kontaktieren. Wir helfen Ihnen gerne weiter!'),
          ],
        };
      default:
        return {
          'icon': '',
          'fallbackIcon': Icons.help,
          'title': 'Info',
          'content': [const SizedBox.shrink()],
        };
    }
  }

  Widget _buildStrongText(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        fontSize: 16,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
    );
  }
}

class _AirportMapCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 720),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          Text(
            t.translate('map_title') ?? 'Wo Sie Ihren Fahrer finden:',
            style: AppTextStyles.heading3.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF323232),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Airport Map - Clickable to zoom
          GestureDetector(
            onTap: () {
              _showZoomableMap(context);
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/important_section/airport_plan.png',
                      width: double.infinity,
                      height: 280,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 60,
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              t.translate('map_title'),
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Zoom indicator overlay
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.zoom_in,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Click to zoom',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Caption
          Text(
            t.translate('map_caption') ??
                'Unser Fahrer wartet am Informationsschalter im Ankunftsbereich',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showZoomableMap(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Zoomable map
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.asset(
                  'assets/images/important_section/airport_plan.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
