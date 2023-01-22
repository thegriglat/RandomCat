const catFactUrl = 'https://meowfacts.herokuapp.com/?lang=rus-ru';

class CatFact {
  final String text;

  const CatFact({
    required this.text,
  });

  factory CatFact.fromJson(Map<String, dynamic> json) {
    return CatFact(
      text: json['data'][0],
    );
  }
}
