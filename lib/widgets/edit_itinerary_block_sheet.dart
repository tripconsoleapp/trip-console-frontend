import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/itinerary_block.dart';
import '../providers/new_trip_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import 'counter_field.dart';

/// Bottom sheet for adding or editing one block on an itinerary day —
/// block type, name, location, timing, per-head cost, and notes.
class EditItineraryBlockSheet extends StatefulWidget {
  const EditItineraryBlockSheet({super.key, required this.day, this.blockIndex, this.existing});

  final int day;
  final int? blockIndex;
  final ItineraryBlock? existing;

  static Future<void> show(BuildContext context, {required int day, int? blockIndex, ItineraryBlock? existing}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditItineraryBlockSheet(day: day, blockIndex: blockIndex, existing: existing),
    );
  }

  @override
  State<EditItineraryBlockSheet> createState() => _EditItineraryBlockSheetState();
}

class _EditItineraryBlockSheetState extends State<EditItineraryBlockSheet> {
  late BlockType _type = widget.existing?.type ?? BlockType.activity;
  late final _nameController = TextEditingController(text: widget.existing?.title ?? '');
  late final _locationController = TextEditingController(text: widget.existing?.subtitle ?? '');
  late final _timeController = TextEditingController(text: widget.existing?.time ?? '09:00 AM');
  late int _durationHours = 1;
  late final _costController = TextEditingController(text: widget.existing?.cost?.toString() ?? '');
  bool _staffFree = true;
  late final _notesController = TextEditingController();

  bool get _isEditing => widget.existing != null;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    final draft = context.read<NewTripProvider>();
    final block = ItineraryBlock(
      type: _type,
      time: _timeController.text.trim().isEmpty ? '09:00 AM' : _timeController.text.trim(),
      title: _nameController.text.trim().isEmpty ? _type.label : _nameController.text.trim(),
      subtitle: _locationController.text.trim(),
      cost: int.tryParse(_costController.text.trim()),
    );
    if (widget.blockIndex != null) {
      draft.updateBlock(widget.day, widget.blockIndex!, block);
    } else {
      draft.addBlock(widget.day, block);
    }
    Navigator.of(context).pop();
  }

  void _delete() {
    context.read<NewTripProvider>().removeBlock(widget.day, widget.blockIndex!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_isEditing ? EditBlockStrings.title : EditBlockStrings.addTitle, style: AppTextStyles.h3(color: AppColors.textDark)),
                  if (_isEditing)
                    TextButton(
                      onPressed: _delete,
                      child: Text(EditBlockStrings.deleteBlock, style: AppTextStyles.bodySm(color: AppColors.error)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(EditBlockStrings.blockType, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final type in BlockType.values) ...[
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _type = type),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _type == type ? AppColors.accentOrange.withValues(alpha: 0.1) : const Color(0xFFF5F3F3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _type == type ? AppColors.accentOrange : Colors.transparent),
                          ),
                          child: Column(
                            children: [
                              Icon(type.icon, size: 18, color: _type == type ? AppColors.accentOrange : AppColors.textGrey),
                              const SizedBox(height: 4),
                              Text(type.label, style: AppTextStyles.bodySm(color: _type == type ? AppColors.accentOrange : AppColors.textGrey).copyWith(fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (type != BlockType.values.last) const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Text(EditBlockStrings.activityName, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              _field(_nameController),
              const SizedBox(height: 16),
              Text(EditBlockStrings.location, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              _field(_locationController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(EditBlockStrings.startTime, style: AppTextStyles.labelCaps()),
                        const SizedBox(height: 8),
                        _field(_timeController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(EditBlockStrings.duration, style: AppTextStyles.labelCaps()),
                        const SizedBox(height: 8),
                        CounterField(
                          label: '$_durationHours hr${_durationHours == 1 ? '' : 's'}',
                          sublabel: '',
                          value: _durationHours,
                          minValue: 1,
                          onChanged: (v) => setState(() => _durationHours = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(EditBlockStrings.costPerStudent, style: AppTextStyles.labelCaps()),
                        const SizedBox(height: 8),
                        _field(_costController, keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(EditBlockStrings.staffFree, style: AppTextStyles.bodySm()),
                      Switch(value: _staffFree, activeThumbColor: AppColors.primaryGreen, onChanged: (v) => setState(() => _staffFree = v)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(EditBlockStrings.organizerNotes, style: AppTextStyles.labelCaps()),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 2,
                style: AppTextStyles.bodySm(color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: EditBlockStrings.organizerNotesHint,
                  hintStyle: AppTextStyles.bodySm(),
                  filled: true,
                  fillColor: const Color(0xFFF5F3F3),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(EditBlockStrings.saveBlock, style: AppTextStyles.button()),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(EditBlockStrings.cancel, style: AppTextStyles.bodySm(color: AppColors.textGrey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyLg(color: AppColors.textDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F3F3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
