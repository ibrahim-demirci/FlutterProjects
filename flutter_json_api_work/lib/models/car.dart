import 'package:flutter_json_api_work/models/model.dart';

class Car {

  String name;
  String country;
  int foundation_date;
  List<Model> model;

	Car.fromJsonMap(Map<String, dynamic> map): 
		name = map["name"],
		country = map["country"],
		foundation_date = map["foundation_date"],
		model = List<Model>.from(map["model"].map((it) => Model.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = name;
		data['country'] = country;
		data['foundation_date'] = foundation_date;
		data['model'] = model != null ? 
			this.model.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
