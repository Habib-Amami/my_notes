import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_notes/constants/images.dart';
import 'package:my_notes/services/database.dart';
import 'package:my_notes/widgets/note_card.dart';

class Home extends StatefulWidget {
  static String routeName = "my_notes/screens/home_screen.dart";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: StreamBuilder(
          stream: DataBase().getUserNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 4 / 5,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Notecard(
                    title: snapshot.data![index].title,
                    content: snapshot.data![index].content,
                    updatedAt: snapshot.data![index].updatedAt,
                    id: snapshot.data![index].id,
                  );
                },
                padding: const EdgeInsets.all(8.0),
              );
            }
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  noNote,
                  height: 200,
                ),
                const Text(
                  "Add Notes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ));
          },
        ),
      ),
      floatingActionButton: FloatingActionBubble(
        // Menu items
        items: <Bubble>[
          //Floating action menu item
          Bubble(
            title: "New Note",
            iconColor: Colors.white,
            bubbleColor: Theme.of(context).primaryColor,
            icon: Icons.note_add,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
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
                                      addNoteImage,
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
                                      hintText: "Enter your Note title",
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
                                    scrollPhysics:
                                        const AlwaysScrollableScrollPhysics(),
                                    maxLines: 6,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      hintText: "Enter your Note content",
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
                                        .addNote(
                                          _titleController.text,
                                          _contentController.text,
                                        )
                                        .then(
                                            (_) => Navigator.of(context).pop());
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Add Note',
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
                },
              );
            },
          ),
          //Floating action menu item
          Bubble(
            title: "Log out",
            iconColor: Colors.white,
            bubbleColor: Theme.of(context).primaryColor,
            icon: Icons.logout,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              FirebaseAuth.instance.signOut();
            },
          ),
        ],

        // animation controller
        animation: _animation,

        // On pressed change animation state
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),

        // Floating Action button Icon color
        iconColor: Colors.white,

        // Flaoting Action button Icon
        iconData: Icons.menu,
        backGroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
