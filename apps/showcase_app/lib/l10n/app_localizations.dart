import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Supported locales
const List<Locale> supportedLocales = [
  Locale('en', 'US'), // English (US)
  Locale('ar', 'SA'), // Arabic (Saudi Arabia)
  Locale('de', 'DE'), // German (Germany)
  Locale('es', 'ES'), // Spanish (Spain)
  Locale('fr', 'FR'), // French (France)
  Locale('nl', 'NL'), // Dutch (Netherlands)
  Locale('pt', 'BR'), // Portuguese (Brazil)
];

// Localization delegates. No GlobalCupertinoLocalizations — the kit
// ships zero Cupertino visible widgets, so its localized strings are
// dead weight.
const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
  AppLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];

/// App localizations
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Common strings
  String get appName => _localizedValues[locale.languageCode]!['appName']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get darkMode => _localizedValues[locale.languageCode]!['darkMode']!;
  String get lightMode => _localizedValues[locale.languageCode]!['lightMode']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get warning => _localizedValues[locale.languageCode]!['warning']!;
  String get info => _localizedValues[locale.languageCode]!['info']!;

  // Component showcase
  String get components => _localizedValues[locale.languageCode]!['components']!;
  String get showcase => _localizedValues[locale.languageCode]!['showcase']!;
  String get componentCatalog => _localizedValues[locale.languageCode]!['componentCatalog']!;
  String get demoApps => _localizedValues[locale.languageCode]!['demoApps']!;

  // Component names
  String get buttons => _localizedValues[locale.languageCode]!['buttons']!;
  String get inputs => _localizedValues[locale.languageCode]!['inputs']!;
  String get dialogs => _localizedValues[locale.languageCode]!['dialogs']!;
  String get sheets => _localizedValues[locale.languageCode]!['sheets']!;
  String get indicators => _localizedValues[locale.languageCode]!['indicators']!;
  String get toggles => _localizedValues[locale.languageCode]!['toggles']!;
  String get progress => _localizedValues[locale.languageCode]!['progress']!;
  String get controls => _localizedValues[locale.languageCode]!['controls']!;
  String get sliders => _localizedValues[locale.languageCode]!['sliders']!;
  String get lists => _localizedValues[locale.languageCode]!['lists']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get pickers => _localizedValues[locale.languageCode]!['pickers']!;
  String get icons => _localizedValues[locale.languageCode]!['icons']!;
  String get menus => _localizedValues[locale.languageCode]!['menus']!;
  String get popovers => _localizedValues[locale.languageCode]!['popovers']!;
  String get emptyStates => _localizedValues[locale.languageCode]!['emptyStates']!;
  String get steppers => _localizedValues[locale.languageCode]!['steppers']!;

  // Demo app names
  String get ecommerce => _localizedValues[locale.languageCode]!['ecommerce']!;
  String get socialMedia => _localizedValues[locale.languageCode]!['socialMedia']!;
  String get news => _localizedValues[locale.languageCode]!['news']!;
  String get travel => _localizedValues[locale.languageCode]!['travel']!;
  String get wallet => _localizedValues[locale.languageCode]!['wallet']!;

  // E-commerce
  String get products => _localizedValues[locale.languageCode]!['products']!;
  String get cart => _localizedValues[locale.languageCode]!['cart']!;
  String get checkout => _localizedValues[locale.languageCode]!['checkout']!;
  String get addToCart => _localizedValues[locale.languageCode]!['addToCart']!;
  String get buyNow => _localizedValues[locale.languageCode]!['buyNow']!;
  String get price => _localizedValues[locale.languageCode]!['price']!;
  String get total => _localizedValues[locale.languageCode]!['total']!;
  String get subtotal => _localizedValues[locale.languageCode]!['subtotal']!;
  String get shipping => _localizedValues[locale.languageCode]!['shipping']!;
  String get tax => _localizedValues[locale.languageCode]!['tax']!;
  String get payment => _localizedValues[locale.languageCode]!['payment']!;
  String get delivery => _localizedValues[locale.languageCode]!['delivery']!;

  // Social media
  String get feed => _localizedValues[locale.languageCode]!['feed']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get messages => _localizedValues[locale.languageCode]!['messages']!;
  String get socialNotifications => _localizedValues[locale.languageCode]!['socialNotifications']!;
  String get explore => _localizedValues[locale.languageCode]!['explore']!;
  String get like => _localizedValues[locale.languageCode]!['like']!;
  String get comment => _localizedValues[locale.languageCode]!['comment']!;
  String get share => _localizedValues[locale.languageCode]!['share']!;
  String get follow => _localizedValues[locale.languageCode]!['follow']!;
  String get unfollow => _localizedValues[locale.languageCode]!['unfollow']!;

  // News
  String get headlines => _localizedValues[locale.languageCode]!['headlines']!;
  String get articles => _localizedValues[locale.languageCode]!['articles']!;
  String get categories => _localizedValues[locale.languageCode]!['categories']!;
  String get bookmarks => _localizedValues[locale.languageCode]!['bookmarks']!;
  String get readMore => _localizedValues[locale.languageCode]!['readMore']!;
  String get trending => _localizedValues[locale.languageCode]!['trending']!;
  String get latest => _localizedValues[locale.languageCode]!['latest']!;

  // Travel
  String get destinations => _localizedValues[locale.languageCode]!['destinations']!;
  String get flights => _localizedValues[locale.languageCode]!['flights']!;
  String get hotels => _localizedValues[locale.languageCode]!['hotels']!;
  String get packages => _localizedValues[locale.languageCode]!['packages']!;
  String get book => _localizedValues[locale.languageCode]!['book']!;
  String get bookNow => _localizedValues[locale.languageCode]!['bookNow']!;
  String get checkIn => _localizedValues[locale.languageCode]!['checkIn']!;
  String get checkOut => _localizedValues[locale.languageCode]!['checkOut']!;
  String get guests => _localizedValues[locale.languageCode]!['guests']!;

  // Wallet
  String get balance => _localizedValues[locale.languageCode]!['balance']!;
  String get transactions => _localizedValues[locale.languageCode]!['transactions']!;
  String get cards => _localizedValues[locale.languageCode]!['cards']!;
  String get bills => _localizedValues[locale.languageCode]!['bills']!;
  String get savings => _localizedValues[locale.languageCode]!['savings']!;
  String get send => _localizedValues[locale.languageCode]!['send']!;
  String get receive => _localizedValues[locale.languageCode]!['receive']!;
  String get pay => _localizedValues[locale.languageCode]!['pay']!;
  String get topUp => _localizedValues[locale.languageCode]!['topUp']!;
  String get income => _localizedValues[locale.languageCode]!['income']!;
  String get expense => _localizedValues[locale.languageCode]!['expense']!;

  // Date and time
  String get today => _localizedValues[locale.languageCode]!['today']!;
  String get yesterday => _localizedValues[locale.languageCode]!['yesterday']!;
  String get tomorrow => _localizedValues[locale.languageCode]!['tomorrow']!;
  String get thisWeek => _localizedValues[locale.languageCode]!['thisWeek']!;
  String get thisMonth => _localizedValues[locale.languageCode]!['thisMonth']!;
  String get thisYear => _localizedValues[locale.languageCode]!['thisYear']!;
  
  // Settings specific
  String get appearance => _localizedValues[locale.languageCode]!['appearance']!;
  String get animations => _localizedValues[locale.languageCode]!['animations']!;
  String get blurEffects => _localizedValues[locale.languageCode]!['blurEffects']!;
  String get blurEffectsDescription => _localizedValues[locale.languageCode]!['blurEffectsDescription']!;
  String get hapticFeedback => _localizedValues[locale.languageCode]!['hapticFeedback']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get madeWithLove => _localizedValues[locale.languageCode]!['madeWithLove']!;

  // Localized values map
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': _enUS,
    'ar': _arSA,
    'de': _deDE,
    'es': _esES,
    'fr': _frFR,
    'nl': _nlNL,
    'pt': _ptBR,
  };
}

