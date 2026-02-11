/// Appwrite configuration. Values can be set via --dart-define in run configuration
/// or via a runtime config layer (e.g. env file) in a later phase.
class AppwriteConfig {
  final String endpoint;
  final String projectId;
  final String databaseId;
  final String auctionsCollectionId;
  final String auctionProductsCollectionId;
  final String votesCollectionId;
  final String participationRequestsCollectionId;
  final String bidsCollectionId;
  final String winnerConfirmationCollectionId;
  final String productsCollectionId;
  final String categoriesCollectionId;
  final String variablesCollectionId;
  final String featuresCollectionId;
  final String userProfilesCollectionId;

  const AppwriteConfig({
    required this.endpoint,
    required this.projectId,
    required this.databaseId,
    required this.auctionsCollectionId,
    required this.auctionProductsCollectionId,
    required this.votesCollectionId,
    required this.participationRequestsCollectionId,
    required this.bidsCollectionId,
    required this.winnerConfirmationCollectionId,
    required this.productsCollectionId,
    required this.categoriesCollectionId,
    required this.variablesCollectionId,
    required this.featuresCollectionId,
    required this.userProfilesCollectionId,
  });

  /// Build from dart-define or default empty (app compiles; configure for real backend).
  factory AppwriteConfig.fromEnvironment() {
    return AppwriteConfig(
      endpoint: const String.fromEnvironment(
        'APPWRITE_ENDPOINT',
        defaultValue: '',
      ),
      projectId: const String.fromEnvironment(
        'APPWRITE_PROJECT_ID',
        defaultValue: '',
      ),
      databaseId: const String.fromEnvironment(
        'APPWRITE_DATABASE_ID',
        defaultValue: '',
      ),
      auctionsCollectionId: const String.fromEnvironment(
        'APPWRITE_AUCTIONS_COLLECTION_ID',
        defaultValue: '',
      ),
      auctionProductsCollectionId: const String.fromEnvironment(
        'APPWRITE_AUCTION_PRODUCTS_COLLECTION_ID',
        defaultValue: '',
      ),
      votesCollectionId: const String.fromEnvironment(
        'APPWRITE_VOTES_COLLECTION_ID',
        defaultValue: '',
      ),
      participationRequestsCollectionId: const String.fromEnvironment(
        'APPWRITE_PARTICIPATION_REQUESTS_COLLECTION_ID',
        defaultValue: '',
      ),
      bidsCollectionId: const String.fromEnvironment(
        'APPWRITE_BIDS_COLLECTION_ID',
        defaultValue: '',
      ),
      winnerConfirmationCollectionId: const String.fromEnvironment(
        'APPWRITE_WINNER_CONFIRMATION_COLLECTION_ID',
        defaultValue: '',
      ),
      productsCollectionId: const String.fromEnvironment(
        'APPWRITE_PRODUCTS_COLLECTION_ID',
        defaultValue: '',
      ),
      categoriesCollectionId: const String.fromEnvironment(
        'APPWRITE_CATEGORIES_COLLECTION_ID',
        defaultValue: '',
      ),
      variablesCollectionId: const String.fromEnvironment(
        'APPWRITE_VARIABLES_COLLECTION_ID',
        defaultValue: '',
      ),
      featuresCollectionId: const String.fromEnvironment(
        'APPWRITE_FEATURES_COLLECTION_ID',
        defaultValue: '',
      ),
      userProfilesCollectionId: const String.fromEnvironment(
        'APPWRITE_USER_PROFILES_COLLECTION_ID',
        defaultValue: '',
      ),
    );
  }

  bool get isConfigured =>
      endpoint.isNotEmpty && projectId.isNotEmpty && databaseId.isNotEmpty;
}
