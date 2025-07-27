import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../domain/usecases/upload_photo_usecase.dart';
import 'photo_upload_event.dart';
import 'photo_upload_state.dart';

class PhotoUploadBloc extends Bloc<PhotoUploadEvent, PhotoUploadState> {
  final ImagePicker _picker = ImagePicker();
  final UploadPhotoUseCase _uploadPhotoUseCase;

  PhotoUploadBloc({required UploadPhotoUseCase uploadPhotoUseCase})
      : _uploadPhotoUseCase = uploadPhotoUseCase,
        super(PhotoUploadInitial()) {
    on<SelectPhoto>(_onSelectPhoto);
    on<TakePhoto>(_onTakePhoto);
    on<UploadPhoto>(_onUploadPhoto);
  }

  Future<void> _onSelectPhoto(
      SelectPhoto event, Emitter<PhotoUploadState> emit) async {
    try {
      print('PhotoUploadBloc: Fotoğraf seçme başladı');
      emit(PhotoUploadLoading());

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (image != null) {
        print('PhotoUploadBloc: Fotoğraf seçildi: ${image.path}');
        emit(PhotoUploadSuccess(File(image.path)));
      } else {
        print('PhotoUploadBloc: Fotoğraf seçilmedi (kullanıcı iptal etti)');
        emit(PhotoUploadInitial());
      }
    } catch (e) {
      print('PhotoUploadBloc: Fotoğraf seçme hatası: $e');
      emit(PhotoUploadError('Fotoğraf seçilirken hata oluştu: $e'));
    }
  }

  Future<void> _onTakePhoto(
      TakePhoto event, Emitter<PhotoUploadState> emit) async {
    try {
      print('PhotoUploadBloc: Fotoğraf çekme başladı');
      emit(PhotoUploadLoading());

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (image != null) {
        print('PhotoUploadBloc: Fotoğraf çekildi: ${image.path}');
        emit(PhotoUploadSuccess(File(image.path)));
      } else {
        print('PhotoUploadBloc: Fotoğraf çekilmedi (kullanıcı iptal etti)');
        emit(PhotoUploadInitial());
      }
    } catch (e) {
      print('PhotoUploadBloc: Fotoğraf çekme hatası: $e');
      emit(PhotoUploadError('Fotoğraf çekilirken hata oluştu: $e'));
    }
  }

  Future<void> _onUploadPhoto(
      UploadPhoto event, Emitter<PhotoUploadState> emit) async {
    try {
      print('PhotoUploadBloc: Upload başladı');

      // Önceki state'i kontrol et (PhotoUploadLoading emit etmeden önce)
      final previousState = state;

      if (previousState is PhotoUploadSuccess) {
        final currentState = previousState as PhotoUploadSuccess;
        print(
            'PhotoUploadBloc: Fotoğraf dosyası: ${currentState.imageFile.path}');

        emit(PhotoUploadLoading());

        final photoUrl = await _uploadPhotoUseCase(currentState.imageFile);
        print('PhotoUploadBloc: Upload başarılı! PhotoUrl: $photoUrl');

        // Başarılı yükleme sonrası yeni state emit et
        emit(PhotoUploadSuccess(currentState.imageFile, photoUrl: photoUrl));
      } else {
        print(
            'PhotoUploadBloc: Fotoğraf seçilmedi, önceki state: $previousState');
        emit(PhotoUploadError('Fotoğraf seçilmedi'));
      }
    } catch (e) {
      print('PhotoUploadBloc: Upload hatası: $e');
      emit(PhotoUploadError('Fotoğraf yüklenirken hata oluştu: $e'));
    }
  }
}
