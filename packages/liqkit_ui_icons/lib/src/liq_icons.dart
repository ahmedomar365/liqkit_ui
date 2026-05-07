// Curated icon namespace backed by Lucide.
//
// Each member resolves to a Lucide `IconData`. Consumers use these as
// drop-in replacements for `Icons.X` from Material:
//
//   Icon(LiqIcons.search)
//   LiqMenuItem(label: 'Delete', icon: Icon(LiqIcons.trash, size: 20), …)
//
// Lucide ships a single icon font; tree-shaking does not reduce its size,
// so we expose a curated alias surface for the icons most likely to
// appear in iOS-26 app shells (top bars, menus, list rows, empty states,
// badges). For anything else, import `package:lucide_icons_flutter` and
// use `LucideIcons.X` directly.

// Each member is a curated alias to a Lucide IconData; the names speak
// for themselves and would only be redundantly documented one-by-one.
// ignore_for_file: public_member_api_docs

import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Curated icon set backed by Lucide.
class LiqIcons {
  const LiqIcons._();

  // ─── Action / common ─────────────────────────────────────────────────
  static const search   = LucideIcons.search;
  static const close    = LucideIcons.x;
  static const check    = LucideIcons.check;
  static const plus     = LucideIcons.plus;
  static const minus    = LucideIcons.minus;
  static const more     = LucideIcons.ellipsis;
  static const moreV    = LucideIcons.ellipsisVertical;
  static const settings = LucideIcons.settings;
  static const filter   = LucideIcons.listFilter;
  static const trash    = LucideIcons.trash2;
  static const edit     = LucideIcons.pencil;
  static const copy     = LucideIcons.copy;
  static const share    = LucideIcons.share;
  static const refresh  = LucideIcons.refreshCw;
  static const download = LucideIcons.download;
  static const upload   = LucideIcons.upload;

  // ─── Navigation ──────────────────────────────────────────────────────
  static const back     = LucideIcons.chevronLeft;
  static const forward  = LucideIcons.chevronRight;
  static const up       = LucideIcons.chevronUp;
  static const down     = LucideIcons.chevronDown;
  static const menu     = LucideIcons.menu;
  static const grid     = LucideIcons.layoutGrid;
  static const list     = LucideIcons.list;
  static const home     = LucideIcons.house;
  static const calendar = LucideIcons.calendar;
  static const today    = LucideIcons.calendarDays;

  // ─── Content ─────────────────────────────────────────────────────────
  static const palette  = LucideIcons.palette;
  static const widgets  = LucideIcons.layoutGrid;
  static const layers   = LucideIcons.layers;
  static const droplet  = LucideIcons.droplet;
  static const star     = LucideIcons.star;
  static const heart    = LucideIcons.heart;
  static const bookmark = LucideIcons.bookmark;
  static const tag      = LucideIcons.tag;
  static const folder   = LucideIcons.folder;
  static const file     = LucideIcons.file;
  static const image    = LucideIcons.image;
  static const link     = LucideIcons.link;
  static const key      = LucideIcons.key;
  static const lock     = LucideIcons.lock;
  static const unlock   = LucideIcons.lockOpen;
  static const eye      = LucideIcons.eye;
  static const eyeOff   = LucideIcons.eyeOff;

  // ─── People / messaging ──────────────────────────────────────────────
  static const user     = LucideIcons.user;
  static const users    = LucideIcons.users;
  static const mail     = LucideIcons.mail;
  static const message  = LucideIcons.messageSquare;
  static const phone    = LucideIcons.phone;
  static const bell     = LucideIcons.bell;

  // ─── Status / feedback ───────────────────────────────────────────────
  static const info     = LucideIcons.info;
  static const warning  = LucideIcons.triangleAlert;
  static const error    = LucideIcons.circleAlert;
  static const success  = LucideIcons.circleCheck;
  static const help     = LucideIcons.circleQuestionMark;

  // ─── System ──────────────────────────────────────────────────────────
  static const sun      = LucideIcons.sun;
  static const moon     = LucideIcons.moon;
  static const monitor  = LucideIcons.monitor;
  static const wifi     = LucideIcons.wifi;
  static const battery  = LucideIcons.battery;
  static const power    = LucideIcons.power;
}
