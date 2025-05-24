import os
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

if not os.path.exists(config.configdir / "theme.py"):
    theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
    with urlopen(theme) as themehtml:
        with open(config.configdir / "theme.py", "a") as file:
            file.writelines(themehtml.read().decode("utf-8"))

if os.path.exists(config.configdir / "theme.py"):
    import theme
    theme.setup(c, 'mocha', True)

# c.colors.webpage.darkmode.enabled = True


# Function to toggle tab position

# Toggle tab position

# Set tabs to left
config.bind('tl', 'set tabs.position left')

# Set tabs to top
config.bind('tt', 'set tabs.position top')

# qutebrowser config.py
# Located at ~/.config/qutebrowser/config.py (Linux/macOS) or %APPDATA%\qutebrowser\config.py (Windows)

# General settings
c.auto_save.session = True  # Save session automatically
c.tabs.position = 'left'    # Vertical tabs like Zen Browser
c.tabs.show = 'always'      # Always show tabs
c.tabs.width = 200          # Width of vertical tab bar
c.scrolling.smooth = True   # Smooth scrolling for a Firefox-like feel
c.zoom.default = 100        # Default zoom level (100%)

# Dark theme to match Zen's aesthetic
# c.colors.webpage.darkmode.enabled = True  # Enable dark mode for websites
c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.statusbar.normal.bg = '#353535'  # Dark status bar background
c.colors.statusbar.normal.fg = '#ffffff'  # White text
c.colors.tabs.even.bg = '#2a2a2a'         # Dark tab background (even)
c.colors.tabs.odd.bg = '#2a2a2a'          # Dark tab background (odd)
c.colors.tabs.selected.even.bg = '#4a4a4a' # Selected tab background
c.colors.tabs.selected.even.fg = '#ffffff' # Selected tab text

# Privacy settings
c.content.cookies.accept = 'no-3rdparty'  # Block third-party cookies
c.content.javascript.enabled = True       # Enable JS by default
# Disable JS for specific sites (example)
config.set('content.javascript.enabled', False, '*://example.com/*')

# Ad-blocking
c.content.blocking.method = 'auto'  # Use built-in adblock (requires python-adblock)
c.content.blocking.enabled = True

# Keybindings (Vim-like, customizable to mimic Zen shortcuts)
config.bind('<Ctrl-t>', 'open -t')              # Open new tab (like Ctrl+T in Zen)
config.bind('q', 'tab-close')            # Close tab (like Ctrl+W in Zen)
config.bind('J', 'tab-prev')             # Previous tab
config.bind('K', 'tab-next')             # Next tab
config.bind('f', 'hint links')           # Follow links with hints
config.bind(',v', 'spawn mpv {url}')     # Open media in mpv (external player)
config.bind(',r', 'reload')              # Reload page
config.bind('<Ctrl-h>', 'back')          # Go back (like Alt+Left in Zen)
config.bind('<Ctrl-l>', 'forward')       # Go forward (like Alt+Right in Zen)
config.bind(',p', 'spawn --userscript qute-pass --dmenu-invocation dmenu')
config.bind(',P', 'spawn --userscript qute-pass --dmenu-invocation dmenu --password-only')
# Search engines
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'g': 'https://www.google.com/search?q={}',
    'yt': 'https://www.youtube.com/results?search_query={}',
    'wiki': 'https://en.wikipedia.org/wiki/{}'
}

