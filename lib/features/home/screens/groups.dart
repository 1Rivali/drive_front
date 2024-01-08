import 'dart:developer';

import 'package:drive_front/features/home/cubit/groups/groups_cubit.dart';
import 'package:drive_front/features/home/screens/group_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  void initState() {
    context.read<GroupsCubit>().getMyGroups();
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
              context.read<GroupsCubit>().getMyGroups();
            },
          ),
          title: const Center(child: Text("Groups")),
          trailing: TextButton(
            child: const Text("Create New Group"),
            onPressed: () {
              _buildNewGroupDialog(context);
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<GroupsCubit, GroupsState>(
              builder: (context, state) {
                bool isLoading = state is GetMyGroupsLoadingState;
                bool isError = state is GetMyGroupsFailureState;
                bool isSuccess = state is GetMyGroupsSuccessState;
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
                          context.read<GroupsCubit>().getMyGroups(),
                    ),
                  );
                }
                if (isSuccess) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 200,
                          child: ListTile(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GroupFilesScreen(
                                groupId: state.groups[index].idGroup!,
                                groupName: state.groups[index].nameGroup!,
                              ),
                            )),
                            title: Text(state.groups[index].nameGroup!),
                            leading: const Icon(Icons.group),
                            trailing: Text(state.groups[index].userAdmin!),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: state.groups.length);
                }
                return const SizedBox();
              },
            ),
          ),
        )
      ],
    );
  }

  Future<dynamic> _buildNewGroupDialog(BuildContext context) {
    final TextEditingController groupNameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create a new group"),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.group),
                  hintText: "Group Name",
                ),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    context
                        .read<GroupsCubit>()
                        .createGroup(groupNameController.text);
                  },
                  icon: const Icon(Icons.create),
                  label: const Text("Submit!"))
            ],
          ),
        ),
      ),
    );
  }
}
