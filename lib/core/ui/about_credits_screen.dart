import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:genius_project/core/ui/adaptive_layout.dart';

// ---------------------------------------------------------------------------
// Colour tokens — Dark Gold Lounge palette (local to this screen)
// ---------------------------------------------------------------------------
const Color _kBackground = Color(0xFF121212);
const Color _kSurface = Color(0xFF1C1C1E);
const Color _kSurfaceHigher = Color(0xFF242428);
const Color _kGold = Color(0xFFD4AF37);
const Color _kGoldMuted = Color(0xFFA88A2A);
const Color _kIvory = Color(0xFFE5E5E5);
const Color _kMuted = Color(0xFF8A8A8E);
const Color _kDivider = Color(0xFF2E2E32);

// ---------------------------------------------------------------------------
// Public screen
// ---------------------------------------------------------------------------

/// Full-screen landscape "About & Credits" screen.
///
/// Route: `/about`  
/// Entry point: the "Credits" button at the bottom of [AudioSettingsSheet].
///
/// Layout:
/// - **Left panel** (flex 3): dark velvet branding — monogram, title,
///   tagline, legal note, back button.
/// - **Right panel** (flex 7): scrollable credit cards for BGM and SFX.
///
/// All external links open in the system browser via [url_launcher].
class AboutCreditsScreen extends StatelessWidget {
  const AboutCreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final gap = AdaptiveLayout.landscapeSplitGap(context, constraints);
            final insets = AdaptiveLayout.landscapeSplitHorizontalInsets(context);

