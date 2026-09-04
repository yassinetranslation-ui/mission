import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/dependency_injection.dart';
import '../../../services/child_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input.dart';

class AddChildScreen extends ConsumerStatefulWidget {
  const AddChildScreen({super.key});

  @override
  ConsumerState<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends ConsumerState<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGrade = '1st Grade';
  final List<String> _selectedSubjects = ['Math', 'Science'];
  bool _isLoading = false;

  final List<String> _grades = [
    'Pre-K',
    'Kindergarten',
    '1st Grade',
    '2nd Grade',
    '3rd Grade',
    '4th Grade',
    '5th Grade',
    '6th Grade',
    '7th Grade',
    '8th Grade',
  ];

  final List<String> _allSubjects = [
    'Math',
    'Science',
    'Arabic',
    'English',
    'History',
    'Geography',
    'Art',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(childRepositoryProvider);
      await repository.createChild(
        CreateChildRequest(
          name: _nameController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          gradeLevel: _selectedGrade,
          preferredSubjects: _selectedSubjects,
        ),
      );

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add child: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Child'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                    child: Icon(
                      Icons.face,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppInput(
                  controller: _nameController,
                  label: 'Child\'s Name',
                  hint: 'e.g. Omar, Sarah',
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppInput(
                  controller: _ageController,
                  label: 'Age',
                  hint: 'e.g. 8',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.cake_outlined),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an age';
                    }
                    final age = int.tryParse(value.trim());
                    if (age == null || age <= 0 || age > 18) {
                      return 'Please enter a valid age (1-18)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedGrade,
                  decoration: InputDecoration(
                    labelText: 'Grade Level',
                    prefixIcon: const Icon(Icons.school_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _grades.map((grade) {
                    return DropdownMenuItem(
                      value: grade,
                      child: Text(grade),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedGrade = val);
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Favorite / Target Subjects',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allSubjects.map((subject) {
                    final isSelected = _selectedSubjects.contains(subject);
                    return FilterChip(
                      label: Text(subject),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSubjects.add(subject);
                          } else {
                            _selectedSubjects.remove(subject);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 36),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  AppButton.primary(
                    label: 'Add Child Profile',
                    onPressed: _submit,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
