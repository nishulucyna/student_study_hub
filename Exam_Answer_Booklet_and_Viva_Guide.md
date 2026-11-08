# Exam Answer Booklet & Viva Study Guide
**Project Name:** Student Study & Task Hub  
**Live URL:** https://nishulucyna.github.io/student_study_hub/  
**GitHub Repo:** https://github.com/nishulucyna/student_study_hub

---

## PART A: What to Write in Your Exam Answer Booklet
*(Memorize these 6 short sections — they directly answer every required prompt in the exam instructions!)*

### 1. Application Name & What It Does
- **Name:** **Student Study & Task Hub**
- **What it does:** It is a cross-platform Flutter web and mobile application that allows students to organize academic study tasks, track completed and pending tasks, add new tasks through a validated form, toggle Light/Dark themes, and fetch live motivational quotes from a REST API.

### 2. Purpose & Objectives
- To provide a simple, distraction-free study planner for students.
- To practically implement all 10 Flutter syllabus experiments: basic widgets and layouts (`Row`, `Column`, `Stack`), responsive design (`MediaQuery`), named route navigation, state management (`setState` and `Provider`), custom reusable widgets and themes, form validation, UI animations, REST API integration (`http`), and unit/widget testing (`flutter_test`).

### 3. Tools and Technologies Used
1. **Flutter SDK (3.x):** UI toolkit for building natively compiled web and mobile apps from a single codebase.
2. **Dart Language:** Object-oriented programming language with sound null safety and `async`/`await`.
3. **Provider Package (`provider`):** State management using `ChangeNotifier` and `ChangeNotifierProvider`.
4. **HTTP Package (`http` & `dart:convert`):** For making asynchronous REST API `GET` requests and decoding JSON.
5. **Flutter Test (`flutter_test`):** For writing unit tests and widget tests.
6. **GitHub Actions & GitHub Pages:** For automated CI/CD testing, building the web bundle, and hosting.

### 4. Major Features Implemented (Mapped to Syllabus)
1. **Layouts (`Exp 2`):** Uses `Stack` (banner with positioned badge), `Row`, `Column`, `Container`, `Text`, and `Image.network`.
2. **Responsive UI (`Exp 3`):** Uses `MediaQuery.of(context).size.width > 700` breakpoint to switch between a 2-column `GridView` (Desktop) and a 1-column `ListView` (Mobile).
3. **Navigation (`Exp 4`):** Uses Named Routes (`'/'`, `'/add-task'`, `'/api-quotes'`) with `Navigator.pushNamed(context, route)` and `Navigator.pop(context)`.
4. **State Management (`Exp 5`):** Uses `TaskProvider extends ChangeNotifier` (`notifyListeners()`, `context.watch()`, `context.read()`) for global tasks and theme state, and `setState()` for local form dropdown and animation state.
5. **Custom Widgets & Themes (`Exp 6`):** Reusable `CustomTaskCard` widget and Material 3 Light/Dark `ThemeData`.
6. **Forms & Validation (`Exp 7`):** Uses `Form` with `GlobalKey<FormState>()`, `TextFormField` (checks empty fields, title length >= 3, and valid email containing `@` and `.`), and `DropdownButtonFormField`.
7. **Animations (`Exp 8`):** Uses `AnimationController`, `FadeTransition`, `SlideTransition`, and `AnimatedContainer`.
8. **REST API (`Exp 9`):** Fetches JSON quotes from `https://dummyjson.com/quotes?limit=6` using `http.get()` and displays them with `FutureBuilder` and `ListView.separated`.
9. **Unit & Widget Testing (`Exp 10`):** Tests task addition/toggling/deletion in `TaskProvider` and tests UI rendering & form validation errors using `testWidgets`.

### 5. How It Was Developed & Deployed
1. **Development:**
   - Created project structure with `pubspec.yaml` (`provider`, `http`), `lib/main.dart`, `lib/dart_basics.dart`, and `test/widget_test.dart`.
   - Built modular screens (`HomeScreen`, `AddTaskScreen`, `ApiQuotesScreen`) and custom widget (`CustomTaskCard`).
   - Verified business logic and UI validation using `flutter test`.
2. **Deployment (GitHub Actions + GitHub Pages):**
   - Pushed code to the `main` branch on GitHub (`nishulucyna/student_study_hub`).
   - Configured `.github/workflows/deploy.yml` using `subosito/flutter-action@v2` to run `flutter pub get`, `flutter test`, and build the release web bundle:
     ```bash
     flutter build web --base-href "/student_study_hub/" --release
     ```
   - Used `JamesIves/github-pages-deploy-action@v4` to deploy `build/web` to the `gh-pages` branch, hosted live at `https://nishulucyna.github.io/student_study_hub/`.

---

## PART B: Short Code Snippets to Memorize for Written Exam

