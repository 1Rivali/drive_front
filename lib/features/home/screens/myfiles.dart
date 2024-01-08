import 'package:drive_front/features/home/cubit/home/home_cubit.dart';
import 'package:drive_front/features/home/screens/widgets/dialogs.dart';
import 'package:drive_front/features/home/screens/widgets/display_files_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFilesScreen extends StatefulWidget {
  const MyFilesScreen({super.key});

  @override
  State<MyFilesScreen> createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen> {
  final fileNameController = TextEditingController();
  @override
  void initState() {
    context.read<HomeCubit>().getMyFiles();
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
              context.read<HomeCubit>().getMyFiles();
            },
          ),
          title: const Center(child: Text("My Files")),
          trailing: IconButton(
              onPressed: () {
                buildAddFileDialog(context, fileNameController, "My");
              },
              icon: const Icon(Icons.add)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
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
                  return DisplayFilesGrid(
                    files: state.files,
                    category: "My",
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
