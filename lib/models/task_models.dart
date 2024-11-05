class TaskModel {
  final String id;
  final String title;
  final String description;
  

  TaskModel({
    required this.id,
    required this.title,
    required this.description,

  });

  factory TaskModel.fromJson(Map<String, dynamic> json){
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],


    );

  }


}
