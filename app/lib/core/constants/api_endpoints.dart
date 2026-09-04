class ApiEndpoints {
  ApiEndpoints._();
  
  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  
  // Children
  static const String children = '/children';
  static String child(String id) => '/children/$id';
  
  // Generation (Games from Lessons)
  static const String upload = '/generate/upload';
  static const String analyze = '/generate/analyze';
  static const String generateGame = '/generate/game';
  
  // Games
  static const String games = '/games';
  static String game(String id) => '/games/$id';
  static String startGame(String id) => '/games/$id/start';
  
  // Sessions
  static const String sessions = '/sessions';
  static String sessionAnswer(String id) => '/sessions/$id/answer';
  static String sessionComplete(String id) => '/sessions/$id/complete';
  
  // Progress & Reporting
  static const String progress = '/progress';
  static const String weakConcepts = '/progress/weak-concepts';
  static const String practice = '/progress/practice';
  static const String report = '/progress/report';
}
