import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _category = 'full-time';
  String _thumbnail = '';

  DateTime _startedAt = DateTime.now();
  DateTime? _endedAt;

  bool _isSubmitting = false;

  final List<Map<String, String>> _categories = [
    {'value': 'internship', 'label': 'Internship'},
    {'value': 'research', 'label': 'Research'},
    {'value': 'volunteer', 'label': 'Volunteer'},
    {'value': 'part-time', 'label': 'Part-Time'},
    {'value': 'full-time', 'label': 'Full-Time'},
    {'value': 'freelance', 'label': 'Freelance'},
  ];

  Future<void> _selectStartedAt() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _startedAt = date;
      });
    }
  }

  Future<void> _selectEndedAt() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? DateTime.now(),
      firstDate: _startedAt,
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _endedAt = date;
      });
    }
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final allowed = await ensureLoggedIn(context);

    if (!mounted || !allowed) return;

    final token = context.read<AuthState>().token;

    if (token == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final newExperience = Experience(
        title: _title.trim(),
        description: _description.trim(),
        category: _category,
        thumbnail: _thumbnail.trim().isEmpty ? null : _thumbnail.trim(),
        startedAt: _startedAt,
        endedAt: _endedAt,
      );

      await context.read<ApiClient>().createExperience(
        newExperience,
        token: token,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Berhasil!'),
            content: const Text('Experience berhasil ditambahkan ke Django.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401) {
        await context.read<AuthState>().logout();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi login berakhir. Silakan login kembali.'),
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menyimpan data (${e.statusCode}): ${e.message}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Experience Form'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  maxLength: 255,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _title = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title wajib diisi!';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _description = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description wajib diisi!';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['value'],
                      child: Text(category['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _category = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Thumbnail URL (Optional)',
                    hintText: 'https://example.com/image.jpg',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) => _thumbnail = value,
                  validator: (value) {
                    final url = value?.trim() ?? '';

                    if (url.isEmpty) return null;

                    final uri = Uri.tryParse(url);

                    if (uri == null ||
                        (uri.scheme != 'http' && uri.scheme != 'https') ||
                        uri.host.isEmpty) {
                      return 'Masukkan URL gambar yang valid!';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Started At',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                OutlinedButton.icon(
                  onPressed: _selectStartedAt,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    '${_startedAt.day}/${_startedAt.month}/${_startedAt.year}',
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Ended At (Optional)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _selectEndedAt,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _endedAt == null
                            ? 'Pilih tanggal selesai'
                            : '${_endedAt!.day}/${_endedAt!.month}/${_endedAt!.year}',
                      ),
                    ),

                    if (_endedAt != null)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _endedAt = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                  ],
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _saveProject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('SIMPAN EXPERIENCE'),
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
