import 'package:flutter/material.dart';

/// Modal for requesting participation (phone, terms) per SOW §8.
class ParticipationRequestModal extends StatefulWidget {
  final String productId;
  final String initialPhoneNumber;
  final void Function(String phoneNumber, bool termsAccepted) onSubmit;
  final VoidCallback onCancel;

  const ParticipationRequestModal({
    super.key,
    required this.productId,
    required this.initialPhoneNumber,
    required this.onSubmit,
    required this.onCancel,
  });

  static Future<void> show(
    BuildContext context, {
    required String productId,
    required String initialPhoneNumber,
    required void Function(String phoneNumber, bool termsAccepted) onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ParticipationRequestModal(
        productId: productId,
        initialPhoneNumber: initialPhoneNumber,
        onSubmit: onSubmit,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  State<ParticipationRequestModal> createState() =>
      _ParticipationRequestModalState();
}

class _ParticipationRequestModalState extends State<ParticipationRequestModal> {
  late TextEditingController _phoneController;
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhoneNumber);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Request participation',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D2D2D),
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Confirm your phone number and accept the terms to participate.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B6B6B),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(),
                hintText: '+1 234 567 8900',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                ),
                const Expanded(
                  child: Text(
                    'I accept the Privacy Policy and Terms of Service',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _termsAccepted
                        ? () {
                            widget.onSubmit(
                              _phoneController.text.trim(),
                              _termsAccepted,
                            );
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
