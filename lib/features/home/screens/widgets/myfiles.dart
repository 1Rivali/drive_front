import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drive_front/features/home/cubit/home_cubit.dart';
import 'package:drive_front/features/home/models/file.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFilesScreen extends StatefulWidget {
  const MyFilesScreen({super.key});

  @override
  State<MyFilesScreen> createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen> {
  final fileNameController = TextEditingController();
  final List<int> checkInFiles = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeCubit>().getMyFiles();
            },
          ),
          title: const Center(child: Text("My Files")),
          trailing: IconButton(
              onPressed: () {
                _buildAddFileDialog(context);
              },
              icon: const Icon(Icons.add)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                log(state.toString());
                bool isLoading = state is GetMyFilesLoadingState ||
                    state is CheckInFileLoadingState;
                bool isError = state is GetMyFilesFailureState;
                bool isSuccess = state is GetMyFilesSuccessState;
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (isError) {
                  return Center(
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => context.read<HomeCubit>().getMyFiles(),
                    ),
                  );
                }
                if (isSuccess) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (checkInFiles.isNotEmpty)
                        ElevatedButton.icon(
                            onPressed: () {
                              context
                                  .read<HomeCubit>()
                                  .checkInFiles(checkInFiles);
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Check In')),
                      const SizedBox(
                        height: 25,
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: state.files.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                          ),
                          itemBuilder: (context, index) {
                            FileModel file = state.files[index];
                            return InkWell(
                              onTap: () {
                                _buildAboutFileDialog(context, file);
                              },
                              child: GridTile(
                                header: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            file.state! == "check-out"
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                      if (file.state == "check-out")
                                        Checkbox(
                                          value: file.isChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              file.isChecked = value;
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
                return const SizedBox();
              },
            ),
          ),
        )
      ],
    );
  }

  Future<dynamic> _buildAboutFileDialog(BuildContext context, FileModel file) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(file.nameFile!),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("id:\t${file.id}"),
                  Text("name:\t${file.name}"),
                  Text("state:\t${file.state}"),
                  Text("user checked in:\t${file.userNameCheckIn}"),
                  Text("upload date:\t${file.uploadDate}"),
                  Text("update date:\t${file.updateDate}"),
                ],
              ),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<HomeCubit>().checkOutFile(file.id!),
                    icon: const Icon(Icons.cancel),
                    label: const Text("Check out"),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<HomeCubit>()
                          .downloadFile(file.id!, file.name!);
                    },
                    icon: const Icon(Icons.file_download),
                    label: const Text("Download"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _buildAddFileDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            bool isLoading = state is CreatePublicFileLoadingState;
            bool isSuccess = state is CreatePublicFileSuccessState;
            MultipartFile? file;
            return AlertDialog(
                title: Row(
                  children: [
                    const Text("Upload new public File"),
                    if (!isLoading)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      )
                  ],
                ),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            file = MultipartFile.fromBytes(
                                result.files.single.bytes!,
                                filename: result.files.single.name);
                          }
                        },
                        icon: const Icon(Icons.file_copy),
                        label: const Text("Pick a file"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: fileNameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.file_present_sharp),
                          hintText: "File Name",
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (fileNameController.text.isNotEmpty &&
                                    file != null) {
                                  context.read<HomeCubit>().createPublicFile(
                                      file: file!,
                                      fileName: fileNameController.text);
                                }
                              },
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Text("Upload"),
                      ),
                      if (isSuccess)
                        const Text(
                          "File Added Successfuly",
                          style: TextStyle(color: Colors.green),
                        ),
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}
