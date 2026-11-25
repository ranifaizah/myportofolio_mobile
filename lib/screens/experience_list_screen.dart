import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  State<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  late final ApiClient _apiClient;
  late Future<List<Experience>> _experiencesFuture;

  @override
  void initState() {
    super.initState();

    _apiClient = ApiClient();
    _experiencesFuture = _apiClient.getExperiences();
  }

  Future<void> _reload() async {
    final future = _apiClient.getExperiences();

    setState(() {
      _experiencesFuture = future;
    });

    await future;
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Experiences')),

      body: FutureBuilder<List<Experience>>(
        future: _experiencesFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gagal mengambil data:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final experiences = snapshot.data ?? <Experience>[];

          if (experiences.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('Belum ada Experience.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final experience = experiences[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.work)),
                    title: Text(experience.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(experience.category),
                        Text(
                          experience.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        Text('${experience.starCount}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExperienceDetailScreen(experience: experience),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Halaman detail Experience
class ExperienceDetailScreen extends StatelessWidget {
  final Experience experience;

  const ExperienceDetailScreen({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Experience')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              experience.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text('Kategori: ${experience.category}'),
            const SizedBox(height: 12),

            Text(experience.description),
            const SizedBox(height: 12),

            Text('Mulai: ${experience.startedAt}'),
            Text('Selesai: ${experience.endedAt ?? "Masih berlangsung"}'),

            if (experience.thumbnail != null &&
                experience.thumbnail!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Image.network(
                experience.thumbnail!,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Gambar tidak dapat dimuat'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
