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

  void getPublicFiles() async {
    try {
      emit(GetPublicFilesLoadingState());
      Response<dynamic>? response =
          await DioHelper.postAuthorized(path: '/file/public');
      List<dynamic> filesData = response!.data['date'];
      List<FileModel> files = filesData
          .map((dynamic file) =>
              FileModel.fromJson(file as Map<String, dynamic>))
          .toList();
      emit(GetPublicFilesSuccessState(files: files));
    } on DioException catch (e) {
      emit(GetPublicFilesFailureState());
    }
  }

  void createPublicFile(
      {required MultipartFile file,
      String? fileName,
      required String category}) async {
    try {
      emit(CreatePublicFileLoadingState());
      FormData data = FormData.fromMap({
        "file": file,
        "name_file": fileName ?? file.filename,
      });
      await DioHelper.postAuthorized(path: '/file/public/create', data: data);
      emit(CreatePublicFileSuccessState());
    } on DioException catch (e) {
      emit(CreatePublicFileFailureState());
    } finally {
      if (category == "Public") {
        getPublicFiles();
      }
      if (category == "My") {
        getMyFiles();
      }
    }
  }

  void checkInFiles(List ids, String category) async {
    try {
      emit(CheckInFileLoadingState());
      await DioHelper.postAuthorized(
          path: '/file/bulk-check-in', data: {"ids": ids.toString()});

      emit(CheckInFileSuccessState());
    } on DioException catch (e) {
      emit(CheckInFileFailureState());
    } finally {
      if (category == "Public") {
        getPublicFiles();
      }
      if (category == "My") {
        getMyFiles();
      }
    }
  }

  void checkOutFile(int id, String category) async {
    try {
      emit(CheckOutFileLoadingState());
      await DioHelper.postAuthorized(
          path: '/file/check-out', data: {"id_file": id.toString()});

      emit(CheckOutFileSuccessState());
    } on DioException catch (e) {
      emit(CheckOutFileFailureState());
    } finally {
      if (category == "Public") {
        getPublicFiles();
      }
      if (category == "My") {
        getMyFiles();
      }
    }
  }

  void downloadFile(int id, String name, String category) async {
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
    } catch (e) {
      emit(DownloadFileFailureState());
    } finally {
      if (category == "Public") {
        getPublicFiles();
      }
      if (category == "My") {
        getMyFiles();
      }
    }
  }
}