            return Padding(
              padding: insets,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ---- left: branding + legal ----
                  Expanded(flex: 3, child: _BrandingPanel(gap: gap)),
                  SizedBox(width: gap),
                  // ---- right: scrollable credits ----
                  Expanded(flex: 7, child: _CreditsPanel(gap: gap)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Left panel — branding
// ---------------------------------------------------------------------------

class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel({required this.gap});
  final double gap;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);

    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(s * 0.022),
        border: Border.all(color: _kGold.withValues(alpha: 0.18)),
      ),
      padding: EdgeInsets.all(s * 0.038),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // monogram badge
          Container(
            width: s * 0.11,
            height: s * 0.11,
            decoration: BoxDecoration(
              color: _kGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(s * 0.022),
              border: Border.all(color: _kGold.withValues(alpha: 0.45)),
            ),
            child: Center(
              child: Text(
                'GP',
                style: TextStyle(
                  fontSize: s * 0.038,
                  fontWeight: FontWeight.w800,
                  color: _kGold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          SizedBox(height: gap * 1.2),

          Text(
            'Genius Project',
            style: TextStyle(
              fontSize: s * 0.032,
              fontWeight: FontWeight.w800,
              color: _kIvory,
              letterSpacing: -0.4,
            ),
          ),

          SizedBox(height: gap * 0.35),

          Text(
            'Phase 1 · v0.1.0',
            style: TextStyle(fontSize: s * 0.018, color: _kGold),
          ),

          SizedBox(height: gap * 0.5),

          Text(
            'A modular landscape game hub.\nSeven skill-based mini-games.',
            style: TextStyle(
              fontSize: s * 0.017,
              color: _kMuted,
              height: 1.4,
            ),
          ),

          const Spacer(),

          // legal boilerplate
          Container(
            padding: EdgeInsets.all(s * 0.018),
            decoration: BoxDecoration(
              color: _kBackground,
              borderRadius: BorderRadius.circular(s * 0.014),
              border: Border.all(color: _kDivider),
            ),
            child: Text(
              'Third-party audio assets are used under their respective '
              'open licenses (CC BY, CC BY-NC, CC0). Full attribution is '
              'listed in the Credits panel.',
              style: TextStyle(
                fontSize: s * 0.014,
                color: _kMuted,
                height: 1.35,
              ),
            ),
          ),

          SizedBox(height: gap),

          // back button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/lobby');
                }
              },
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _kGold,
                side: BorderSide(color: _kGold.withValues(alpha: 0.55)),
                padding: EdgeInsets.symmetric(vertical: s * 0.018),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Right panel — scrollable credits
// ---------------------------------------------------------------------------

class _CreditsPanel extends StatelessWidget {
  const _CreditsPanel({required this.gap});
  final double gap;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);

    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(s * 0.022),
        border: Border.all(color: _kDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---- panel header ----
          Padding(
            padding: EdgeInsets.fromLTRB(s * 0.03, s * 0.024, s * 0.03, 0),
            child: Row(
              children: [
                Icon(Icons.verified_rounded, color: _kGold, size: s * 0.028),
                SizedBox(width: s * 0.012),
                Text(
                  'Credits & Attributions',
                  style: TextStyle(
                    fontSize: s * 0.026,
                    fontWeight: FontWeight.w800,
                    color: _kIvory,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: s * 0.012),
          const Divider(color: _kDivider, height: 1),

          // ---- scrollable content ----
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(s * 0.026),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CreditSection(
                    icon: Icons.music_note_rounded,
                    sectionTitle: 'Lounge & In-Game Soundtracks',
                    entries: _bgmEntries,
                  ),
                  SizedBox(height: gap * 1.4),
                  _CreditSection(
                    icon: Icons.volume_up_rounded,
                    sectionTitle: 'ASMR & Interface Audio',
                    entries: _sfxEntries,
                  ),
                  SizedBox(height: gap * 0.8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section widget
// ---------------------------------------------------------------------------

class _CreditSection extends StatelessWidget {
  const _CreditSection({
    required this.icon,
    required this.sectionTitle,
    required this.entries,
  });

  final IconData icon;
  final String sectionTitle;
  final List<_CreditEntry> entries;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);
    final gap = AdaptiveLayout.inlineGap(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // section header row
        Row(
          children: [
            Icon(icon, color: _kGoldMuted, size: s * 0.022),
            SizedBox(width: gap * 0.6),
            Text(
              sectionTitle,
              style: TextStyle(
                fontSize: s * 0.021,
                fontWeight: FontWeight.w700,
                color: _kGold,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),

        SizedBox(height: gap * 0.7),

        // entry cards
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0) SizedBox(height: gap * 0.5),
          _CreditCard(entry: entries[i]),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Individual credit card
// ---------------------------------------------------------------------------

class _CreditCard extends StatelessWidget {
  const _CreditCard({required this.entry});
  final _CreditEntry entry;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);
    final gap = AdaptiveLayout.inlineGap(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: s * 0.022,
        vertical: s * 0.016,
      ),
      decoration: BoxDecoration(
        color: _kSurfaceHigher,
        borderRadius: BorderRadius.circular(s * 0.014),
        border: Border.all(color: _kDivider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---- title ----
          Expanded(
            flex: 4,
            child: Text(
              '"${entry.title}"',
              style: TextStyle(
                fontSize: s * 0.019,
                fontWeight: FontWeight.w700,
                color: _kIvory,
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(width: gap),

          // ---- author ----
          Expanded(
            flex: 4,
            child: entry.authorUrl != null
                ? _GoldLink(label: entry.author, url: entry.authorUrl!)
                : Text(
                    entry.author,
                    style: TextStyle(fontSize: s * 0.017, color: _kMuted),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),

          SizedBox(width: gap),

          // ---- source (Freesound # or incompetech) ----
          if (entry.sourceLabel != null && entry.sourceUrl != null)
            Expanded(
              flex: 3,
              child: _GoldLink(
                label: entry.sourceLabel!,
                url: entry.sourceUrl!,
              ),
            )
          else
            const Expanded(flex: 3, child: SizedBox.shrink()),

          SizedBox(width: gap),

          // ---- license ----
          Expanded(
            flex: 4,
            child: _GoldLink(
              label: entry.license,
              url: entry.licenseUrl,
              muted: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable gold hyperlink widget
// ---------------------------------------------------------------------------

class _GoldLink extends StatelessWidget {
  const _GoldLink({
    required this.label,
    required this.url,
    this.muted = false,
  });

  final String label;
  final String url;
  final bool muted;

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open: $url'),
            backgroundColor: _kSurface,
          ),
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Link error: $e'),
            backgroundColor: _kSurface,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);
    final color = muted ? _kGoldMuted : _kGold;

    return GestureDetector(
      onTap: () => _open(context),
      child: Text(
        label,
        style: TextStyle(
          fontSize: s * 0.017,
          color: color,
          decoration: TextDecoration.underline,
          decorationColor: color.withValues(alpha: 0.6),
          decorationStyle: TextDecorationStyle.solid,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _CreditEntry {
  const _CreditEntry({
    required this.title,
    required this.author,
    this.authorUrl,
    this.sourceLabel,
    this.sourceUrl,
    required this.license,
    required this.licenseUrl,
  });

  final String title;
  final String author;
  final String? authorUrl;
  final String? sourceLabel;
  final String? sourceUrl;
  final String license;
  final String licenseUrl;
}

// ---------------------------------------------------------------------------
// Credit data — BGM (Kevin MacLeod / Incompetech)
// ---------------------------------------------------------------------------

const _kIncompetechUrl = 'https://incompetech.com';
const _kCcBy40Url = 'https://creativecommons.org/licenses/by/4.0/';
const _kCcBy30Url = 'https://creativecommons.org/licenses/by/3.0/';
const _kCc0Url = 'https://creativecommons.org/publicdomain/zero/1.0/';

const List<_CreditEntry> _bgmEntries = [
  _CreditEntry(
    title: 'Evening',
    author: 'Kevin MacLeod (incompetech.com)',
    authorUrl: _kIncompetechUrl,
    license: 'Creative Commons: By Attribution 4.0',
    licenseUrl: _kCcBy40Url,
  ),
  _CreditEntry(
    title: 'Starting Out Waltz Vivace',
    author: 'Kevin MacLeod (incompetech.com)',
    authorUrl: _kIncompetechUrl,
    license: 'Creative Commons: By Attribution 4.0',
    licenseUrl: _kCcBy40Url,
  ),
  _CreditEntry(
    title: 'Too Cool',
    author: 'Kevin MacLeod (incompetech.com)',
    authorUrl: _kIncompetechUrl,
    license: 'Creative Commons: By Attribution 4.0',
    licenseUrl: _kCcBy40Url,
  ),
  _CreditEntry(
    title: 'Hackbeat',
    author: 'Kevin MacLeod (incompetech.com)',
    authorUrl: _kIncompetechUrl,
    license: 'Creative Commons: By Attribution 4.0',
    licenseUrl: _kCcBy40Url,
  ),
];

// ---------------------------------------------------------------------------
// Credit data — SFX (Freesound.org)
// ---------------------------------------------------------------------------

const List<_CreditEntry> _sfxEntries = [
  _CreditEntry(
    title: 'game_over.wav',
    author: 'deleted_user_877451',
    sourceLabel: 'Freesound #76376',
    sourceUrl: 'https://freesound.org/s/76376/',
    license: 'Attribution 3.0',
    licenseUrl: _kCcBy30Url,
  ),
  _CreditEntry(
    title: 'Error.wav',
    author: 'Autistic Lucario',
    sourceLabel: 'Freesound #142608',
    sourceUrl: 'https://freesound.org/s/142608/',
    license: 'Attribution 4.0',
    licenseUrl: _kCcBy40Url,
  ),
  _CreditEntry(
    title: 'Ticking Timer 05 Sec.wav',
    author: 'LilMati',
    sourceLabel: 'Freesound #487725',
    sourceUrl: 'https://freesound.org/s/487725/',
    license: 'Creative Commons 0',
    licenseUrl: _kCc0Url,
  ),
  _CreditEntry(
    title: 'Powerup / success.wav',
    author: 'GabrielAraujo',
    sourceLabel: 'Freesound #242501',
    sourceUrl: 'https://freesound.org/s/242501/',
    license: 'Creative Commons 0',
    licenseUrl: _kCc0Url,
  ),
  _CreditEntry(
    title: 'Wrong Choice',
    author: 'unadamlar',
    sourceLabel: 'Freesound #476177',
    sourceUrl: 'https://freesound.org/s/476177/',
    license: 'Creative Commons 0',
    licenseUrl: _kCc0Url,
  ),
  _CreditEntry(
    title: 'magic_game_win_success.wav',
    author: 'MLaudio',
    sourceLabel: 'Freesound #615099',
    sourceUrl: 'https://freesound.org/s/615099/',
    license: 'Creative Commons 0',
    licenseUrl: _kCc0Url,
  ),
  _CreditEntry(
    title: 'Barrett M82A1 Sniper Shot',
    author: 'qubodup',
    sourceLabel: 'Freesound #855597',
    sourceUrl: 'https://freesound.org/s/855597/',
    license: 'Creative Commons 0',
    licenseUrl: _kCc0Url,
  ),
];
