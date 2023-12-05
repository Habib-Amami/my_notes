import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_notes/constants/images.dart';
import 'package:my_notes/services/database.dart';

class NoteUpdateForm extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final String id;
  NoteUpdateForm({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        updateNoteImage,
                        height: 150,
                      ),
                    ),
                  ),
                  //note title field-----------------------------
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: 12,
                        ),
                        hintText: "Update your Note title here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a note title';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //note content----------------------------------
                  SizedBox(
                    // height: 60,
                    width: double.infinity,
                    child: TextFormField(
                      controller: _contentController,
                      scrollPhysics: const AlwaysScrollableScrollPhysics(),
                      maxLines: 6,
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: 12,
                        ),
                        hintText: "Update your Note content here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a note content';
                        }
                        return null; // Password is valid
                      },
                      onFieldSubmitted: (_) {
                        _formkey.currentState!.save();
                        _formkey.currentState!.validate();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FilledButton(
                    onPressed: () async {
                      await DataBase()
                          .updateNote(id, _titleController.text,
                              _contentController.text)
                          .then((_) => Navigator.of(context).pop());
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.update,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Update Note',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