// Localization delegate
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'de', 'es', 'fr', 'nl', 'pt'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// English (US)
const Map<String, String> _enUS = {
  // Common
  'appName': 'Liquid UI Kit',
  'welcome': 'Welcome',
  'home': 'Home',
  'settings': 'Settings',
  'darkMode': 'Dark Mode',
  'lightMode': 'Light Mode',
  'language': 'Language',
  'cancel': 'Cancel',
  'ok': 'OK',
  'save': 'Save',
  'delete': 'Delete',
  'edit': 'Edit',
  'search': 'Search',
  'loading': 'Loading',
  'error': 'Error',
  'success': 'Success',
  'warning': 'Warning',
  'info': 'Info',
  
  // Component showcase
  'components': 'Components',
  'showcase': 'Showcase',
  'componentCatalog': 'Component Catalog',
  'demoApps': 'Demo Apps',
  
  // Component names
  'buttons': 'Buttons',
  'inputs': 'Inputs',
  'dialogs': 'Dialogs',
  'sheets': 'Sheets',
  'indicators': 'Indicators',
  'toggles': 'Toggles',
  'progress': 'Progress',
  'controls': 'Controls',
  'sliders': 'Sliders',
  'lists': 'Lists',
  'notifications': 'Notifications',
  'pickers': 'Pickers',
  'icons': 'Icons',
  'menus': 'Menus',
  'popovers': 'Popovers',
  'emptyStates': 'Empty States',
  'steppers': 'Steppers',
  
  // Demo app names
  'ecommerce': 'E-commerce',
  'socialMedia': 'Social Media',
  'news': 'News',
  'travel': 'Travel',
  'wallet': 'Wallet',
  
  // E-commerce
  'products': 'Products',
  'cart': 'Cart',
  'checkout': 'Checkout',
  'addToCart': 'Add to Cart',
  'buyNow': 'Buy Now',
  'price': 'Price',
  'total': 'Total',
  'subtotal': 'Subtotal',
  'shipping': 'Shipping',
  'tax': 'Tax',
  'payment': 'Payment',
  'delivery': 'Delivery',
  
  // Social media
  'feed': 'Feed',
  'profile': 'Profile',
  'messages': 'Messages',
  'socialNotifications': 'Notifications',
  'explore': 'Explore',
  'like': 'Like',
  'comment': 'Comment',
  'share': 'Share',
  'follow': 'Follow',
  'unfollow': 'Unfollow',
  
  // News
  'headlines': 'Headlines',
  'articles': 'Articles',
  'categories': 'Categories',
  'bookmarks': 'Bookmarks',
  'readMore': 'Read More',
  'trending': 'Trending',
  'latest': 'Latest',
  
  // Travel
  'destinations': 'Destinations',
  'flights': 'Flights',
  'hotels': 'Hotels',
  'packages': 'Packages',
  'book': 'Book',
  'bookNow': 'Book Now',
  'checkIn': 'Check In',
  'checkOut': 'Check Out',
  'guests': 'Guests',
  
  // Wallet
  'balance': 'Balance',
  'transactions': 'Transactions',
  'cards': 'Cards',
  'bills': 'Bills',
  'savings': 'Savings',
  'send': 'Send',
  'receive': 'Receive',
  'pay': 'Pay',
  'topUp': 'Top Up',
  'income': 'Income',
  'expense': 'Expense',
  
  // Date and time
  'today': 'Today',
  'yesterday': 'Yesterday',
  'tomorrow': 'Tomorrow',
  'thisWeek': 'This Week',
  'thisMonth': 'This Month',
  'thisYear': 'This Year',
  
  // Settings specific
  'appearance': 'Appearance',
  'animations': 'Animations',
  'blurEffects': 'Blur Effects',
  'blurEffectsDescription': 'May impact performance',
  'hapticFeedback': 'Haptic Feedback',
  'about': 'About',
  'madeWithLove': 'Made with Love',
};

