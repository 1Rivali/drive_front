import 'package:drive_front/features/home/cubit/home/home_cubit.dart';
import 'package:drive_front/features/home/models/file.dart';
import 'package:drive_front/features/home/screens/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayFilesGrid extends StatefulWidget {
  const DisplayFilesGrid({
    super.key,
    required this.files,
    required this.category,
  });

  final List files;
  final String category;
  @override
  State<DisplayFilesGrid> createState() => _DisplayFilesGridState();
}

class _DisplayFilesGridState extends State<DisplayFilesGrid> {
  final List<int> checkInFiles = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (checkInFiles.isNotEmpty)
          ElevatedButton.icon(
              onPressed: () {
                context
                    .read<HomeCubit>()
                    .checkInFiles(checkInFiles, widget.category);
              },
              icon: const Icon(Icons.check),
              label: const Text('Check In')),
        Expanded(
          child: GridView.builder(
            itemCount: widget.files.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
            ),
            itemBuilder: (context, index) {
              var file = widget.files[index];
              return InkWell(
                onTap: () {
                  buildAboutFileDialog(context, file, widget.category);
                },
                child: GridTile(
                  header: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: file.state! == "check-out"
                              ? Colors.green
                              : Colors.red,
                        ),
                        if (file.state == "check-out")
                          Checkbox(
                            value: file.isChecked,
                            onChanged: (value) {
                              file.isChecked = value;
                              setState(() {
                                if (value == true) {
                                  checkInFiles.add(file.id!);
                                }
                                if (value == false) {
                                  checkInFiles.remove(file.id);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  footer: Center(child: Text(file.nameFile!)),
                  child: const Image(
                    image: AssetImage('assets/images/file.png'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
