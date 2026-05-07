// Extended Material → Lucide icon alias surface.
//
// `LiqMaterialIcons` exposes a static const for every Material `Icons.X`
// identifier currently used by the showcase, mapped to the closest Lucide
// equivalent. Where Material ships filled / outlined / rounded / sharp
// variants, the suffix is preserved on the Liq alias (so call sites can
// migrate verbatim) but the underlying Lucide glyph is the same — Lucide
// is single-style.
//
// The curated short names already on `LiqIcons` (`search`, `home`,
// `mail`, …) are intentionally NOT redefined here; this file is purely
// additive. Where a Material name has no clean Lucide counterpart the
// mapping falls back to `LucideIcons.circleQuestionMark` and is flagged with a
// `// TODO better match` comment.
//
// Consumers use these as drop-in replacements for `Icons.X`:
//
//   Icon(LiqMaterialIcons.accountCircle)
//   Icon(LiqMaterialIcons.errorOutline)
//
// This file is generated/curated; for anything outside the showcase
// surface, import `package:lucide_icons_flutter` and use
// `LucideIcons.X` directly.

// Each member is a curated alias to a Lucide IconData; the names mirror
// Material's so per-member docs would be redundant.
// ignore_for_file: public_member_api_docs, flutter_style_todos, lines_longer_than_80_chars

import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Extended Material-shaped alias surface backed by Lucide.
class LiqMaterialIcons {
  const LiqMaterialIcons._();

  // ─── A ────────────────────────────────────────────────────────────────
  static const acUnitOutlined = LucideIcons.snowflake;
  static const accessTime = LucideIcons.clock;
  static const accountBalanceOutlined = LucideIcons.landmark;
  static const accountBalanceWallet = LucideIcons.wallet;
  static const accountCircle = LucideIcons.circleUser;
  static const add = LucideIcons.plus;
  static const addBox = LucideIcons.squarePlus;
  static const addBoxOutlined = LucideIcons.squarePlus;
  static const addCard = LucideIcons.creditCard;
  static const addCircleOutline = LucideIcons.circlePlus;
  static const addPhotoAlternateOutlined = LucideIcons.imagePlus;
  static const airplanemodeActive = LucideIcons.plane;
  static const alarm = LucideIcons.alarmClock;
  static const alternateEmail = LucideIcons.atSign;
  static const animation = LucideIcons.film;
  static const appSettingsAlt = LucideIcons.settings2;
  static const apple = LucideIcons.apple;
  static const apps = LucideIcons.layoutGrid;
  static const archive = LucideIcons.archive;
  static const arrowBack = LucideIcons.arrowLeft;
  static const arrowBackIos = LucideIcons.chevronLeft;
  static const arrowDownward = LucideIcons.arrowDown;
  static const arrowDropDownCircle = LucideIcons.circleArrowDown;
  static const arrowDropUp = LucideIcons.chevronUp;
  static const arrowForward = LucideIcons.arrowRight;
  static const arrowForwardIos = LucideIcons.chevronRight;
  static const arrowUpward = LucideIcons.arrowUp;
  static const attachMoney = LucideIcons.dollarSign;
  static const autoAwesome = LucideIcons.sparkles;

  // ─── B ────────────────────────────────────────────────────────────────
  static const backspaceOutlined = LucideIcons.delete;
  static const backup = LucideIcons.cloudUpload;
  static const barChart = LucideIcons.chartBar;
  static const batteryFull = LucideIcons.batteryFull;
  static const beachAccess = LucideIcons.umbrella;
  static const beachAccessOutlined = LucideIcons.umbrella;
  static const bedtime = LucideIcons.moonStar;
  static const bluetooth = LucideIcons.bluetooth;
  static const blurOn = LucideIcons.circleDot;
  static const bolt = LucideIcons.zap;
  static const boltOutlined = LucideIcons.zap;
  static const book = LucideIcons.book;
  // bookmark omitted: collides with LiqIcons.bookmark.
  static const bookmarkOutline = LucideIcons.bookmark;
  static const brightness6 = LucideIcons.sunMoon;
  static const brush = LucideIcons.brush;
  static const bubbleChart = LucideIcons.chartPie;
  static const bugReport = LucideIcons.bug;
  static const build = LucideIcons.wrench;
  static const businessCenter = LucideIcons.briefcase;