// Arabic (Saudi Arabia)
const Map<String, String> _arSA = {
  // Common
  'appName': 'مجموعة واجهة سائلة',
  'welcome': 'مرحباً',
  'home': 'الرئيسية',
  'settings': 'الإعدادات',
  'darkMode': 'الوضع الداكن',
  'lightMode': 'الوضع الفاتح',
  'language': 'اللغة',
  'cancel': 'إلغاء',
  'ok': 'موافق',
  'save': 'حفظ',
  'delete': 'حذف',
  'edit': 'تعديل',
  'search': 'بحث',
  'loading': 'جاري التحميل',
  'error': 'خطأ',
  'success': 'نجاح',
  'warning': 'تحذير',
  'info': 'معلومة',
  
  // Component showcase
  'components': 'المكونات',
  'showcase': 'عرض',
  'componentCatalog': 'دليل المكونات',
  'demoApps': 'تطبيقات تجريبية',
  
  // Component names
  'buttons': 'أزرار',
  'inputs': 'إدخالات',
  'dialogs': 'حوارات',
  'sheets': 'أوراق',
  'indicators': 'مؤشرات',
  'toggles': 'مفاتيح',
  'progress': 'تقدم',
  'controls': 'عناصر تحكم',
  'sliders': 'شرائط تمرير',
  'lists': 'قوائم',
  'notifications': 'إشعارات',
  'pickers': 'منتقيات',
  'icons': 'أيقونات',
  'menus': 'قوائم',
  'popovers': 'نوافذ منبثقة',
  'emptyStates': 'حالات فارغة',
  'steppers': 'خطوات',
  
  // Demo app names
  'ecommerce': 'التجارة الإلكترونية',
  'socialMedia': 'وسائل التواصل',
  'news': 'الأخبار',
  'travel': 'السفر',
  'wallet': 'المحفظة',
  
  // E-commerce
  'products': 'المنتجات',
  'cart': 'السلة',
  'checkout': 'الدفع',
  'addToCart': 'أضف إلى السلة',
  'buyNow': 'اشتر الآن',
  'price': 'السعر',
  'total': 'المجموع',
  'subtotal': 'المجموع الفرعي',
  'shipping': 'الشحن',
  'tax': 'الضريبة',
  'payment': 'الدفع',
  'delivery': 'التوصيل',
  
  // Social media
  'feed': 'التغذية',
  'profile': 'الملف الشخصي',
  'messages': 'الرسائل',
  'socialNotifications': 'إشعارات',
  'explore': 'استكشف',
  'like': 'إعجاب',
  'comment': 'تعليق',
  'share': 'مشاركة',
  'follow': 'متابعة',
  'unfollow': 'إلغاء المتابعة',
  
  // News
  'headlines': 'العناوين الرئيسية',
  'articles': 'المقالات',
  'categories': 'الفئات',
  'bookmarks': 'المفضلة',
  'readMore': 'اقرأ المزيد',
  'trending': 'الأكثر رواجاً',
  'latest': 'الأحدث',
  
  // Travel
  'destinations': 'الوجهات',
  'flights': 'الرحلات',
  'hotels': 'الفنادق',
  'packages': 'الباقات',
  'book': 'احجز',
  'bookNow': 'احجز الآن',
  'checkIn': 'تسجيل الدخول',
  'checkOut': 'تسجيل الخروج',
  'guests': 'الضيوف',
  
  // Wallet
  'balance': 'الرصيد',
  'transactions': 'المعاملات',
  'cards': 'البطاقات',
  'bills': 'الفواتير',
  'savings': 'المدخرات',
  'send': 'إرسال',
  'receive': 'استقبال',
  'pay': 'دفع',
  'topUp': 'شحن',
  'income': 'الدخل',
  'expense': 'المصروفات',
  
  // Date and time
  'today': 'اليوم',
  'yesterday': 'أمس',
  'tomorrow': 'غداً',
  'thisWeek': 'هذا الأسبوع',
  'thisMonth': 'هذا الشهر',
  'thisYear': 'هذه السنة',
  
  // Settings specific
  'appearance': 'المظهر',
  'animations': 'الحركات',
  'blurEffects': 'تأثيرات الضبابية',
  'blurEffectsDescription': 'قد يؤثر على الأداء',
  'hapticFeedback': 'الاستجابة اللمسية',
  'about': 'حول',
  'madeWithLove': 'صنع بحب',
};

