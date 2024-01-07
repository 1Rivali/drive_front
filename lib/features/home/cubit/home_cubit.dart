import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:drive_front/features/home/models/file.dart';
import 'package:drive_front/utils/network/dio_helper.dart';
import 'package:meta/meta.dart';
import 'dart:html' as html;
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void getMyFiles() async {
    try {
      emit(GetMyFilesLoadingState());
      Response<dynamic>? response =
          await DioHelper.postAuthorized(path: '/file/myFile');
      List<dynamic> filesData = response!.data['date'];
      List<FileModel> files = filesData
          .map((dynamic file) =>
              FileModel.fromJson(file as Map<String, dynamic>))
          .toList();
      emit(GetMyFilesSuccessState(files: files));
    } on DioException catch (e) {
      emit(GetMyFilesFailureState());
    }
  }

  void createPublicFile({required MultipartFile file, String? fileName}) async {
    try {
      emit(CreatePublicFileLoadingState());
      FormData data = FormData.fromMap({
        "file": file,
        "name_file": fileName ?? file.filename,
      });
      await DioHelper.postAuthorized(path: '/file/public/create', data: data);
      emit(CreatePublicFileSuccessState());
      getMyFiles();
    } on DioException catch (e) {
      emit(CreatePublicFileFailureState());
      getMyFiles();
    }
  }

  void checkInFiles(List ids) async {
    try {
      emit(CheckInFileLoadingState());
      await DioHelper.postAuthorized(
          path: '/file/bulk-check-in', data: {"ids": ids.toString()});

      emit(CheckInFileSuccessState());
      getMyFiles();
    } on DioException catch (e) {
      emit(CheckInFileFailureState());
      getMyFiles();
    }
  }

  void checkOutFile(int id) async {
    try {
      emit(CheckOutFileLoadingState());
      await DioHelper.postAuthorized(
          path: '/file/check-out', data: {"id_file": id.toString()});

      emit(CheckOutFileSuccessState());
      getMyFiles();
    } on DioException catch (e) {
      emit(CheckOutFileFailureState());
      getMyFiles();
    }
  }

  void downloadFile(int id, String name) async {
    try {
      emit(DownloadFileLoadingState());
      final response = await DioHelper.postAuthorized(
        path: '/file/download',
        data: {"id_file": id},
        responseType: ResponseType.bytes,
      );
      Uint8List data = Uint8List.fromList(response!.data);
      final blob = html.Blob([data]);
      final anchor =
          html.AnchorElement(href: html.Url.createObjectUrlFromBlob(blob))
            ..target = 'blank'
            ..download = name;
      html.document.body!.children.add(anchor);
      html.document.body!.children.remove(anchor);
      anchor.click();
      emit(DownloadFileSuccessState());
      getMyFiles();
    } catch (e) {
      emit(DownloadFileFailureState());
      getMyFiles();
    }
  }
}
