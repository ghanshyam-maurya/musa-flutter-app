class LibraryResponse {
  int? status;
  String? message;
  List<LibraryFile>? voiceFile;
  List<LibraryFile>? imageFile;
  List<LibraryFile>? videoFile;

  LibraryResponse({
    this.status,
    this.message,
    this.voiceFile,
    this.imageFile,
    this.videoFile,
  });

  LibraryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['voice_file'] != null) {
      voiceFile = <LibraryFile>[];
      json['voice_file'].forEach((v) {
        voiceFile!.add(LibraryFile.fromJson(v));
      });
    }
    if (json['image_file'] != null) {
      imageFile = <LibraryFile>[];
      json['image_file'].forEach((v) {
        imageFile!.add(LibraryFile.fromJson(v));
      });
    }
    if (json['video_file'] != null) {
      videoFile = <LibraryFile>[];
      json['video_file'].forEach((v) {
        videoFile!.add(LibraryFile.fromJson(v));
      });
    }
  }
}

class LibraryFile {
  String? id;
  String? userId;
  String? fileLink;
  String? createdAt;

  LibraryFile({
    this.id,
    this.userId,
    this.fileLink,
    this.createdAt,
  });

  LibraryFile.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['user_id'];
    fileLink = json['file_link'];
    createdAt = json['created_at'];
  }
}
