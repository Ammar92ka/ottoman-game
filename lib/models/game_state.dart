class GameState {
  double treasury = 12000;
  double debt = 0;
  int sultan = 65;
  int stability = 63;
  double grain = 12;
  double inflation = 4;
  int month = 1;
  String provider = 'Gemini';
  List<String> history = [];

  Map<String, dynamic> toJson() => {
    'treasury': treasury, 'debt': debt, 'sultan': sultan,
    'stability': stability, 'grain': grain, 'month': month,
  };
}
