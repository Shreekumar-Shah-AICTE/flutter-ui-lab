import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';
import 'database_helper.dart';
import 'note_editor.dart';

const _noteColors = [
  Color(0xFFF5F5F5),
  Color(0xFFFFF3E0),
  Color(0xFFE8F5E9),
  Color(0xFFE3F2FD),
  Color(0xFFFCE4EC),
  Color(0xFFF3E5F5),
];

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _loading = true);
    final notes = await DatabaseHelper.instance.readAll();
    setState(() { _notes = notes; _loading = false; });
  }

  Future<void> _searchNotes(String query) async {
    if (query.isEmpty) { _loadNotes(); return; }
    final notes = await DatabaseHelper.instance.search(query);
    setState(() => _notes = notes);
  }

  Future<void> _deleteNote(Note note) async {
    HapticFeedback.heavyImpact();
    await DatabaseHelper.instance.delete(note.id!);
    _loadNotes();
  }

  void _openEditor([Note? note]) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditor(note: note)));
    if (result == true) _loadNotes();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _searching
                        ? TextField(
                            controller: _searchCtrl,
                            autofocus: true,
                            onChanged: _searchNotes,
                            style: GoogleFonts.plusJakartaSans(fontSize: 15),
                            decoration: InputDecoration(hintText: 'Search notes...', border: InputBorder.none, isDense: true),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ARCHIVE', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.onSurfaceDim, letterSpacing: 6)),
                              const SizedBox(height: 4),
                              Text('Notes', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                            ],
                          ),
                  ),
                  IconButton(
                    icon: Icon(_searching ? Icons.close_rounded : Icons.search_rounded),
                    onPressed: () {
                      setState(() { _searching = !_searching; _searchCtrl.clear(); });
                      if (!_searching) _loadNotes();
                    },
                  ),
                ],
              ),
              if (!_searching) ...[const SizedBox(height: 4), Text('${_notes.length} notes', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.onSurfaceDim))],
              const SizedBox(height: 20),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _notes.isEmpty
                        ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.note_add_rounded, size: 64, color: AppColors.onSurfaceDim.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            Text('No notes yet.', style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppColors.onSurfaceDim)),
                            Text('Tap + to create one.', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.onSurfaceDim.withOpacity(0.5))),
                          ]))
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
                            itemCount: _notes.length,
                            itemBuilder: (_, i) => _buildNoteCard(_notes[i], i),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note, int index) {
    final color = _noteColors[note.colorIndex % _noteColors.length];
    return GestureDetector(
      onTap: () => _openEditor(note),
      onLongPress: () => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Delete note?', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
          content: Text('"${note.title}" will be permanently deleted.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(onPressed: () { Navigator.pop(ctx); _deleteNote(note); }, child: Text('Delete', style: TextStyle(color: AppColors.error))),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            const SizedBox(height: 8),
            Expanded(child: Text(note.content, maxLines: 5, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.onSurfaceDim, height: 1.4))),
            const Spacer(),
            Text(_formatDate(note.updatedAt), style: GoogleFonts.jetBrainsMono(fontSize: 10, color: AppColors.onSurfaceDim.withOpacity(0.5))),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 50)).scale(begin: const Offset(0.95, 0.95));
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return '';
    }
  }
}
