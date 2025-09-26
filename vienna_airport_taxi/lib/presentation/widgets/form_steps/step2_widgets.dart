import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/option_card.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/option_panel.dart';
import 'package:vienna_airport_taxi/presentation/widgets/form_steps/step1_widgets.dart';
import 'package:vienna_airport_taxi/data/models/booking_form_data.dart';
import 'package:vienna_airport_taxi/presentation/widgets/custom_time_picker.dart';

class StopoverWidget extends StatefulWidget {
  final bool isViennaSelected;
  final List<StopoverLocation> currentStopovers;
  final Function(String postalCode, String address) onAddStopover;
  final Function(int index) onRemoveStopover;
  final String? stopoverError;
  final Function(bool isOpen)? onPanelStateChanged;
  final Function(bool hasUnaddedData)? onValidatePanelData;
  final Function(String? postalCode, String address)? onValidateFields;
  final String? addressError;
  final String? postalCodeError;

  const StopoverWidget({
    Key? key,
    required this.isViennaSelected,
    required this.currentStopovers,
    required this.onAddStopover,
    required this.onRemoveStopover,
    this.stopoverError,
    this.onPanelStateChanged,
    this.onValidatePanelData,
    this.onValidateFields,
    this.addressError,
    this.postalCodeError,
  }) : super(key: key);

  @override
  State<StopoverWidget> createState() => _StopoverWidgetState();
}

class _StopoverWidgetState extends State<StopoverWidget> {
  bool _isInputPanelVisible = false;
  String? _selectedPostalCode;
  String _address = '';
  final TextEditingController _addressController = TextEditingController();

