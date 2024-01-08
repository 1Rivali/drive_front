import 'package:dio/dio.dart';
import 'package:drive_front/features/home/cubit/home/home_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> buildAboutFileDialog(
    BuildContext context, file, String category) {
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
                  onPressed: () => context
                      .read<HomeCubit>()
                      .checkOutFile(file.id!, category),
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
                        .downloadFile(file.id!, file.name!, category);
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

Future<dynamic> buildAddFileDialog(BuildContext context,
    TextEditingController fileNameController, String category) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => BlocBuilder<HomeCubit, HomeState>(
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
                                  fileName: fileNameController.text,
                                  category: category);
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
    ),
  );
}
