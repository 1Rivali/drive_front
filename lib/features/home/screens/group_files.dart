import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:drive_front/features/home/cubit/groups/groups_cubit.dart';
import 'package:drive_front/features/home/cubit/home/home_cubit.dart';
import 'package:drive_front/features/home/cubit/users/user_cubit.dart';
import 'package:drive_front/utils/widgets/page_decoration.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupFilesScreen extends StatefulWidget {
  const GroupFilesScreen(
      {super.key, required this.groupId, required this.groupName});
  final int groupId;
  final String groupName;
  @override
  State<GroupFilesScreen> createState() => _GroupFilesScreenState();
}

class _GroupFilesScreenState extends State<GroupFilesScreen> {
  final List<int> checkInFiles = [];
  final fileNameController = TextEditingController();
  final userIdController = TextEditingController();
  @override
  void initState() {
    context.read<UserCubit>().getGroupUsers(widget.groupId);
    context.read<GroupsCubit>().getGroupFiles(widget.groupId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageDecoration(
      scaffold: Scaffold(
          body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Add user to group"),
                              content: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextFormField(
                                      controller: userIdController,
                                      decoration: const InputDecoration(
                                        hintText: "User Id",
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                        onPressed: () => context
                                            .read<UserCubit>()
                                            .addUserToGroup(
                                              userId: userIdController.text,
                                              groupId: widget.groupId,
                                            ),
                                        icon: const Icon(Icons.add),
                                        label: const Text("Add"))
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text("Add User To Group")),
                  Expanded(
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        if (state is GetGroupUsersLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is GetGroupUsersSuccessState) {
                          return ListView.separated(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(state.users[index].userName!),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: state.users.length);
                        } else {
                          return Center(
                            child: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => context
                                  .read<UserCubit>()
                                  .getGroupUsers(widget.groupId),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      context.read<GroupsCubit>().getGroupFiles(widget.groupId);
                    },
                  ),
                  title: Center(child: Text("${widget.groupName} Files")),
                  trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return BlocBuilder<GroupsCubit, GroupsState>(
                                builder: (context, state) {
                                  MultipartFile? file;

                                  bool isLoading =
                                      state is CreateGroupFileLoadingState;

                                  return AlertDialog(
                                      title: Row(
                                        children: [
                                          const Text("Upload new group File"),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Column(
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles();

                                                if (result != null) {
                                                  file =
                                                      MultipartFile.fromBytes(
                                                          result.files.single
                                                              .bytes!,
                                                          filename: result.files
                                                              .single.name);
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
                                                prefixIcon: Icon(
                                                    Icons.file_present_sharp),
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
                                                      if (fileNameController
                                                              .text
                                                              .isNotEmpty &&
                                                          file != null) {
                                                        context
                                                            .read<GroupsCubit>()
                                                            .createGroupFile(
                                                                file: file!,
                                                                fileName:
                                                                    fileNameController
                                                                        .text,
                                                                groupId: widget
                                                                    .groupId);
                                                      }
                                                    },
                                              child: isLoading
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : const Text("Upload"),
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              );
                            });
                      },
                      icon: const Icon(Icons.add)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: BlocBuilder<GroupsCubit, GroupsState>(
                      builder: (context, state) {
                        bool isLoading = state is GetGroupFilesLoadingState;
                        bool isError = state is GetGroupFilesFailureState;
                        bool isSuccess = state is GetGroupFilesSuccessState;
                        if (isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (isError) {
                          return Center(
                            child: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => context
                                  .read<GroupsCubit>()
                                  .getGroupFiles(widget.groupId),
                            ),
                          );
                        }
                        if (isSuccess) {
                          return Column(
                            children: [
                              if (checkInFiles.isNotEmpty)
                                ElevatedButton.icon(
                                    onPressed: () {
                                      log(checkInFiles.toString());
                                      context.read<GroupsCubit>().checkInFiles(
                                            checkInFiles,
                                            widget.groupId,
                                          );
                                    },
                                    icon: const Icon(Icons.check),
                                    label: const Text('Check In')),
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
                                    var file = state.files[index];
                                    return InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(file.nameFile!),
                                            content: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "id:\t\t${file.idFile}"),
                                                      Text(
                                                          "name:\t\t${file.name}"),
                                                      Text(
                                                          "state:\t\t${file.state}"),
                                                      Text(
                                                          "uploaded at:\t\t${file.uploadDate}"),
                                                      Text(
                                                          "upload date:\t\t${file.uploadDate}"),
                                                      Text(
                                                          "update date:\t\t${file.updateDate}"),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      ElevatedButton.icon(
                                                        onPressed: () => context
                                                            .read<GroupsCubit>()
                                                            .checkOutFile(
                                                                file.idFile!,
                                                                widget.groupId),
                                                        icon: const Icon(
                                                            Icons.cancel),
                                                        label: const Text(
                                                            "Check out"),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      ElevatedButton.icon(
                                                        onPressed: () {
                                                          context
                                                              .read<HomeCubit>()
                                                              .downloadFile(
                                                                  file.id!,
                                                                  file.name!,
                                                                  "");
                                                        },
                                                        icon: const Icon(Icons
                                                            .file_download),
                                                        label: const Text(
                                                            "Download"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
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
                                                    file.isChecked = value;
                                                    setState(() {
                                                      if (value == true) {
                                                        checkInFiles
                                                            .add(file.idFile!);
                                                      }
                                                      if (value == false) {
                                                        checkInFiles.remove(
                                                            file.idFile);
                                                      }
                                                    });
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                        footer:
                                            Center(child: Text(file.nameFile!)),
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/images/file.png'),
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
            ),
          )
        ],
      )),
    );
  }
}
