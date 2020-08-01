class Bully {
  int error;
  double result0;
  double result1;
  double result2;
  double result3;
  double result4;
  double result5;

  Bully(this.error, this.result0, this.result1, this.result2, this.result3,
      this.result4, this.result5);

  Bully.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        result0 = json['value 0'],
        result1 = json['value 1'],
        result2 = json['value 2'],
        result3 = json['value 3'],
        result4 = json['value 4'],
        result5 = json['value 5'];

  Map<String, dynamic> toJson() =>
      {
        'error' : error,
        'result 0' : result0,
        'result 1' : result1,
        'result 2' : result2,
        'result 3' : result3,
        'result 4' : result4,
        'result 5' : result5,
      };
}