// German (Germany)
const Map<String, String> _deDE = {
  // Common
  'appName': 'Liquid UI Kit',
  'welcome': 'Willkommen',
  'home': 'Startseite',
  'settings': 'Einstellungen',
  'darkMode': 'Dunkler Modus',
  'lightMode': 'Heller Modus',
  'language': 'Sprache',
  'cancel': 'Abbrechen',
  'ok': 'OK',
  'save': 'Speichern',
  'delete': 'Löschen',
  'edit': 'Bearbeiten',
  'search': 'Suchen',
  'loading': 'Laden',
  'error': 'Fehler',
  'success': 'Erfolg',
  'warning': 'Warnung',
  'info': 'Info',
  
  // Component showcase
  'components': 'Komponenten',
  'showcase': 'Präsentation',
  'componentCatalog': 'Komponentenkatalog',
  'demoApps': 'Demo-Apps',
  
  // Component names
  'buttons': 'Schaltflächen',
  'inputs': 'Eingaben',
  'dialogs': 'Dialoge',
  'sheets': 'Blätter',
  'indicators': 'Indikatoren',
  'toggles': 'Schalter',
  'progress': 'Fortschritt',
  'controls': 'Steuerelemente',
  'sliders': 'Schieberegler',
  'lists': 'Listen',
  'notifications': 'Benachrichtigungen',
  'pickers': 'Auswähler',
  'icons': 'Symbole',
  'menus': 'Menüs',
  'popovers': 'Popover',
  'emptyStates': 'Leere Zustände',
  'steppers': 'Schritte',
  
  // Demo app names
  'ecommerce': 'E-Commerce',
  'socialMedia': 'Soziale Medien',
  'news': 'Nachrichten',
  'travel': 'Reisen',
  'wallet': 'Brieftasche',
  
  // E-commerce
  'products': 'Produkte',
  'cart': 'Warenkorb',
  'checkout': 'Kasse',
  'addToCart': 'In den Warenkorb',
  'buyNow': 'Jetzt kaufen',
  'price': 'Preis',
  'total': 'Gesamt',
  'subtotal': 'Zwischensumme',
  'shipping': 'Versand',
  'tax': 'Steuer',
  'payment': 'Zahlung',
  'delivery': 'Lieferung',
  
  // Social media
  'feed': 'Feed',
  'profile': 'Profil',
  'messages': 'Nachrichten',
  'socialNotifications': 'Benachrichtigungen',
  'explore': 'Entdecken',
  'like': 'Gefällt mir',
  'comment': 'Kommentar',
  'share': 'Teilen',
  'follow': 'Folgen',
  'unfollow': 'Entfolgen',
  
  // News
  'headlines': 'Schlagzeilen',
  'articles': 'Artikel',
  'categories': 'Kategorien',
  'bookmarks': 'Lesezeichen',
  'readMore': 'Mehr lesen',
  'trending': 'Trends',
  'latest': 'Neueste',
  
  // Travel
  'destinations': 'Reiseziele',
  'flights': 'Flüge',
  'hotels': 'Hotels',
  'packages': 'Pakete',
  'book': 'Buchen',
  'bookNow': 'Jetzt buchen',
  'checkIn': 'Check-in',
  'checkOut': 'Check-out',
  'guests': 'Gäste',
  
  // Wallet
  'balance': 'Guthaben',
  'transactions': 'Transaktionen',
  'cards': 'Karten',
  'bills': 'Rechnungen',
  'savings': 'Ersparnisse',
  'send': 'Senden',
  'receive': 'Empfangen',
  'pay': 'Bezahlen',
  'topUp': 'Aufladen',
  'income': 'Einkommen',
  'expense': 'Ausgaben',
  
  // Date and time
  'today': 'Heute',
  'yesterday': 'Gestern',
  'tomorrow': 'Morgen',
  'thisWeek': 'Diese Woche',
  'thisMonth': 'Diesen Monat',
  'thisYear': 'Dieses Jahr',
  
  // Settings specific
  'appearance': 'Erscheinungsbild',
  'animations': 'Animationen',
  'blurEffects': 'Unschärfeeffekte',
  'blurEffectsDescription': 'Kann die Leistung beeinträchtigen',
  'hapticFeedback': 'Haptisches Feedback',
  'about': 'Über',
  'madeWithLove': 'Mit Liebe gemacht',
};

