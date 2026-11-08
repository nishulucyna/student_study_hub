import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const StudyHubApp(),
    ),
  );
}

// ============================================================================
// EXP 1(b): Dart Model Class & Language Basics
// ============================================================================
class StudyTask {
  final String id;
  final String title;
  final String subject;
  final String priority;
  final String studentEmail;
  bool isCompleted;

  StudyTask({
    required this.id,
    required this.title,
    required this.subject,
    required this.priority,
    required this.studentEmail,
    this.isCompleted = false,
  });
}

// ============================================================================
// EXP 5(b): State Management using Provider (ChangeNotifier)
// ============================================================================
class TaskProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  final List<StudyTask> _tasks = [
    StudyTask(
      id: '1',
      title: 'Implement Row, Column & Stack Layouts',
      subject: 'Exp 2: Flutter Widgets',
      priority: 'High',
      studentEmail: 'student@university.edu',
      isCompleted: true,
    ),
    StudyTask(
      id: '2',
      title: 'Responsive UI with MediaQuery Breakpoints',
      subject: 'Exp 3: Responsive Design',
      priority: 'High',
      studentEmail: 'student@university.edu',
      isCompleted: true,
    ),
    StudyTask(
      id: '3',
      title: 'Design Form Validation & Error Handling',
      subject: 'Exp 7: Flutter Forms',
      priority: 'Medium',
      studentEmail: 'student@university.edu',
      isCompleted: false,
    ),
    StudyTask(
      id: '4',
      title: 'Fetch REST API Data & Write Unit Tests',
      subject: 'Exp 9 & 10: API & Testing',
      priority: 'Low',
      studentEmail: 'student@university.edu',
      isCompleted: false,
    ),
  ];

  List<StudyTask> get tasks => List.unmodifiable(_tasks);
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;

  void addTask({
    required String title,
    required String subject,
    required String priority,
    required String email,
  }) {
    _tasks.insert(
      0,
      StudyTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        subject: subject,
        priority: priority,
        studentEmail: email,
      ),
    );
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

// ============================================================================
// EXP 4(b) & EXP 6(b): Named Routes & Custom Theme Styling
// ============================================================================
class StudyHubApp extends StatelessWidget {
  const StudyHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return MaterialApp(
      title: 'Student Study & Task Hub',
      debugShowCheckedModeBanner: false,
      themeMode: taskProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 2,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add-task': (context) => const AddTaskScreen(),
        '/api-quotes': (context) => const ApiQuotesScreen(),
      },
    );
  }
}

// ============================================================================
// EXP 6(a): Custom Reusable Widget for Specific UI Elements
// ============================================================================
class CustomTaskCard extends StatelessWidget {
  final StudyTask task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const CustomTaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFB91C1C);
      case 'Medium':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF15803D);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task.subject} • ${task.studentEmail}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: _getPriorityColor(task.priority)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.priority,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getPriorityColor(task.priority),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete Task',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// EXP 2, 3, 4, 5, 8: Home Screen (Layouts, Responsive UI, Animations, State)
