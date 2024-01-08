import 'package:drive_front/features/home/cubit/home/home_cubit.dart';
import 'package:drive_front/features/home/screens/widgets/dialogs.dart';
import 'package:drive_front/features/home/screens/widgets/display_files_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Public extends StatefulWidget {
  const Public({super.key});

  @override
  State<Public> createState() => _PublicState();
}

class _PublicState extends State<Public> {
  final fileNameController = TextEditingController();
  @override
  void initState() {
    context.read<HomeCubit>().getPublicFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeCubit>().getPublicFiles();
            },
          ),
          title: const Center(child: Text("Public Files")),
          trailing: IconButton(
              onPressed: () {
                buildAddFileDialog(context, fileNameController, "Public");
              },
              icon: const Icon(Icons.add)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                bool isLoading = state is GetPublicFilesLoadingState ||
                    state is CheckInFileLoadingState;
                bool isError = state is GetPublicFilesFailureState;
                bool isSuccess = state is GetPublicFilesSuccessState;
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (isError) {
                  return Center(
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () =>
                          context.read<HomeCubit>().getPublicFiles(),
                    ),
                  );
                }
                if (isSuccess) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Expanded(
                          child: DisplayFilesGrid(
                        files: state.files,
                        category: "Public",
                      )),
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
}
