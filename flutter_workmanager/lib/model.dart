class Model {
  String? morning;
  String? night;
  String? date;

  Model({this.date, this.morning, this.night});

  Model.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    night = json['maghrib'];
    morning = json['fajr'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['date'] = this.date;
  //   data['fajr'] = this.fajr;
  //   data['sun'] = this.sun;
  //   data['dhuhr'] = this.dhuhr;
  //   data['asr'] = this.asr;
  //   data['maghrib'] = this.maghrib;
  //   data['isha'] = this.isha;
  //   return data;
  // }
}
