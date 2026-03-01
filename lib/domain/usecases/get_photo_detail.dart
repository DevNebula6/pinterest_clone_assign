import '../entities/pin.dart';
import '../repositories/photo_repository.dart';
import '../../core/network/api_response.dart';

class GetPhotoDetail {
  GetPhotoDetail(this.repository);

  final PhotoRepository repository;

  ApiResult<Pin> call(int id) {
    return repository.getPhotoDetail(id);
  }
}
