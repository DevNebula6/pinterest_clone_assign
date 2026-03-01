// static data used in the onboarding screens
class OnboardingData {
  OnboardingData._();

  // countries list - put the common ones at the top
  static const List<String> countries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'Brazil',
    'Japan',
    'South Korea',
    'Mexico',
    'Indonesia',
    'Italy',
    'Spain',
    'Netherlands',
    'Turkey',
    'Saudi Arabia',
    'South Africa',
    'Argentina',
    'Colombia',
    'Egypt',
    'Nigeria',
    'Pakistan',
    'Philippines',
    'Poland',
    'Russia',
    'Sweden',
    'Switzerland',
    'Thailand',
    'United Arab Emirates',
    'Vietnam',
  ];

  // gender options
  static const List<String> genders = [
    'Prefer not to say',
    'Female',
    'Male',
    'Non-binary',
    'Custom',
  ];

  // all the interest categories - label, pexels search query and emjoi
  static const List<InterestCategory> interests = [
    InterestCategory('Small spaces', 'small+cozy+room', '🏠'),
    InterestCategory('Tattoos', 'tattoo+art', '🎨'),
    InterestCategory('Home renovation', 'home+renovation+interior', '🏡'),
    InterestCategory('Baking', 'baking+pastry', '🧁'),
    InterestCategory('Video game customisation', 'gaming+console', '🎮'),
    InterestCategory('Hair inspiration', 'hairstyle+fashion', '💇'),
    InterestCategory('Workouts', 'fitness+workout', '💪'),
    InterestCategory('Travel', 'travel+landscape', '✈️'),
    InterestCategory('Plants', 'indoor+plants+decor', '🌿'),
    InterestCategory('Back to school', 'school+supplies+colorful', '📚'),
    InterestCategory('Boho aesthetic', 'boho+interior+design', '🪶'),
    InterestCategory('Dad gifts', 'gift+ideas+dad', '🎁'),
    InterestCategory('Nail art', 'nail+art+design', '💅'),
    InterestCategory('Street style', 'street+fashion', '👗'),
    InterestCategory('Photography', 'photography+camera', '📷'),
    InterestCategory('Minimalism', 'minimalist+interior', '✨'),
    InterestCategory('Recipes', 'cooking+recipe+food', '🍳'),
    InterestCategory('DIY crafts', 'diy+crafts+handmade', '✂️'),
  ];

  // messages shown while the feed tuning animation plays
  static const List<String> loadingMessages = [
    'Great picks!',
    'Tuning your feed,\njust for you!',
    'Finding ideas\nyou\'ll love...',
    'Almost ready!',
  ];
}

// one interest category - has a label, image search query and emoji for the placeholder
class InterestCategory {
  const InterestCategory(this.label, this.query, this.emoji);

  final String label;

  final String query; // search term used to fetch a preview image from pexels

  final String emoji; // shown if the image hasnt loaded yet
}
