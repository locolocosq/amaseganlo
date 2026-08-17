/// Display names for the supported UI languages, in their own language
/// (not translated) - used by both the settings screen and onboarding.
String languageDisplayName(String code) {
  switch (code) {
    case 'de':
      return 'Deutsch';
    case 'en':
      return 'English';
    case 'sv':
      return 'Svenska';
    case 'nl':
      return 'Nederlands';
    case 'it':
      return 'Italiano';
    case 'es':
      return 'Español';
    default:
      return code;
  }
}
