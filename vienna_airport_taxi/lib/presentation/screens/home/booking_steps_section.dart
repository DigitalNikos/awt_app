// lib/presentation/screens/home/booking_steps_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/localization/app_localizations.dart';

class BookingStepsSection extends StatelessWidget {
  const BookingStepsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      // color: AppColors.backgroundLight,
      child: Column(
        children: [
          // Section Header
          _SectionHeader(
            title: t.translate('booking_section_title') ??
                'Wie buche ich eine Airport Taxi?',
            subtitle: t.translate('booking_section_subtitle') ??
                'Schnell, Einfach, Unkompliziert.',
          ),

          const SizedBox(height: 32),

          // Steps
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 750) {
                // Desktop layout - 3 columns
                return _DesktopStepsLayout();
              } else {
                // Mobile layout - single column
                return _MobileStepsLayout();
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
        Text(
          title,
          style: AppTextStyles.heading1.copyWith(
            fontSize: 28,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: 18,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DesktopStepsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1440),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _StepCard(stepNumber: 1)),
          const SizedBox(width: 32),
          Expanded(child: _StepCard(stepNumber: 2)),
          const SizedBox(width: 32),
          Expanded(child: _StepCard(stepNumber: 3)),
        ],
      ),
    );
  }
}

class _MobileStepsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepCard(stepNumber: 1),
        const SizedBox(height: 24),
        _StepCard(stepNumber: 2),
        const SizedBox(height: 24),
        _StepCard(stepNumber: 3),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;

  const _StepCard({required this.stepNumber});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    // Get step data based on number
    final stepData = _getStepData(stepNumber, t);

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Step Image
          Container(
            width: double.infinity,
            height: 180,
            margin: const EdgeInsets.only(bottom: 24),
            child: SvgPicture.asset(
              stepData['image']!,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  stepData['fallbackIcon'] as IconData,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          // Step Title
          Text(
            stepData['title']!,
            style: AppTextStyles.heading3.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF323232),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 18),

          // Step Description
          Text(
            stepData['description']!,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStepData(int stepNumber, AppLocalizations t) {
    switch (stepNumber) {
      case 1:
        return {
          'image': 'assets/images/booking_section/booking_step1.svg',
          'fallbackIcon': Icons.directions_car,
          'title': t.translate('step1_title') ?? 'Fahrtstrecke wählen',
          'description': t.translate('step1_description') ??
              'Wählen Sie Ihre gewünschte Fahrtrichtung - "Vom Flughafen" oder "Zum Flughafen" Wien-Schwechat. Unsere Festpreisgarantie sorgt für Transparenz ohne versteckte Kosten. Mit unserer modernen Fahrzeugflotte bieten wir höchsten Komfort und exklusiven Service.',
        };
      case 2:
        return {
          'image': 'assets/images/booking_section/booking_step2.svg',
          'fallbackIcon': Icons.description,
          'title': t.translate('step2_title') ?? 'Buchungsformular ausfüllen',
          'description': t.translate('step2_description') ??
              'Geben Sie alle wichtigen Details an: Datum, Uhrzeit, genaue Adresse, Anzahl der Personen und Gepäckstücke. Optional können Sie zusätzliche Services wie Kindersitze, Zwischenstopps oder Rückfahrten hinzufügen. Wählen Sie Ihre bevorzugte Zahlungsart (Bar oder Kartenzahlung) und hinterlassen Sie bei Bedarf spezielle Wünsche im Kommentarfeld.',
        };
      case 3:
        return {
          'image': 'assets/images/booking_section/booking_step3.svg',
          'fallbackIcon': Icons.person_pin_circle,
          'title': t.translate('step3_title') ?? 'Fahrer treffen',
          'description': t.translate('step3_description') ??
              'Ihr Fahrer wartet pünktlich am vereinbarten Zeitpunkt im Ankunftsbereich des Flughafens bei der "Information Service" oder er empfängt Sie zur vereinbarten Zeit an Ihrer angegebenen Adresse und bringt Sie stressfrei zum Terminal. Nach erfolgreicher Buchung erhalten Sie umgehend eine Bestätigungs-E-Mail mit allen Details zu Ihrer Fahrt.',
        };
      default:
        return {
          'image': '',
          'fallbackIcon': Icons.help,
          'title': 'Step',
          'description': 'Description',
        };
    }
  }
}