// Spanish (Spain)
const Map<String, String> _esES = {
  // Common
  'appName': 'Liquid UI Kit',
  'welcome': 'Bienvenido',
  'home': 'Inicio',
  'settings': 'Ajustes',
  'darkMode': 'Modo Oscuro',
  'lightMode': 'Modo Claro',
  'language': 'Idioma',
  'cancel': 'Cancelar',
  'ok': 'OK',
  'save': 'Guardar',
  'delete': 'Eliminar',
  'edit': 'Editar',
  'search': 'Buscar',
  'loading': 'Cargando',
  'error': 'Error',
  'success': 'Éxito',
  'warning': 'Advertencia',
  'info': 'Información',
  
  // Component showcase
  'components': 'Componentes',
  'showcase': 'Mostrar',
  'componentCatalog': 'Catálogo de Componentes',
  'demoApps': 'Apps de Demostración',
  
  // Component names
  'buttons': 'Botones',
  'inputs': 'Entradas',
  'dialogs': 'Diálogos',
  'sheets': 'Hojas',
  'indicators': 'Indicadores',
  'toggles': 'Interruptores',
  'progress': 'Progreso',
  'controls': 'Controles',
  'sliders': 'Deslizadores',
  'lists': 'Listas',
  'notifications': 'Notificaciones',
  'pickers': 'Selectores',
  'icons': 'Iconos',
  'menus': 'Menús',
  'popovers': 'Ventanas emergentes',
  'emptyStates': 'Estados vacíos',
  'steppers': 'Pasos',
  
  // Demo app names
  'ecommerce': 'Comercio electrónico',
  'socialMedia': 'Redes sociales',
  'news': 'Noticias',
  'travel': 'Viajes',
  'wallet': 'Cartera',
  
  // E-commerce
  'products': 'Productos',
  'cart': 'Carrito',
  'checkout': 'Pagar',
  'addToCart': 'Añadir al carrito',
  'buyNow': 'Comprar ahora',
  'price': 'Precio',
  'total': 'Total',
  'subtotal': 'Subtotal',
  'shipping': 'Envío',
  'tax': 'Impuesto',
  'payment': 'Pago',
  'delivery': 'Entrega',
  
  // Social media
  'feed': 'Feed',
  'profile': 'Perfil',
  'messages': 'Mensajes',
  'socialNotifications': 'Notificaciones',
  'explore': 'Explorar',
  'like': 'Me gusta',
  'comment': 'Comentar',
  'share': 'Compartir',
  'follow': 'Seguir',
  'unfollow': 'Dejar de seguir',
  
  // News
  'headlines': 'Titulares',
  'articles': 'Artículos',
  'categories': 'Categorías',
  'bookmarks': 'Marcadores',
  'readMore': 'Leer más',
  'trending': 'Tendencias',
  'latest': 'Últimas',
  
  // Travel
  'destinations': 'Destinos',
  'flights': 'Vuelos',
  'hotels': 'Hoteles',
  'packages': 'Paquetes',
  'book': 'Reservar',
  'bookNow': 'Reservar ahora',
  'checkIn': 'Entrada',
  'checkOut': 'Salida',
  'guests': 'Huéspedes',
  
  // Wallet
  'balance': 'Saldo',
  'transactions': 'Transacciones',
  'cards': 'Tarjetas',
  'bills': 'Facturas',
  'savings': 'Ahorros',
  'send': 'Enviar',
  'receive': 'Recibir',
  'pay': 'Pagar',
  'topUp': 'Recargar',
  'income': 'Ingresos',
  'expense': 'Gastos',
  
  // Date and time
  'today': 'Hoy',
  'yesterday': 'Ayer',
  'tomorrow': 'Mañana',
  'thisWeek': 'Esta semana',
  'thisMonth': 'Este mes',
  'thisYear': 'Este año',
  
  // Settings specific
  'appearance': 'Apariencia',
  'animations': 'Animaciones',
  'blurEffects': 'Efectos de desenfoque',
  'blurEffectsDescription': 'Puede afectar el rendimiento',
  'hapticFeedback': 'Respuesta háptica',
  'about': 'Acerca de',
  'madeWithLove': 'Hecho con amor',
};

