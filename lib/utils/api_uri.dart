const _authority = 'staticsanches.github.io';
const _pathPrefix = '/ooblets_api/api/v1';

Uri apiUri(String path) => Uri.https(_authority, _pathPrefix + path);
