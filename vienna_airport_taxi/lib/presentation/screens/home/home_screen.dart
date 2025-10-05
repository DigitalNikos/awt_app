// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hero_section.dart';
import 'booking_steps_section.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/widgets/bottom_navbar.dart';
import 'package:vienna_airport_taxi/core/localization/language_provider.dart';
import 'package:vienna_airport_taxi/presentation/widgets/floating_action_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButtons = false;

  // Approximate height where hero section ends (adjust based on your hero section height)
  static const double _heroSectionHeight = 400.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool shouldShowButtons =
        _scrollController.offset > _heroSectionHeight;
    if (shouldShowButtons != _showFloatingButtons) {
      setState(() {
        _showFloatingButtons = shouldShowButtons;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const SizedBox.shrink(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Yellow circle background element (positioned relative to hero section)
          Positioned(
            top: -125,
            left: -95,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 50,
                ),
              ),
            ),
          ),

          // Main content - scrollable with proper layout
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Hero Section (this will be positioned behind the yellow circle)
                  const HeroSection(),

                  // Booking Steps Section
                  const BookingStepsSection(),

                  // Important Info Section (inline for now)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 48, horizontal: 16),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        // Section Header
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF222222), Color(0xFF444444)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Text(
                            'Wichtige Info!',
                            style: AppTextStyles.heading1.copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: Colors
                                  .white, // This will be masked by the gradient
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Text(
                            'Treffpunkt am Flughafen Wien',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Info Cards
                        _buildInfoCard(
                          icon: Icons.access_time,
                          title: 'Reservierungsfristen',
                          content: [
                            'Fahrten, die bis 22:00 Uhr am selben Tag stattfinden sollen, bitte mindestens 3 Stunden vorher reservieren.',
                            '',
                            'Fahrten, die zwischen 22:00 und 06:00 Uhr stattfinden sollen, bitte mindestens 8 Stunden vorher reservieren.',
                          ],
                        ),

                        const SizedBox(height: 20),

                        _buildInfoCard(
                          icon: Icons.flight_land,
                          title: 'Ankunft am Flughafen',
                          content: [
                            'Bitte nach der Landung Handy einschalten.',
                            '',
                            'Bei Ihrer Ankunft am Flughafen Wien Schwechat wird Ihr Fahrer Sie telefonisch kontaktieren. Wenn ein Namensschild bestellt wurde, wartet Ihr Fahrer damit auf Sie.',
                          ],
                        ),

                        const SizedBox(height: 20),

                        _buildInfoCard(
                          icon: Icons.info,
                          title: 'Weitere Informationen',
                          content: [
                            'Für "Hin & Retour" - Buchungen gelten unsere speziellen Paketpreise, die Ihnen einen vergünstigten Tarif für die Hin - und Rückreise bieten.',
                            '',
                            'Falls Sie Schwierigkeiten mit dem Formular haben, können Sie uns jederzeit über E-Mail, Telefon oder WhatsApp kontaktieren. Wir helfen Ihnen gerne weiter!',
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Airport Map Card
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 720),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Wo Sie Ihren Fahrer finden:',
                                style: AppTextStyles.heading3.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF323232),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.border.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.map,
                                      size: 60,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Airport Map',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
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
                        ),
                      ],
                    ),
                  ),

                  // Add bottom padding to account for floating navbar
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Floating Action Buttons
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButtons(
              isVisible: _showFloatingButtons,
            ),
          ),

          // Floating bottom navbar positioned at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              languageProvider: languageProvider,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<String> content,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 720),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 16),
                child: Icon(
                  icon,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: Text(
                  title,
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
          ...content.map((text) {
            if (text.isEmpty) {
              return const SizedBox(height: 12);
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