  // ─── C ────────────────────────────────────────────────────────────────
  static const cake = LucideIcons.cake;
  static const calculate = LucideIcons.calculator;
  static const calendarToday = LucideIcons.calendar;
  static const camera = LucideIcons.camera;
  static const cameraAlt = LucideIcons.camera;
  static const cardGiftcard = LucideIcons.gift;
  static const cardMembership = LucideIcons.creditCard;
  static const casino = LucideIcons.dices;
  static const category = LucideIcons.shapes;
  static const celebration = LucideIcons.partyPopper;
  static const celebrationOutlined = LucideIcons.partyPopper;
  static const chat = LucideIcons.messageCircle;
  static const chatBubble = LucideIcons.messageCircle;
  static const chatBubble2Fill = LucideIcons.messagesSquare;
  static const chatBubbleFill = LucideIcons.messageCircle;
  static const chatBubbleOutline = LucideIcons.messageCircle;
  // check omitted: collides with LiqIcons.check.
  static const checkCircle = LucideIcons.circleCheck;
  static const checkCircleOutline = LucideIcons.circleCheck;
  static const chevronLeft = LucideIcons.chevronLeft;
  static const chevronRight = LucideIcons.chevronRight;
  static const circleOutlined = LucideIcons.circle;
  static const clear = LucideIcons.x;
  // close omitted: collides with LiqIcons.close.
  static const cloud = LucideIcons.cloud;
  static const cloudDownload = LucideIcons.cloudDownload;
  static const cloudOutlined = LucideIcons.cloud;
  static const cloudUpload = LucideIcons.cloudUpload;
  static const code = LucideIcons.code;
  static const colorLens = LucideIcons.palette;
  static const comment = LucideIcons.messageSquare;
  static const contacts = LucideIcons.contact;
  static const contentCopy = LucideIcons.copy;
  static const contentPaste = LucideIcons.clipboard;
  // copy omitted: collides with LiqIcons.copy.
  static const creditCard = LucideIcons.creditCard;
  static const cut = LucideIcons.scissors;

  // ─── D ────────────────────────────────────────────────────────────────
  static const darkMode = LucideIcons.moon;
  static const dashboard = LucideIcons.layoutDashboard;
  static const delete = LucideIcons.trash2;
  static const deliveryDining = LucideIcons.bike;
  static const desktopMac = LucideIcons.monitor;
  static const devices = LucideIcons.smartphoneCharging;
  static const dialpad = LucideIcons.grid3x3;
  static const directionsCar = LucideIcons.car;
  static const directionsCarOutlined = LucideIcons.car;
  static const directionsWalk = LucideIcons.footprints;
  static const displaySettings = LucideIcons.monitorCog;
  static const doNotDisturb = LucideIcons.bellOff;
  static const doNotDisturbOn = LucideIcons.circleMinus;
  static const docFill = LucideIcons.fileText;
  static const docOnClipboard = LucideIcons.clipboardCopy;
  static const docOnClipboardFill = LucideIcons.clipboardCopy;
  static const documentScanner = LucideIcons.scanLine;
  static const doneAll = LucideIcons.checkCheck;
  // download omitted: collides with LiqIcons.download.
  static const dragHandle = LucideIcons.gripHorizontal;
  static const driveFileMove = LucideIcons.folderInput;

  // ─── E ────────────────────────────────────────────────────────────────
  // edit omitted: collides with LiqIcons.edit.
  static const editNote = LucideIcons.fileText;
  static const editOutlined = LucideIcons.pencil;
  static const email = LucideIcons.mail;
  static const emailOutlined = LucideIcons.mail;
  static const emojiEmotions = LucideIcons.smile;
  static const emojiEvents = LucideIcons.trophy;
  // error omitted: collides with LiqIcons.error.
  static const errorOutline = LucideIcons.circleAlert;
  static const expandMore = LucideIcons.chevronDown;
  static const explore = LucideIcons.compass;
  static const extension = LucideIcons.puzzle;

