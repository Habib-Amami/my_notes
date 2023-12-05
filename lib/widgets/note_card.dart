import 'package:flutter/material.dart';
import 'package:my_notes/constants/text_style.dart';
import 'package:my_notes/widgets/note_update_form.dart';
import 'package:my_notes/widgets/note_delet_alert.dart';

class Notecard extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;

  const Notecard({
    super.key,
    required this.title,
    required this.content,
    required this.updatedAt,
    required this.id,
  });
  Widget buildUpdateForm(BuildContext ctx) {
    return NoteUpdateForm(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.trim(),
              overflow: TextOverflow.ellipsis,
              style: noteTitleStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              content.trim(),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: noteContentStyle,
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: buildUpdateForm,
                      isScrollControlled: true,
                      isDismissible: true,
                      useSafeArea: true,
                    );
                  },
                  icon: const Icon(
                    Icons.edit_document,
                    color: Colors.white70,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) => DeletAlert(id: id),
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.pink[100],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
