
class Model {

  String model_name;
  int price;
  bool fuel;

	Model.fromJsonMap(Map<String, dynamic> map): 
		model_name = map["model_name"],
		price = map["price"],
		fuel = map["fuel"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['model_name'] = model_name;
		data['price'] = price;
		data['fuel'] = fuel;
		return data;
	}
}
