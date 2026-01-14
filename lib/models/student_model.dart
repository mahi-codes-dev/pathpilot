class StudentModel {
  final String uid;
  final String name;
  final String branch;
  final String goal;

  StudentModel({
    required this.uid,
    required this.name,
    required this.branch,
    required this.goal,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'branch': branch,
      'goal': goal,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      uid: map['uid'],
      name: map['name'],
      branch: map['branch'],
      goal: map['goal'],
    );
  }
}