// ============================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // EXP 5(b): Local UI state managed with setState
  bool _isBannerExpanded = false;

  @override
  void initState() {
    super.initState();
    // EXP 8(a) & 8(b): Explicit Fade and Slide Animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    // EXP 3(a) & 3(b): MediaQuery & Breakpoints for Responsive Design
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Study & Task Hub'),
        actions: [
          IconButton(
            icon: Icon(
              provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme (Exp 6b)',
            onPressed: () => provider.toggleTheme(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // EXP 2(a) & 2(b): Stack, Container, Row, Column, Text, Image
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 64,
                                    height: 64,
                                    color: const Color(0xFF334155),
                                    child: const Icon(
                                      Icons.school,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Academic Study Planner',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Total Tasks: ${provider.tasks.length}  |  Completed: ${provider.completedCount}  |  Pending: ${provider.pendingCount}',
                                      style: const TextStyle(
                                        color: Color(0xFFCBD5E1),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Responsive Layout: ${isWideScreen ? "Desktop Grid (>700px)" : "Mobile List (<=700px)"} [Width: ${screenWidth.toInt()}px]',
                                      style: const TextStyle(
                                        color: Color(0xFF93C5FD),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Stack Badge',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // EXP 4(a) & 4(b): Navigation Bar using Named Routes
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/add-task'),
                          icon: const Icon(Icons.add_task),
                          label: const Text('Add New Task (Form)'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/api-quotes'),
                          icon: const Icon(Icons.cloud_download_outlined),
                          label: const Text('Fetch Study Quotes (REST API)'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            // EXP 5(b) & EXP 8: setState + AnimatedContainer toggle
                            setState(() {
                              _isBannerExpanded = !_isBannerExpanded;
                            });
                          },
                          icon: const Icon(Icons.animation),
                          label: const Text('Toggle Animation Demo'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // EXP 8(a) & 8(b): Implicit Animation (AnimatedContainer)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(_isBannerExpanded ? 18.0 : 12.0),
                      decoration: BoxDecoration(
                        color: _isBannerExpanded
                            ? const Color(0xFFDBEAFE)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isBannerExpanded
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isBannerExpanded
                                ? Icons.auto_awesome
                                : Icons.info_outline,
                            color: const Color(0xFF1E3A8A),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _isBannerExpanded
                                  ? 'Animation Active (Expanded): Using AnimatedContainer, FadeTransition & SlideTransition (Exp 8).'
                                  : 'Click "Toggle Animation Demo" to test Flutter UI animations (Exp 8).',
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Course Tasks & Syllabus Checklist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // EXP 3(a) & 3(b): Responsive Switch between 2-Column Grid and 1-Column List
                    if (provider.tasks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: Text('No tasks remaining. Add a new task!'),
                        ),
                      )
                    else if (isWideScreen)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 108,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: provider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = provider.tasks[index];
                          return CustomTaskCard(
                            task: task,
                            onToggle: () => provider.toggleTaskStatus(task.id),
                            onDelete: () => provider.deleteTask(task.id),
                          );
                        },
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = provider.tasks[index];
                          return CustomTaskCard(
                            task: task,
                            onToggle: () => provider.toggleTaskStatus(task.id),
                            onDelete: () => provider.deleteTask(task.id),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EXP 7(a) & 7(b): Form with Input Fields, Validation, and Error Handling
// ============================================================================
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedPriority = 'High';

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<TaskProvider>().addTask(
            title: _titleController.text.trim(),
            subject: _subjectController.text.trim(),
            priority: _selectedPriority,
            email: _emailController.text.trim(),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task validated and added successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Study Task (Form Validation)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create New Study Task',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Demonstrates Form, TextFormField, DropdownButtonFormField, and Validation (Exp 7).',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'e.g., Revise State Management',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Task title is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Title must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject / Module',
                      hintText: 'e.g., CS301 - Flutter Lab',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Subject name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Student Email',
                      hintText: 'student@college.edu',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email address is required';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority Level',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'High', child: Text('High')),
                      DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPriority = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Validate & Save Task'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EXP 9(a) & 9(b): Fetch Data from REST API and Display in UI
// ============================================================================
class ApiQuotesScreen extends StatefulWidget {
  const ApiQuotesScreen({super.key});

  @override
  State<ApiQuotesScreen> createState() => _ApiQuotesScreenState();
}

class _ApiQuotesScreenState extends State<ApiQuotesScreen> {
  late Future<List<Map<String, String>>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _quotesFuture = _fetchStudyQuotes();
  }

  Future<List<Map<String, String>>> _fetchStudyQuotes() async {
    try {
      final response = await http
          .get(Uri.parse('https://dummyjson.com/quotes?limit=6'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> quotesList = data['quotes'] ?? [];
        return quotesList
            .map((item) => {
                  'quote': item['quote'].toString(),
                  'author': item['author'].toString(),
                })
            .toList();
      }
      throw Exception('Server returned status ${response.statusCode}');
    } catch (e) {
      // Fallback dataset if offline during lab exam
      return [
        {
          'quote': 'Learning never exhausts the mind.',
          'author': 'Leonardo da Vinci (Fallback Mode)',
        },
        {
          'quote': 'First, solve the problem. Then, write the code.',
          'author': 'John Johnson (Fallback Mode)',
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Data (Exp 9)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Motivational Quotes from REST API',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Endpoint: GET https://dummyjson.com/quotes?limit=6',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<Map<String, String>>>(
                    future: _quotesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final quotes = snapshot.data ?? [];
                      return ListView.separated(
                        itemCount: quotes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = quotes[index];
                          return Card(
                            elevation: 1,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text('"${item['quote']}"'),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  '— ${item['author']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
