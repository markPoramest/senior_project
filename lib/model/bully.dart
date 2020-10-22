class Bully {
  int error;
  double result1;
  double result2;
  double result3;
  double result4;
  double result5;
  double result6;

  Bully(this.error, this.result1 ,this.result2, this.result3,
      this.result4, this.result5, this.result6);

  Bully.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        result1 = double.parse(json['class 1']),
        result2 = double.parse(json['class 2']),
        result3 = double.parse(json['class 3']),
        result4 = double.parse(json['class 4']),
        result5 = double.parse(json['class 5']),
        result6 = double.parse(json['class 6']);

  Map<String, dynamic> toJson() =>
      {
        'error' : error,
        'result 1' : result1,
        'result 2' : result2,
        'result 3' : result3,
        'result 4' : result4,
        'result 5' : result5,
        'result 6' : result6,
      };
}

