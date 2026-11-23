import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  // Global key untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap input
  final TextEditingController _projectNameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _technologiesController = TextEditingController();

  final TextEditingController _projectLinkController = TextEditingController();

  // Kategori proyek
  String? _category = 'Web Development';

  final List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  // Membersihkan controller ketika halaman ditutup
  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _projectLinkController.dispose();
    super.dispose();
  }

  // Fungsi menyimpan data
  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Proyek Berhasil Ditambahkan!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Nama Proyek: ${_projectNameController.text.trim()}'),
                  const SizedBox(height: 8),
                  Text('Deskripsi: ${_descriptionController.text.trim()}'),
                  const SizedBox(height: 8),
                  Text('Kategori: $_category'),
                  const SizedBox(height: 8),
                  Text(
                    'Teknologi: ${_technologiesController.text.trim().isEmpty ? "-" : _technologiesController.text.trim()}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Link: ${_projectLinkController.text.trim().isEmpty ? "-" : _projectLinkController.text.trim()}',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Project Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),

      drawer: const LeftDrawer(),

      // Form dibuat scrollable agar nyaman pada layar kecil
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tambah Proyek Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Lengkapi informasi proyek yang ingin kamu tambahkan ke portfolio.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 24),

                // 1. Nama Proyek
                TextFormField(
                  controller: _projectNameController,
                  maxLength: 50,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Nama Proyek',
                    hintText: 'Masukkan nama proyek',
                    prefixIcon: const Icon(Icons.folder_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama proyek wajib diisi!';
                    }

                    if (value.trim().length > 50) {
                      return 'Nama proyek maksimal 50 karakter!';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // 2. Deskripsi
                TextFormField(
                  controller: _descriptionController,
                  maxLength: 500,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Proyek',
                    hintText: 'Jelaskan proyek yang kamu kerjakan',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi proyek wajib diisi!';
                    }

                    if (value.trim().length > 500) {
                      return 'Deskripsi maksimal 500 karakter!';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // 3. Kategori Proyek
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: 'Kategori Proyek',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Kategori proyek wajib dipilih!';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // 4. Teknologi
                TextFormField(
                  controller: _technologiesController,
                  maxLength: 150,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Teknologi yang Digunakan',
                    hintText: 'Contoh: Flutter, Python, Figma',
                    prefixIcon: const Icon(Icons.code),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.trim().length > 150) {
                      return 'Teknologi maksimal 150 karakter!';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // 5. Link Proyek
                TextFormField(
                  controller: _projectLinkController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: 'Link Proyek (Opsional)',
                    hintText: 'https://github.com/username/project',
                    prefixIcon: const Icon(Icons.link),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }

                    final uri = Uri.tryParse(value.trim());

                    if (uri == null ||
                        !uri.hasScheme ||
                        (uri.scheme != 'http' && uri.scheme != 'https') ||
                        uri.host.isEmpty) {
                      return 'Masukkan URL yang valid!';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _saveProject,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Simpan Proyek',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