  // ─── F ────────────────────────────────────────────────────────────────
  static const face = LucideIcons.smile;
  static const facebook = LucideIcons.circleQuestionMark; // TODO better match
  static const favorite = LucideIcons.heart;
  static const favoriteBorder = LucideIcons.heart;
  static const favoriteOutline = LucideIcons.heart;
  static const fileDownload = LucideIcons.fileDown;
  static const fileUpload = LucideIcons.fileUp;
  static const filterAlt = LucideIcons.funnel;
  static const filterList = LucideIcons.listFilter;
  static const fingerprint = LucideIcons.fingerprintPattern;
  static const firstPage = LucideIcons.chevronsLeft;
  static const fitnessCenter = LucideIcons.dumbbell;
  static const flag = LucideIcons.flag;
  static const flashlightOn = LucideIcons.flashlight;
  static const flight = LucideIcons.plane;
  static const flightOutlined = LucideIcons.plane;
  static const flutterDash = LucideIcons.bird;
  // folder omitted: collides with LiqIcons.folder.
  static const folderOpen = LucideIcons.folderOpen;
  static const folderOutlined = LucideIcons.folder;
  static const formatAlignCenter = LucideIcons.textAlignCenter;
  static const formatAlignLeft = LucideIcons.textAlignStart;
  static const formatAlignRight = LucideIcons.textAlignEnd;
  static const formatBold = LucideIcons.bold;
  static const formatItalic = LucideIcons.italic;
  static const formatSize = LucideIcons.type;
  static const formatUnderlined = LucideIcons.underline;
  static const fullscreen = LucideIcons.maximize;

  // ─── G ────────────────────────────────────────────────────────────────
  static const gradient = LucideIcons.droplet;
  static const gridOn = LucideIcons.grid2x2;
  static const gridView = LucideIcons.layoutGrid;
  static const group = LucideIcons.users;

  // ─── H ────────────────────────────────────────────────────────────────
  // heart omitted: collides with LiqIcons.heart.
  // help omitted: collides with LiqIcons.help.
  static const helpOutline = LucideIcons.circleQuestionMark;
  static const history = LucideIcons.history;
  // home omitted: collides with LiqIcons.home.
  static const homeOutlined = LucideIcons.house;
  static const hotel = LucideIcons.bed;
  static const hourglassEmpty = LucideIcons.hourglass;

  // ─── I ────────────────────────────────────────────────────────────────
  // image omitted: collides with LiqIcons.image.
  static const imageNotSupported = LucideIcons.imageOff;
  static const inbox = LucideIcons.inbox;
  static const inboxOutlined = LucideIcons.inbox;
  // info omitted: collides with LiqIcons.info.
  static const infoOutline = LucideIcons.info;
  static const insertDriveFile = LucideIcons.file;

  // ─── K ────────────────────────────────────────────────────────────────
  static const keyboard = LucideIcons.keyboard;
  static const keyboardArrowLeft = LucideIcons.chevronLeft;
  static const keyboardArrowRight = LucideIcons.chevronRight;

  // ─── L ────────────────────────────────────────────────────────────────
  static const landscape = LucideIcons.mountain;
  static const language = LucideIcons.languages;
  static const laptopMac = LucideIcons.laptop;
  static const lastPage = LucideIcons.chevronsRight;
  // layers omitted: collides with LiqIcons.layers.
  static const lightMode = LucideIcons.sun;
  static const linearScale = LucideIcons.minus;
  // link omitted: collides with LiqIcons.link.
  // list omitted: collides with LiqIcons.list.
  static const liveTv = LucideIcons.tv;
  static const localCafeOutlined = LucideIcons.coffee;
  static const localFireDepartment = LucideIcons.flame;
  static const localFloristOutlined = LucideIcons.flower;
  static const localHospital = LucideIcons.hospital;
  static const localParking = LucideIcons.circleParking;
  static const localShipping = LucideIcons.truck;
  static const locationOn = LucideIcons.mapPin;
  // lock omitted: collides with LiqIcons.lock.
  static const lockOutline = LucideIcons.lock;
  static const logout = LucideIcons.logOut;
  static const looks3 = LucideIcons.circleQuestionMark; // TODO better match
  static const looksOne = LucideIcons.circleQuestionMark; // TODO better match
  static const looksTwo = LucideIcons.circleQuestionMark; // TODO better match