  // Method to check if panel is open with data but not added
  bool get hasUnaddedStopoverData =>
      _isInputPanelVisible &&
      ((_selectedPostalCode != null && _selectedPostalCode!.isNotEmpty) ||
          _address.isNotEmpty);

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _addStopover() {
    if (_selectedPostalCode != null && _address.isNotEmpty) {
      widget.onAddStopover(_selectedPostalCode!, _address);
      setState(() {
        _selectedPostalCode = null;
        _address = '';
        _addressController.clear();
        _isInputPanelVisible = false; // Hide input panel after adding
      });
      widget.onPanelStateChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isViennaSelected) return const SizedBox.shrink();

    final maxStopovers = 3;
    final currentCount = widget.currentStopovers.length;
    final canAddMore = currentCount < maxStopovers;
    final hasInitialCard = currentCount == 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Show initial card only when no stopovers exist and input panel is not visible
          if (hasInitialCard && !_isInputPanelVisible)
            OptionCard(
              svgIcon: 'assets/icons/panels/add_location.svg',
              title: 'Zwischenstopp',
              description: 'Fügen Sie einen Zwischenstopp zu Ihrer Fahrt hinzu',
              isExpanded: false,
              onTap: () {
                setState(() {
                  _isInputPanelVisible = true;
                });
                widget.onPanelStateChanged?.call(true);
              },
            ),

          // Stopover list container
          if (currentCount > 0 || _isInputPanelVisible)
            OptionPanel(
              title: 'Zwischenstopp',
              isVisible: true,
              isError: widget.stopoverError != null,
              helperText: widget.stopoverError != null
                  ? widget.stopoverError!
                  : 'Sie können noch ${maxStopovers - currentCount} ${currentCount == maxStopovers - 1 ? 'Zwischenstopp' : 'Zwischenstopps'} hinzufügen.',
              onClose: () {
                setState(() {
                  _isInputPanelVisible = false;
                  _selectedPostalCode = null;
                  _address = '';
                  _addressController.clear();
                });
                widget.onPanelStateChanged?.call(false);
              },
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stopover list
                  if (currentCount > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: widget.currentStopovers.map((stopover) {
                          final index =
                              widget.currentStopovers.indexOf(stopover);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                left: BorderSide(
                                  color: AppColors.primary,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${stopover.address} - ${stopover.postalCode}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    widget.onRemoveStopover(index);
                                    // If input panel is visible and no more stopovers, hide it
                                    if (_isInputPanelVisible &&
                                        currentCount == 1) {
                                      setState(() {
                                        _isInputPanelVisible = false;
                                      });
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // Input section (visible when needed)
                  if (_isInputPanelVisible && canAddMore) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Neuer Zwischenstopp',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _isInputPanelVisible = false;
                                    _selectedPostalCode = null;
                                    _address = '';
                                    _addressController.clear();
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Divider
                          Container(
                            height: 1,
                            color: AppColors.border,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                          ),

                          // Input fields
                          InputFieldWithIcon(
                            icon: Icons.location_on,
                            hintText: 'Stopover Adresse',
                            value: _address,
                            errorText: widget.addressError,
                            onChanged: (value) {
                              setState(() {
                                _address = value;
                              });
                              // Validate individual fields and panel data
                              widget.onValidateFields
                                  ?.call(_selectedPostalCode, value);
                              widget.onValidatePanelData
                                  ?.call(hasUnaddedStopoverData);
                            },
                          ),

                          const SizedBox(height: 12),

                          DropdownFieldWithIcon(
                            icon: Icons.markunread_mailbox,
                            hintText: 'PLZ',
                            value: _selectedPostalCode,
                            errorText: widget.postalCodeError,
                            items: const [
                              '1010',
                              '1020',
                              '1030',
                              '1040',
                              '1050',
                              '1060',
                              '1070',
                              '1080',
                              '1090',
                              '1100',
                              '1110',
                              '1120',
                              '1130',
                              '1140',
                              '1150',
                              '1160',
                              '1170',
                              '1180',
                              '1190',
                              '1200',
                              '1210',
                              '1220',
                              '1230',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedPostalCode = value;
                              });
                              // Validate individual fields and panel data
                              widget.onValidateFields?.call(value, _address);
                              widget.onValidatePanelData
                                  ?.call(hasUnaddedStopoverData);
                            },
                          ),

                          const SizedBox(height: 16),

                          // Add button
                          ElevatedButton(
                            onPressed: _addStopover,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_location, size: 16),
                                const SizedBox(width: 8),
                                const Text('Zwischenstopp hinzufügen'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (!_isInputPanelVisible &&
                      currentCount > 0 &&
                      canAddMore) ...[
                    // "Add another stopover" button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isInputPanelVisible = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(
                          color: AppColors.primary,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_location,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Weiteren Zwischenstopp hinzufügen',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ReturnTripWidget extends StatefulWidget {
  final bool isReturnTripActive;
  final DateTime? returnDate;
  final String? returnTime;
  final String? flightFrom;
  final String? flightNumber;
  final Function(bool) onReturnTripChanged;
  final Function(DateTime?) onReturnDateChanged;
  final Function(String?) onReturnTimeChanged;
  final Function(String?) onFlightFromChanged;
  final Function(String?) onFlightNumberChanged;
  // Error message parameters
  final String? returnDateError;
  final String? returnTimeError;
  final String? flightFromError;
  final String? flightNumberError;
  final String? returnDateTimeError;

  const ReturnTripWidget({
    Key? key,
    required this.isReturnTripActive,
    required this.returnDate,
    required this.returnTime,
    required this.flightFrom,
    required this.flightNumber,
    required this.onReturnTripChanged,
    required this.onReturnDateChanged,
    required this.onReturnTimeChanged,
    required this.onFlightFromChanged,
    required this.onFlightNumberChanged,
    this.returnDateError,
    this.returnTimeError,
    this.flightFromError,
    this.flightNumberError,
    this.returnDateTimeError,
  }) : super(key: key);

  @override
  State<ReturnTripWidget> createState() => _ReturnTripWidgetState();
}

class _ReturnTripWidgetState extends State<ReturnTripWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Only show the option card when return trip is NOT active
          if (!widget.isReturnTripActive)
            OptionCard(
              svgIcon: 'assets/icons/panels/compare_arrows.svg',
              title: 'Rückfahrt',
              description: 'Planen Sie Ihre Rückfahrt vom Flughafen',
              isExpanded: widget.isReturnTripActive,
              onTap: () {
                widget.onReturnTripChanged(!widget.isReturnTripActive);
              },
            ),

          // Option panel
          OptionPanel(
            title: 'Rückfahrt',
            isVisible: widget.isReturnTripActive,
            helperText: 'Wir holen Sie pünktlich zu Ihrem Flug ab.',
            onClose: () {
              widget.onReturnTripChanged(false);
            },
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date and time section
                Text(
                  'Wann möchten Sie zurückfahren?',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: InputFieldWithIcon(
                        icon: Icons.calendar_month,
                        hintText: 'Datum',
                        value: widget.returnDate != null
                            ? '${widget.returnDate!.day.toString().padLeft(2, '0')}.${widget.returnDate!.month.toString().padLeft(2, '0')}.${widget.returnDate!.year}'
                            : null,
                        errorText: widget.returnDateError,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: widget.returnDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                            locale: const Locale('de'),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.black,
                                    surface: Colors.white,
                                    onSurface: Colors
                                        .grey, // Grey border for current date
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            widget.onReturnDateChanged(picked);
                          }
                        },
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InputFieldWithIcon(
                        icon: Icons.access_time,
                        hintText: 'Uhrzeit',
                        value: widget.returnTime,
                        errorText: widget.returnTimeError,
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: CustomTimePicker(
                                  initialTime: widget.returnTime,
                                  onConfirm: (timeString) {
                                    widget.onReturnTimeChanged(timeString);
                                  },
                                ),
                              );
                            },
                          );
                        },
                        readOnly: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Flight information section
                Text(
                  'Fluginformationen',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: InputFieldWithIcon(
                        icon: Icons.flight_land,
                        hintText: 'Abflugort',
                        value: widget.flightFrom,
                        onChanged: widget.onFlightFromChanged,
                        errorText: widget.flightFromError,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InputFieldWithIcon(
                        icon: Icons.flight,
                        hintText: 'Flugnummer',
                        value: widget.flightNumber,
                        onChanged: widget.onFlightNumberChanged,
                        errorText: widget.flightNumberError,
                      ),
                    ),
                  ],
                ),

                // Display combined date/time validation error
                if (widget.returnDateTimeError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      widget.returnDateTimeError!,
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChildSeatWidget extends StatelessWidget {
  final String selectedChildSeat;
  final Function(String) onChildSeatChanged;

  const ChildSeatWidget({
    Key? key,
    required this.selectedChildSeat,
    required this.onChildSeatChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childSeatOptions = {
      'None': 'Ohne',
      'booster_seat': 'Kindersitzerhöhung',
      'child_seat': 'Kindersitz',
      'baby_carrier': 'Babyschale',
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // OptionCard that displays the current selection
            OptionCard(
              svgIcon: 'assets/icons/panels/child_care.svg',
              title: 'Kindersitz',
              description: 'Wählen Sie die passende Option für Ihr Kind',
              // Removed custom indicator - will use default + icon like other panels
              selectedValue: selectedChildSeat != 'None'
                  ? childSeatOptions[selectedChildSeat]
                  : null,
            ),

            // Invisible overlay to capture taps
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Show custom dropdown
                    _showChildSeatOptions(context, selectedChildSeat,
                        childSeatOptions, onChildSeatChanged);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChildSeatOptions(
    BuildContext context,
    String currentSelection,
    Map<String, String> options,
    Function(String) onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kindersitz auswählen',
                    style: AppTextStyles.heading3,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Options
              ...options.entries.map((entry) {
                final isSelected = entry.key == currentSelection;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        entry.value,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : null,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check,
                              color: AppColors.primary, size: 20)
                          : null,
                      onTap: () {
                        onChanged(entry.key);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class NameSignWidget extends StatelessWidget {
  final bool isReturnTripActive;
  final bool nameplateService;
  final Function(bool) onNameplateServiceChanged;

  const NameSignWidget({
    Key? key,
    required this.isReturnTripActive,
    required this.nameplateService,
    required this.onNameplateServiceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isReturnTripActive) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // Fixed margin
      child: OptionCard(
        svgIcon: 'assets/icons/panels/badge.svg',
        title: 'Namenschild',
        description: 'Wir begrüßen Sie in der Ankunftshalle mit Namensschild',
        indicator: Container(
          width: 24,
          height: 24,
          child: Checkbox(
            value: nameplateService,
            onChanged: (value) {
              if (value != null) {
                onNameplateServiceChanged(value);
              }
            },
            activeColor: AppColors.success,
          ),
        ),
        onTap: () {
          onNameplateServiceChanged(!nameplateService);
        },
      ),
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  final String paymentMethod;
  final Function(String) onPaymentMethodChanged;

  const PaymentMethodWidget({
    Key? key,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: OptionCard(
        svgIcon: paymentMethod == 'cash'
            ? 'assets/icons/panels/attach_money.svg'
            : 'assets/icons/panels/credit_card.svg',
        title: 'Zahlungsart',
        description: 'Zahlungsart auswählen',
        indicator: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            paymentMethod == 'cash' ? 'Bar' : 'Karte',
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
              fontSize: 14, // Ensure proper font size
            ),
          ),
        ),
        onTap: () {
          final newMethod = paymentMethod == 'cash' ? 'card' : 'cash';
          onPaymentMethodChanged(newMethod);
        },
      ),
    );
  }
}

class CommentWidget extends StatefulWidget {
  final String? comment;
  final Function(String?) onCommentChanged;

  const CommentWidget({
    Key? key,
    required this.comment,
    required this.onCommentChanged,
  }) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isExpanded = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.comment ?? '';
    _isExpanded = widget.comment != null && widget.comment!.isNotEmpty;
  }

  @override
  void didUpdateWidget(CommentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.comment != oldWidget.comment) {
      _commentController.text = widget.comment ?? '';
      _isExpanded = widget.comment != null && widget.comment!.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        // Add this to prevent overflow visual indicator
        borderRadius: BorderRadius.circular(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded ? 220 : 88,
              curve: Curves.easeInOut, // Smooth animation curve
              child: GestureDetector(
                onTap: () {
                  if (!_isExpanded) {
                    setState(() {
                      _isExpanded = true;
                    });
                  }
                },
                child: _isExpanded
                    ? _buildExpandedState()
                    : _buildCollapsedState(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCollapsedState() {
    return OptionCard(
      svgIcon: 'assets/icons/panels/note_add.svg',
      title: 'Anmerkungen',
      description: 'Fügen Sie hier zusätzliche Informationen hinzu',
    );
  }

  Widget _buildExpandedState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with icon and close button
          Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.note_add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Anmerkungen',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Close button
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  color: AppColors.textSecondary,
                  onPressed: () {
                    setState(() {
                      _isExpanded = false;
                      _commentController.clear();
                      widget.onCommentChanged(null);
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              ],
            ),
          ),

          // Textarea
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _commentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Fügen Sie hier zusätzliche Informationen hinzu...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (value) {
                  widget.onCommentChanged(value.isEmpty ? null : value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192,
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0.0, 1.0],
          colors: [AppColors.primary, const Color.fromARGB(0, 255, 255, 255)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
