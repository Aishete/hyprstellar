# ~/.config/qutebrowser/config.py
# ------------------------------------------------------------
# Hyprland + Pywal → Read colors.Xresources directly
# ------------------------------------------------------------

config.load_autoconfig(False)  # ← removes warning

import re
from pathlib import Path

# ------------------------------------------------------------------
# Read Pywal's colors.Xresources file
# Returns: {"*.foreground": "#c5c5c3", "*.color0": "#191a12", ...}
# ------------------------------------------------------------------
def read_wal_xresources():
    props = {}
    xres_path = Path.home() / ".cache/wal/colors.Xresources"

    if not xres_path.is_file():
        print(f"[qute] {xres_path} not found")
        return props

    try:
        for line in xres_path.read_text().splitlines():
            line = line.strip()
            if not line or line.startswith('!'):
                continue
            # Match: *.color0: #191a12  or  *color0:  #191a12
            m = re.match(r'^(\*\.?)(\w+):\s*#?([0-9a-fA-F]{6})\b', line)
            if m:
                prefix, name, value = m.groups()
                key = f"*.{name}"
                props[key] = f"#{value}"
    except Exception as e:
        print(f"[qute] error reading {xres_path}: {e}")

    # ------------------------------------------------------------------
    # Hard defaults (in case file is broken)
    # ------------------------------------------------------------------
    props.setdefault("*.foreground", "#ebdbb2")
    props.setdefault("*.background", "#282828")
    for i in range(16):
        props.setdefault(f"*.color{i}", "#000000")

    print("[qute] Loaded Xresources keys:", sorted(k for k in props.keys() if k.startswith("*.")))
    return props


# ------------------------------------------------------------------
# Load colors
# ------------------------------------------------------------------
c = config
xres = read_wal_xresources()

def get(col):
    return xres.get(f"*.{col}", "#ffffff")


# ------------------------------------------------------------------
# === STATUSBAR =====================================================
# ------------------------------------------------------------------
c.colors.statusbar.normal.bg        = get("background")
c.colors.statusbar.normal.fg        = get("foreground")
c.colors.statusbar.insert.bg        = get("color2")
c.colors.statusbar.insert.fg        = get("background")
c.colors.statusbar.passthrough.bg   = get("color4")
c.colors.statusbar.passthrough.fg   = get("background")
c.colors.statusbar.command.bg       = get("background")
c.colors.statusbar.command.fg       = get("foreground")
c.colors.statusbar.caret.bg         = get("color5")
c.colors.statusbar.caret.fg         = get("background")
c.colors.statusbar.progress.bg      = get("color3")
c.colors.statusbar.url.success.http.fg = get("foreground")
c.colors.statusbar.url.success.https.fg = get("color2")

# ------------------------------------------------------------------
# === TABS ==========================================================
# ------------------------------------------------------------------
c.colors.tabs.even.bg               = get("background")
c.colors.tabs.even.fg               = get("foreground")
c.colors.tabs.odd.bg                = get("background")
c.colors.tabs.odd.fg                = get("foreground")
c.colors.tabs.selected.even.bg      = get("color8")
c.colors.tabs.selected.even.fg      = get("foreground")
c.colors.tabs.selected.odd.bg       = get("color8")
c.colors.tabs.selected.odd.fg       = get("foreground")
c.colors.tabs.indicator.error       = get("color1")
c.colors.tabs.indicator.start       = get("color4")
c.colors.tabs.indicator.stop        = get("color2")

# ------------------------------------------------------------------
# === COMPLETION ====================================================
# ------------------------------------------------------------------
c.colors.completion.fg                     = get("foreground")
c.colors.completion.even.bg                = get("background")
c.colors.completion.odd.bg                 = get("background")
c.colors.completion.category.bg            = get("color8")
c.colors.completion.category.fg            = get("foreground")
c.colors.completion.item.selected.bg       = get("color8")
c.colors.completion.item.selected.fg       = get("foreground")
c.colors.completion.match.fg               = get("color3")