  // ─── M ────────────────────────────────────────────────────────────────
  // mail omitted: collides with LiqIcons.mail.
  static const mailSolid = LucideIcons.mail;
  static const map = LucideIcons.map;
  static const medicalServices = LucideIcons.stethoscope;
  // menu omitted: collides with LiqIcons.menu.
  static const menuOpen = LucideIcons.panelLeftOpen;
  // message omitted: collides with LiqIcons.message.
  static const messageOutlined = LucideIcons.messageSquare;
  static const mic = LucideIcons.mic;
  static const moreHoriz = LucideIcons.ellipsis;
  static const moreVert = LucideIcons.ellipsisVertical;
  static const movie = LucideIcons.clapperboard;
  static const movieOutlined = LucideIcons.clapperboard;
  static const musicNote = LucideIcons.music;

  // ─── N ────────────────────────────────────────────────────────────────
  static const navigateBefore = LucideIcons.chevronLeft;
  static const navigateNext = LucideIcons.chevronRight;
  static const navigation = LucideIcons.navigation;
  static const newReleases = LucideIcons.zap;
  static const newspaper = LucideIcons.newspaper;
  static const note = LucideIcons.stickyNote;
  static const notifications = LucideIcons.bell;
  static const notificationsNone = LucideIcons.bell;
  static const notificationsOutlined = LucideIcons.bell;
  static const numbers = LucideIcons.hash;

  // ─── O ────────────────────────────────────────────────────────────────
  static const openInNew = LucideIcons.externalLink;

  // ─── P ────────────────────────────────────────────────────────────────
  // palette omitted: collides with LiqIcons.palette.
  static const paste = LucideIcons.clipboardCopy;
  static const payment = LucideIcons.creditCard;
  static const paymentsOutlined = LucideIcons.banknote;
  static const people = LucideIcons.users;
  static const person = LucideIcons.user;
  static const personAdd = LucideIcons.userPlus;
  static const personFill = LucideIcons.user;
  static const personOutline = LucideIcons.user;
  // phone omitted: collides with LiqIcons.phone.
  static const phoneIphone = LucideIcons.smartphone;
  static const photo = LucideIcons.image;
  static const photoLibrary = LucideIcons.images;
  static const pictureAsPdf = LucideIcons.fileText;
  static const playArrow = LucideIcons.play;
  static const playCircleFilled = LucideIcons.circlePlay;
  static const playCircleOutline = LucideIcons.circlePlay;
  static const pool = LucideIcons.waves;
  static const print = LucideIcons.printer;
  static const printer = LucideIcons.printer;
  static const public = LucideIcons.globe;

  // ─── Q ────────────────────────────────────────────────────────────────
  static const qrCodeScanner = LucideIcons.qrCode;

  // ─── R ────────────────────────────────────────────────────────────────
  static const radiowavesLeft = LucideIcons.waves;
  static const rateReview = LucideIcons.messageSquare;
  static const receipt = LucideIcons.receipt;
  static const receiptLong = LucideIcons.receiptText;
  static const receiptOutlined = LucideIcons.receipt;
  static const recordVoiceOver = LucideIcons.mic;
  static const redo = LucideIcons.redo2;
  static const remove = LucideIcons.minus;
  static const removeCircleOutline = LucideIcons.circleMinus;
  static const restaurant = LucideIcons.utensils;
  static const restore = LucideIcons.undo2;
  static const rocket = LucideIcons.rocket;
  static const rocketLaunch = LucideIcons.rocket;
  static const rocketLaunchOutlined = LucideIcons.rocket;

