/// Base URL untuk Django REST API.
///
/// Chrome / Flutter Web menggunakan localhost.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);