# ------------------------------------------------------------------
# === HINTS =========================================================
# ------------------------------------------------------------------
c.colors.hints.bg        = get("color0")
c.colors.hints.fg        = get("background")
c.colors.hints.match.fg  = get("color2")

# ------------------------------------------------------------------
# === DOWNLOADS & MESSAGES ==========================================
# ------------------------------------------------------------------
c.colors.downloads.bar.bg   = get("background")
c.colors.downloads.start.fg = get("color4")
c.colors.downloads.stop.fg  = get("color2")
c.colors.messages.info.bg   = get("background")
c.colors.messages.info.fg   = get("foreground")

# ------------------------------------------------------------------
# Reload colors when wallpaper changes
# ------------------------------------------------------------------
def reload_colors(*_):
    global xres
    xres = read_wal_xresources()
    config.source(__file__)

config.bind('<Ctrl-R>', 'config-source', mode='normal')

c.tabs.title.format = "{audio}{current_title}"
c.fonts.web.size.default = 20

c.url.searchengines = {
# note - if you use duckduckgo, you can make use of its built in bangs, of which there are many! https://duckduckgo.com/bangs
        'DEFAULT': 'https://duckduckgo.com/?q={}',
        '!aw': 'https://wiki.archlinux.org/?search={}',
        '!apkg': 'https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged=',
        '!gh': 'https://github.com/search?o=desc&q={}&s=stars',
        '!yt': 'https://www.youtube.com/results?search_query={}',
        }

c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history', 'filesystem']

# config.load_autoconfig() # load settings done via the gui

c.auto_save.session = True # save tabs on quit/restart

# keybinding changes
config.bind('=', 'cmd-set-text -s :open')
config.bind('h', 'history')
config.bind('cc', 'hint images spawn sh -c "cliphist link {hint-url}"')
config.bind('cs', 'cmd-set-text -s :config-source')
config.bind('tH', 'config-cycle tabs.show multiple never')
config.bind('sH', 'config-cycle statusbar.show always never')
config.bind('T', 'hint links tab')
config.bind('pP', 'open -- {primary}')
config.bind('pp', 'open -- {clipboard}')
config.bind('pt', 'open -t -- {clipboard}')
config.bind('qm', 'macro-record')
config.bind('<ctrl-y>', 'spawn --userscript ytdl.sh')
config.bind('tT', 'config-cycle tabs.position top left')
config.bind('gJ', 'tab-move +')
config.bind('gK', 'tab-move -')
config.bind('gm', 'tab-move')

# dark mode setup
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'
config.set('colors.webpage.darkmode.enabled', False, 'file://*')

# styles, cosmetics
# c.content.user_stylesheets = ["~/.config/qutebrowser/styles/youtube-tweaks.css"]
c.tabs.padding = {'top': 5, 'bottom': 5, 'left': 9, 'right': 9}
c.tabs.indicator.width = 0 # no tab indicators
# c.window.transparent = True # apparently not needed
c.tabs.width = '7%'

# fonts
c.fonts.default_family = []
c.fonts.default_size = '13pt'
c.fonts.web.family.fixed = 'monospace'
c.fonts.web.family.sans_serif = 'monospace'
c.fonts.web.family.serif = 'monospace'
c.fonts.web.family.standard = 'monospace'

# privacy - adjust these settings based on your preference
# config.set("completion.cmd_history_max_items", 0)
# config.set("content.private_browsing", True)
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)
# config.set("content.javascript.enabled", False) # tsh keybind to toggle

# Adblocking info -->
# For yt ads: place the greasemonkey script yt-ads.js in your greasemonkey folder (~/.config/qutebrowser/greasemonkey).
# The script skips through the entire ad, so all you have to do is click the skip button.
# Yeah it's not ublock origin, but if you want a minimal browser, this is a solution for the tradeoff.
# You can also watch yt vids directly in mpv, see qutebrowser FAQ for how to do that.
# If you want additional blocklists, you can get the python-adblock package, or you can uncomment the ublock lists here.
c.content.blocking.enabled = True
# c.content.blocking.method = 'adblock' # uncomment this if you install python-adblock
# c.content.blocking.adblock.lists = [
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"]
