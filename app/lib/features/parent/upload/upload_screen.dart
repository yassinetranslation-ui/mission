import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../../config/dependency_injection.dart';
import '../../../models/child_profile.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_input.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedFile;
  String? _fileType; // 'image' or 'pdf'
  int _fileSizeBytes = 0;

  List<ChildProfile> _children = [];
  String? _selectedChildId;
  String _selectedDifficulty = 'medium';
  int _selectedDuration = 10;
  bool _isLoading = false;
  bool _isChildrenLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      final repo = ref.read(childRepositoryProvider);
      final children = await repo.getChildren();
      if (mounted) {
        setState(() {
          _children = children;
          if (children.isNotEmpty) {
            _selectedChildId = children.first.id;
          }
          _isChildrenLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isChildrenLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (picked != null) {
        final file = File(picked.path);
        final size = await file.length();
        setState(() {
          _selectedFile = file;
          _fileType = 'image';
          _fileSizeBytes = size;
          if (_titleController.text.trim().isEmpty) {
            _titleController.text = 'Lesson Image ${DateTime.now().month}/${DateTime.now().day}';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final file = File(path);
        final size = await file.length();
        final isPdf = path.toLowerCase().endsWith('.pdf');

        setState(() {
          _selectedFile = file;
          _fileType = isPdf ? 'pdf' : 'image';
          _fileSizeBytes = size;
          if (_titleController.text.trim().isEmpty) {
            final fileNameWithoutExt = result.files.single.name.split('.').first;
            _titleController.text = fileNameWithoutExt;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick document: $e')),
        );
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _startUploadAndAnalysis() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a lesson image or PDF to upload.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final uploadService = ref.read(uploadServiceProvider);
      final uploadResult = await uploadService.uploadLessonFile(
        file: _selectedFile!,
        childId: _selectedChildId,
        title: _titleController.text.trim(),
      );

      if (mounted) {
        context.go('/parent/generation/${uploadResult.lessonId}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
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
        title: const Text('Turn Lesson Into Game'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Callout
                Text(
                  'Upload Educational Content',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Upload a textbook page, worksheet, or PDF to generate an interactive mission.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                // Upload Cards Row
                if (_selectedFile == null) ...[
                  Row(
                    children: [
                      // Camera / Photo Option
                      Expanded(
                        child: AppCard.elevated(
                          onTap: () => _pickImage(ImageSource.gallery),
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.photo_camera_outlined,
                                  size: 36,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Take / Pick Photo',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'JPG, PNG, Screenshot',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Document / PDF Option
                      Expanded(
                        child: AppCard.elevated(
                          onTap: _pickPdf,
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.picture_as_pdf_outlined,
                                  size: 36,
                                  color: Color(0xFFFF6B35),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Upload PDF',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Textbook or Worksheet',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Selected File Preview Card
                  AppCard.elevated(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _fileType == 'pdf' ? Icons.picture_as_pdf : Icons.image,
                            color: theme.colorScheme.primary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedFile!.path.split(Platform.pathSeparator).last,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_fileType?.toUpperCase()} • ${_formatFileSize(_fileSizeBytes)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedFile = null;
                              _fileType = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // Form Details Section
                AppInput(
                  controller: _titleController,
                  label: 'Lesson Title / Topic',
                  hint: 'e.g. Water Cycle in Nature, Fractions',
                  prefixIcon: const Icon(Icons.title_outlined),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter a title for the lesson';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Select Child Dropdown
                if (!_isChildrenLoading && _children.isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    initialValue: _selectedChildId,
                    decoration: InputDecoration(
                      labelText: 'Assign to Child',
                      prefixIcon: const Icon(Icons.face_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _children.map((child) {
                      return DropdownMenuItem(
                        value: child.id,
                        child: Text('${child.name} (Age ${child.age})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedChildId = val);
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Difficulty Selector
                Text(
                  'Difficulty Level',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final diff in ['adaptive', 'easy', 'medium', 'hard'])
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(
                              diff[0].toUpperCase() + diff.substring(1),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: _selectedDifficulty == diff ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            selected: _selectedDifficulty == diff,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedDifficulty = diff);
                            },
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Duration Selector
                Text(
                  'Estimated Duration',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final duration in [5, 10, 15, 20])
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text('$duration min'),
                            selected: _selectedDuration == duration,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedDuration = duration);
                            },
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 36),

                // Submit Button
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  AppButton.game(
                    label: '🚀 Create My Educational Game',
                    onPressed: _startUploadAndAnalysis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