  // ─── S ────────────────────────────────────────────────────────────────
  static const save = LucideIcons.save;
  static const saveAlt = LucideIcons.download;
  static const savings = LucideIcons.piggyBank;
  static const school = LucideIcons.graduationCap;
  static const science = LucideIcons.flaskConical;
  // search omitted: collides with LiqIcons.search.
  static const searchOff = LucideIcons.searchX;
  static const searchOutlined = LucideIcons.search;
  static const security = LucideIcons.shield;
  static const selectAll = LucideIcons.squareCheck;
  static const send = LucideIcons.send;
  static const sendOutlined = LucideIcons.send;
  // settings omitted: collides with LiqIcons.settings.
  static const settingsApplications = LucideIcons.settings2;
  static const settingsSystemDaydream = LucideIcons.monitorCog;
  // share omitted: collides with LiqIcons.share.
  static const shoppingBag = LucideIcons.shoppingBag;
  static const shoppingBagOutlined = LucideIcons.shoppingBag;
  static const shoppingCart = LucideIcons.shoppingCart;
  static const shoppingCartOutlined = LucideIcons.shoppingCart;
  static const showChart = LucideIcons.chartLine;
  static const signalCellular4Bar = LucideIcons.signalHigh;
  static const signalCellularAlt = LucideIcons.signal;
  static const smartButton = LucideIcons.bot;
  static const sms = LucideIcons.messageSquare;
  static const spa = LucideIcons.flower;
  static const speed = LucideIcons.gauge;
  static const sportsBasketball = LucideIcons.circleQuestionMark; // TODO better match
  static const sportsEsports = LucideIcons.gamepad2;
  static const sportsScore = LucideIcons.trophy;
  static const sportsSoccer = LucideIcons.volleyball;
  static const square = LucideIcons.square;
  // star omitted: collides with LiqIcons.star.
  static const starBorder = LucideIcons.star;
  static const starOutline = LucideIcons.star;
  static const stickyNote2 = LucideIcons.stickyNote;
  static const stop = LucideIcons.square;
  static const straighten = LucideIcons.ruler;
  static const subdirectoryArrowLeft = LucideIcons.cornerDownLeft;
  static const subdirectoryArrowRight = LucideIcons.cornerDownRight;
  static const swipe = LucideIcons.hand;
  static const swipeVertical = LucideIcons.hand;
  static const systemUpdate = LucideIcons.cloudDownload;

  // ─── T ────────────────────────────────────────────────────────────────
  static const tab = LucideIcons.layoutPanelTop;
  static const tabletMac = LucideIcons.tablet;
  // tag omitted: collides with LiqIcons.tag.
  static const task = LucideIcons.listChecks;
  static const textDecrease = LucideIcons.aArrowDown;
  static const textFields = LucideIcons.type;
  static const textFormat = LucideIcons.type;
  static const textIncrease = LucideIcons.aArrowUp;
  static const thermostat = LucideIcons.thermometer;
  static const thumbUp = LucideIcons.thumbsUp;
  static const timeline = LucideIcons.chartLine;
  static const timer = LucideIcons.timer;
  static const toggleOn = LucideIcons.toggleRight;
  static const touchApp = LucideIcons.hand;
  static const translate = LucideIcons.languages;
  static const trendingUp = LucideIcons.trendingUp;
  static const tune = LucideIcons.slidersHorizontal;

  // ─── U ────────────────────────────────────────────────────────────────
  static const undo = LucideIcons.undo2;
  // upload omitted: collides with LiqIcons.upload.

  // ─── V ────────────────────────────────────────────────────────────────
  static const verified = LucideIcons.shieldCheck;
  static const verticalAlignBottom = LucideIcons.arrowDownToLine;
  static const vibration = LucideIcons.vibrate;
  static const videocam = LucideIcons.video;
  static const viewAgenda = LucideIcons.rows2;
  static const viewColumn = LucideIcons.columns3;
  static const viewHeadline = LucideIcons.textAlignJustify;
  static const viewList = LucideIcons.list;
  static const viewModule = LucideIcons.layoutGrid;
  static const viewSidebar = LucideIcons.panelLeft;
  static const viewWeek = LucideIcons.columns3;
  static const visibility = LucideIcons.eye;
  static const visibilityOff = LucideIcons.eyeOff;
  static const volumeUp = LucideIcons.volume2;

  // ─── W ────────────────────────────────────────────────────────────────
  static const wallpaper = LucideIcons.wallpaper;
  // warning omitted: collides with LiqIcons.warning.
  static const warningAmberOutlined = LucideIcons.triangleAlert;
  static const warningAmberRounded = LucideIcons.triangleAlert;
  static const watch = LucideIcons.watch;
  static const waterDrop = LucideIcons.droplet;
  static const waterDropOutlined = LucideIcons.droplet;
  static const wavingHand = LucideIcons.hand;
  static const wbSunny = LucideIcons.sun;
  static const wbSunnyOutlined = LucideIcons.sun;
  static const web = LucideIcons.globe;
  // widgets omitted: collides with LiqIcons.widgets.
  // wifi omitted: collides with LiqIcons.wifi.
  static const wifiOff = LucideIcons.wifiOff;
  static const wifiTethering = LucideIcons.radio;
  static const workspaces = LucideIcons.layoutGrid;

  // ─── Z ────────────────────────────────────────────────────────────────
  static const zoomIn = LucideIcons.zoomIn;
}
