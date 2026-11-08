// Experiment 1(b): Simple Dart Program to Understand Language Basics
// Demonstrates variables, data types, functions, lists, maps, classes, and null safety.

class Student {
  final String name;
  final int semester;
  final List<String> subjects;

  Student({
    required this.name,
    required this.semester,
    required this.subjects,
  });

  String getSummary() {
    return '$name (Sem $semester) - Enrolled in ${subjects.length} subjects';
  }
}

int calculateTotalStudyHours(List<int> dailyHours) {
  int total = 0;
  for (int hours in dailyHours) {
    total += hours;
  }
  return total;
}

void main() {
  // 1. Variables and Data Types
  String appName = 'Student Study & Task Hub';
  int totalExperiments = 10;
  double targetGpa = 9.2;
  bool isDeployed = true;

  // 2. Lists and Maps
  List<int> weeklyHours = [3, 4, 2, 5, 4, 6, 3];
  Map<String, String> courseDetails = {
    'code': 'CS-FLUTTER',
    'title': 'Cross-Platform Mobile & Web Development',
  };

  // 3. Object Creation and Method Call
  Student student = Student(
    name: 'Alex',
    semester: 6,
    subjects: ['Flutter', 'Cloud Computing', 'Software Testing'],
  );

  // 4. Null Safety
  String? optionalNote;
  String displayNote = optionalNote ?? 'All syllabus experiments completed.';

  print('Application: $appName (${courseDetails['code']})');
  print('Student: ${student.getSummary()}');
  print('Weekly Study Hours: ${calculateTotalStudyHours(weeklyHours)} hrs');
  print('Target GPA: $targetGpa | Experiments: $totalExperiments | Live: $isDeployed');
  print('Status: $displayNote');
}