// French (France)
const Map<String, String> _frFR = {
  // Common
  'appName': 'Liquid UI Kit',
  'welcome': 'Bienvenue',
  'home': 'Accueil',
  'settings': 'Paramètres',
  'darkMode': 'Mode Sombre',
  'lightMode': 'Mode Clair',
  'language': 'Langue',
  'cancel': 'Annuler',
  'ok': 'OK',
  'save': 'Enregistrer',
  'delete': 'Supprimer',
  'edit': 'Modifier',
  'search': 'Rechercher',
  'loading': 'Chargement',
  'error': 'Erreur',
  'success': 'Succès',
  'warning': 'Avertissement',
  'info': 'Info',
  
  // Component showcase
  'components': 'Composants',
  'showcase': 'Vitrine',
  'componentCatalog': 'Catalogue des composants',
  'demoApps': 'Applications de démonstration',
  
  // Component names
  'buttons': 'Boutons',
  'inputs': 'Entrées',
  'dialogs': 'Dialogues',
  'sheets': 'Feuilles',
  'indicators': 'Indicateurs',
  'toggles': 'Interrupteurs',
  'progress': 'Progrès',
  'controls': 'Contrôles',
  'sliders': 'Curseurs',
  'lists': 'Listes',
  'notifications': 'Notifications',
  'pickers': 'Sélecteurs',
  'icons': 'Icônes',
  'menus': 'Menus',
  'popovers': 'Popovers',
  'emptyStates': 'États vides',
  'steppers': 'Étapes',
  
  // Demo app names
  'ecommerce': 'E-commerce',
  'socialMedia': 'Médias sociaux',
  'news': 'Actualités',
  'travel': 'Voyage',
  'wallet': 'Portefeuille',
  
  // E-commerce
  'products': 'Produits',
  'cart': 'Panier',
  'checkout': 'Payer',
  'addToCart': 'Ajouter au panier',
  'buyNow': 'Acheter maintenant',
  'price': 'Prix',
  'total': 'Total',
  'subtotal': 'Sous-total',
  'shipping': 'Livraison',
  'tax': 'Taxe',
  'payment': 'Paiement',
  'delivery': 'Livraison',
  
  // Social media
  'feed': 'Fil',
  'profile': 'Profil',
  'messages': 'Messages',
  'socialNotifications': 'Notifications',
  'explore': 'Explorer',
  'like': 'J\'aime',
  'comment': 'Commenter',
  'share': 'Partager',
  'follow': 'Suivre',
  'unfollow': 'Ne plus suivre',
  
  // News
  'headlines': 'Titres',
  'articles': 'Articles',
  'categories': 'Catégories',
  'bookmarks': 'Marque-pages',
  'readMore': 'Lire plus',
  'trending': 'Tendances',
  'latest': 'Dernières',
  
  // Travel
  'destinations': 'Destinations',
  'flights': 'Vols',
  'hotels': 'Hôtels',
  'packages': 'Forfaits',
  'book': 'Réserver',
  'bookNow': 'Réserver maintenant',
  'checkIn': 'Arrivée',
  'checkOut': 'Départ',
  'guests': 'Invités',
  
  // Wallet
  'balance': 'Solde',
  'transactions': 'Transactions',
  'cards': 'Cartes',
  'bills': 'Factures',
  'savings': 'Épargne',
  'send': 'Envoyer',
  'receive': 'Recevoir',
  'pay': 'Payer',
  'topUp': 'Recharger',
  'income': 'Revenus',
  'expense': 'Dépenses',
  
  // Date and time
  'today': 'Aujourd\'hui',
  'yesterday': 'Hier',
  'tomorrow': 'Demain',
  'thisWeek': 'Cette semaine',
  'thisMonth': 'Ce mois',
  'thisYear': 'Cette année',
  
  // Settings specific
  'appearance': 'Apparence',
  'animations': 'Animations',
  'blurEffects': 'Effets de flou',
  'blurEffectsDescription': 'Peut affecter les performances',
  'hapticFeedback': 'Retour haptique',
  'about': 'À propos',
  'madeWithLove': 'Fait avec amour',
};

