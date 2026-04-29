import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';
import 'database_helper.dart';

const _noteColors = [
  Color(0xFFF5F5F5),
  Color(0xFFFFF3E0),
  Color(0xFFE8F5E9),
  Color(0xFFE3F2FD),
  Color(0xFFFCE4EC),
  Color(0xFFF3E5F5),
];

class NoteEditor extends StatefulWidget {
  final Note? note;
  const NoteEditor({super.key, this.note});
  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  late int _colorIndex;
  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.note?.content ?? '');
    _colorIndex = widget.note?.colorIndex ?? 0;
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Title is required', style: GoogleFonts.plusJakartaSans()),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }

    final note = Note(
      id: widget.note?.id,
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      colorIndex: _colorIndex,
      updatedAt: DateTime.now().toIso8601String(),
    );

    if (_isEditing) {
      await DatabaseHelper.instance.update(note);
    } else {
      await DatabaseHelper.instance.create(note);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _noteColors[_colorIndex % _noteColors.length],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text(_isEditing ? 'Edit Note' : 'New Note', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: const Icon(Icons.check_rounded), onPressed: _save),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemCount: _noteColors.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => setState(() => _colorIndex = i),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _noteColors[i],
                      shape: BoxShape.circle,
                      border: Border.all(color: _colorIndex == i ? AppColors.accent : Colors.transparent, width: 2.5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleCtrl,
              style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700),
              decoration: InputDecoration(hintText: 'Title', border: InputBorder.none, hintStyle: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.onSurfaceDim.withOpacity(0.3))),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentCtrl,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: GoogleFonts.plusJakartaSans(fontSize: 15, height: 1.6),
                decoration: InputDecoration(hintText: 'Start writing...', border: InputBorder.none, hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.onSurfaceDim.withOpacity(0.3))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
