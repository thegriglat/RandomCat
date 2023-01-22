const catImageUrl = 'https://aws.random.cat/meow';

class CatImage {
  final String file;

  const CatImage({
    required this.file,
  });

  factory CatImage.fromJson(Map<String, dynamic> json) {
    return CatImage(
      file: json['file'],
    );
  }
}