// Dutch (Netherlands)
const Map<String, String> _nlNL = {
  // Common
  'appName': 'Liquid UI Kit',
  'welcome': 'Welkom',
  'home': 'Home',
  'settings': 'Instellingen',
  'darkMode': 'Donkere Modus',
  'lightMode': 'Lichte Modus',
  'language': 'Taal',
  'cancel': 'Annuleren',
  'ok': 'OK',
  'save': 'Opslaan',
  'delete': 'Verwijderen',
  'edit': 'Bewerken',
  'search': 'Zoeken',
  'loading': 'Laden',
  'error': 'Fout',
  'success': 'Succes',
  'warning': 'Waarschuwing',
  'info': 'Info',
  
  // Component showcase
  'components': 'Componenten',
  'showcase': 'Showcase',
  'componentCatalog': 'Componentencatalogus',
  'demoApps': 'Demo Apps',
  
  // Component names
  'buttons': 'Knoppen',
  'inputs': 'Invoer',
  'dialogs': 'Dialogen',
  'sheets': 'Bladen',
  'indicators': 'Indicatoren',
  'toggles': 'Schakelaars',
  'progress': 'Voortgang',
  'controls': 'Besturingselementen',
  'sliders': 'Schuifregelaars',
  'lists': 'Lijsten',
  'notifications': 'Meldingen',
  'pickers': 'Kiezers',
  'icons': 'Iconen',
  'menus': 'Menu\'s',
  'popovers': 'Popovers',
  'emptyStates': 'Lege staten',
  'steppers': 'Stappers',
  
  // Demo app names
  'ecommerce': 'E-commerce',
  'socialMedia': 'Sociale Media',
  'news': 'Nieuws',
  'travel': 'Reizen',
  'wallet': 'Portemonnee',
  
  // E-commerce
  'products': 'Producten',
  'cart': 'Winkelwagen',
  'checkout': 'Afrekenen',
  'addToCart': 'Toevoegen aan winkelwagen',
  'buyNow': 'Nu kopen',
  'price': 'Prijs',
  'total': 'Totaal',
  'subtotal': 'Subtotaal',
  'shipping': 'Verzending',
  'tax': 'Belasting',
  'payment': 'Betaling',
  'delivery': 'Levering',
  
  // Social media
  'feed': 'Feed',
  'profile': 'Profiel',
  'messages': 'Berichten',
  'socialNotifications': 'Meldingen',
  'explore': 'Verkennen',
  'like': 'Vind ik leuk',
  'comment': 'Reageren',
  'share': 'Delen',
  'follow': 'Volgen',
  'unfollow': 'Ontvolgen',
  
  // News
  'headlines': 'Koppen',
  'articles': 'Artikelen',
  'categories': 'Categorieën',
  'bookmarks': 'Bladwijzers',
  'readMore': 'Lees meer',
  'trending': 'Trending',
  'latest': 'Laatste',
  
  // Travel
  'destinations': 'Bestemmingen',
  'flights': 'Vluchten',
  'hotels': 'Hotels',
  'packages': 'Pakketten',
  'book': 'Boeken',
  'bookNow': 'Nu boeken',
  'checkIn': 'Inchecken',
  'checkOut': 'Uitchecken',
  'guests': 'Gasten',
  
  // Wallet
  'balance': 'Saldo',
  'transactions': 'Transacties',
  'cards': 'Kaarten',
  'bills': 'Rekeningen',
  'savings': 'Spaargeld',
  'send': 'Verzenden',
  'receive': 'Ontvangen',
  'pay': 'Betalen',
  'topUp': 'Opwaarderen',
  'income': 'Inkomen',
  'expense': 'Uitgaven',
  
  // Date and time
  'today': 'Vandaag',
  'yesterday': 'Gisteren',
  'tomorrow': 'Morgen',
  'thisWeek': 'Deze week',
  'thisMonth': 'Deze maand',
  'thisYear': 'Dit jaar',
  
  // Settings specific
  'appearance': 'Uiterlijk',
  'animations': 'Animaties',
  'blurEffects': 'Vervagingseffecten',
  'blurEffectsDescription': 'Kan de prestaties beïnvloeden',
  'hapticFeedback': 'Haptische feedback',
  'about': 'Over',
  'madeWithLove': 'Met liefde gemaakt',
};

