part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class GetMyFilesLoadingState extends HomeState {}

class GetMyFilesSuccessState extends HomeState {
  final List<FileModel> files;

  GetMyFilesSuccessState({required this.files});
}

class GetMyFilesFailureState extends HomeState {}

class CreatePublicFileLoadingState extends HomeState {}

class CreatePublicFileSuccessState extends HomeState {}

class CreatePublicFileFailureState extends HomeState {}

class CheckInFileLoadingState extends HomeState {}

class CheckInFileSuccessState extends HomeState {}

class CheckInFileFailureState extends HomeState {}

class CheckOutFileLoadingState extends HomeState {}

class CheckOutFileSuccessState extends HomeState {}

class CheckOutFileFailureState extends HomeState {}

class DownloadFileLoadingState extends HomeState {}

class DownloadFileSuccessState extends HomeState {}

class DownloadFileFailureState extends HomeState {}
