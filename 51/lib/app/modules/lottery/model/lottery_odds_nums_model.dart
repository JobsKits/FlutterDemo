class LotteryOddsNumsModel {
  Map<String, Map<String, int>> data;

  // Constructor
  LotteryOddsNumsModel({required this.data});

  // Factory method to create an instance from JSON
  factory LotteryOddsNumsModel.fromJson(Map<String, dynamic> json) {
    return LotteryOddsNumsModel(
      data: json.map((key, value) {
        return MapEntry(key, Map<String, int>.from(value));
      }),
    );
  }

  // Method to convert the model back to JSON
  Map<String, dynamic> toJson() {
    return data.map((key, value) {
      return MapEntry(key, Map<String, int>.from(value));
    });
  }
}