// Portuguese (Brazil)
const Map<String, String> _ptBR = {
  // Common
  'appName': 'Liquid UI Kit',
  'welcome': 'Bem-vindo',
  'home': 'Início',
  'settings': 'Configurações',
  'darkMode': 'Modo Escuro',
  'lightMode': 'Modo Claro',
  'language': 'Idioma',
  'cancel': 'Cancelar',
  'ok': 'OK',
  'save': 'Salvar',
  'delete': 'Excluir',
  'edit': 'Editar',
  'search': 'Pesquisar',
  'loading': 'Carregando',
  'error': 'Erro',
  'success': 'Sucesso',
  'warning': 'Aviso',
  'info': 'Informação',
  
  // Component showcase
  'components': 'Componentes',
  'showcase': 'Mostruário',
  'componentCatalog': 'Catálogo de Componentes',
  'demoApps': 'Apps de Demonstração',
  
  // Component names
  'buttons': 'Botões',
  'inputs': 'Entradas',
  'dialogs': 'Diálogos',
  'sheets': 'Folhas',
  'indicators': 'Indicadores',
  'toggles': 'Interruptores',
  'progress': 'Progresso',
  'controls': 'Controles',
  'sliders': 'Deslizantes',
  'lists': 'Listas',
  'notifications': 'Notificações',
  'pickers': 'Seletores',
  'icons': 'Ícones',
  'menus': 'Menus',
  'popovers': 'Popovers',
  'emptyStates': 'Estados vazios',
  'steppers': 'Passos',
  
  // Demo app names
  'ecommerce': 'E-commerce',
  'socialMedia': 'Mídia Social',
  'news': 'Notícias',
  'travel': 'Viagem',
  'wallet': 'Carteira',
  
  // E-commerce
  'products': 'Produtos',
  'cart': 'Carrinho',
  'checkout': 'Finalizar',
  'addToCart': 'Adicionar ao carrinho',
  'buyNow': 'Comprar agora',
  'price': 'Preço',
  'total': 'Total',
  'subtotal': 'Subtotal',
  'shipping': 'Frete',
  'tax': 'Imposto',
  'payment': 'Pagamento',
  'delivery': 'Entrega',
  
  // Social media
  'feed': 'Feed',
  'profile': 'Perfil',
  'messages': 'Mensagens',
  'socialNotifications': 'Notificações',
  'explore': 'Explorar',
  'like': 'Curtir',
  'comment': 'Comentar',
  'share': 'Compartilhar',
  'follow': 'Seguir',
  'unfollow': 'Deixar de seguir',
  
  // News
  'headlines': 'Manchetes',
  'articles': 'Artigos',
  'categories': 'Categorias',
  'bookmarks': 'Favoritos',
  'readMore': 'Leia mais',
  'trending': 'Tendências',
  'latest': 'Últimas',
  
  // Travel
  'destinations': 'Destinos',
  'flights': 'Voos',
  'hotels': 'Hotéis',
  'packages': 'Pacotes',
  'book': 'Reservar',
  'bookNow': 'Reserve agora',
  'checkIn': 'Check-in',
  'checkOut': 'Check-out',
  'guests': 'Hóspedes',
  
  // Wallet
  'balance': 'Saldo',
  'transactions': 'Transações',
  'cards': 'Cartões',
  'bills': 'Contas',
  'savings': 'Poupança',
  'send': 'Enviar',
  'receive': 'Receber',
  'pay': 'Pagar',
  'topUp': 'Recarregar',
  'income': 'Receita',
  'expense': 'Despesa',
  
  // Date and time
  'today': 'Hoje',
  'yesterday': 'Ontem',
  'tomorrow': 'Amanhã',
  'thisWeek': 'Esta semana',
  'thisMonth': 'Este mês',
  'thisYear': 'Este ano',
  
  // Settings specific
  'appearance': 'Aparência',
  'animations': 'Animações',
  'blurEffects': 'Efeitos de desfoque',
  'blurEffectsDescription': 'Pode afetar o desempenho',
  'hapticFeedback': 'Feedback háptico',
  'about': 'Sobre',
  'madeWithLove': 'Feito com amor',
};