### 1. Responsive Breakpoint (`MediaQuery`)
```dart
final width = MediaQuery.of(context).size.width;
final isWide = width > 700;
return isWide ? GridView.builder(...) : ListView.builder(...);
```

### 2. Named Routes (`MaterialApp` & `Navigator`)
```dart
MaterialApp(
  routes: {
    '/': (context) => const HomeScreen(),
    '/add-task': (context) => const AddTaskScreen(),
    '/api-quotes': (context) => const ApiQuotesScreen(),
  },
);
// Navigate:
Navigator.pushNamed(context, '/add-task');
```

### 3. Provider State Management (`ChangeNotifier`)
```dart
class TaskProvider extends ChangeNotifier {
  final List<StudyTask> _tasks = [];
  void addTask(StudyTask task) {
    _tasks.add(task);
    notifyListeners();
  }
}
```

### 4. Form Validation (`GlobalKey<FormState>`)
```dart
final _formKey = GlobalKey<FormState>();

TextFormField(
  validator: (val) => (val == null || val.isEmpty) ? 'Required field' : null,
);

if (_formKey.currentState!.validate()) {
  // Save data
}
```

### 5. REST API Fetch (`http.get` & `FutureBuilder`)
```dart
final response = await http.get(Uri.parse('https://dummyjson.com/quotes?limit=6'));
if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
}
```

---

## PART C: Top 10 Viva Questions & Answers

1. **Q: What is the difference between `StatelessWidget` and `StatefulWidget` in your project?**
   - **A:** `StatelessWidget` (like `StudyHubApp` and `CustomTaskCard`) is immutable and only depends on constructor arguments/inherited state. `StatefulWidget` (like `HomeScreen`, `AddTaskScreen`, `ApiQuotesScreen`) maintains mutable internal state (`State` object) that can trigger UI rebuilds via `setState()`.
2. **Q: How did you implement state management using both `setState` and `Provider`?**
   - **A:** I used `Provider` (`TaskProvider extends ChangeNotifier`) for app-wide state (the list of study tasks and dark/light theme mode), calling `notifyListeners()` on updates. I used `setState()` for screen-local UI state, such as selecting the priority dropdown in `AddTaskScreen` and toggling the `AnimatedContainer` banner in `HomeScreen`.
3. **Q: How does your app achieve responsiveness across mobile and desktop screens?**
   - **A:** Using `MediaQuery.of(context).size.width`. If the screen width is greater than `700px`, tasks are displayed in a 2-column `GridView.builder`; if `<= 700px`, it switches to a single-column `ListView.builder`.
4. **Q: How is navigation implemented in your application?**
   - **A:** Using Named Routes registered in `MaterialApp.routes` (`'/'`, `'/add-task'`, and `'/api-quotes'`). Screens are pushed onto the navigation stack with `Navigator.pushNamed(context, '/add-task')` and popped using `Navigator.pop(context)`.
5. **Q: How does form validation work in `AddTaskScreen`?**
   - **A:** All input fields (`TextFormField` and `DropdownButtonFormField`) are wrapped inside a `Form` widget linked to a `GlobalKey<FormState>()`. Each field defines a `validator` callback returning an error string if invalid or `null` if valid. Calling `_formKey.currentState!.validate()` runs all validators before saving.
6. **Q: What animations did you implement in the project?**
   - **A:** Both explicit animations (`AnimationController` with `FadeTransition` and `SlideTransition` using `SingleTickerProviderStateMixin`) and implicit animations (`AnimatedContainer` that smoothly animates its padding, background color, and border over 400ms).
7. **Q: How do you fetch and display data from the REST API?**
   - **A:** In `ApiQuotesScreen`, `_fetchStudyQuotes()` uses `http.get()` to call `https://dummyjson.com/quotes?limit=6` asynchronously, parses the JSON response using `jsonDecode()`, and displays the result in the UI using a `FutureBuilder` widget (which shows a `CircularProgressIndicator` while loading and a `ListView` when complete).
8. **Q: What Happens if the internet disconnects during the REST API call?**
   - **A:** The `http.get()` call is wrapped in a `try-catch` block with an 8-second timeout. If an exception occurs, it gracefully returns a fallback list of quotes so the UI never crashes.
9. **Q: What unit and widget tests did you write in `test/widget_test.dart`?**
   - **A:** I wrote 3 automated tests: (1) a unit test verifying `TaskProvider` adds, toggles, and deletes tasks; (2) a widget test verifying `HomeScreen` renders its header and task cards; and (3) a widget test verifying `AddTaskScreen` shows validation error messages when submitted empty.
10. **Q: Why did you pass `--base-href "/student_study_hub/"` when building for GitHub Pages?**
    - **A:** Because GitHub Pages hosts project sites under a subpath (`https://nishulucyna.github.io/student_study_hub/`) rather than the root domain, so `--base-href` sets `<base href="/student_study_hub/">` in `index.html` so assets and scripts load from the correct path.
