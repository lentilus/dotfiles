# type: ignore

import os
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
# config.load_autoconfig()

if not os.path.exists(config.configdir / "theme.py"):
    theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
    with urlopen(theme) as themehtml:
        with open(config.configdir / "theme.py", "a") as file:
            file.writelines(themehtml.read().decode("utf-8"))

if os.path.exists(config.configdir / "theme.py"):
    import theme
    theme.setup(c, 'mocha', True)

# defaults
config.load_autoconfig(False)
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')
# config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0', 'https://accounts.google.com/*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')
config.set('content.local_content_can_access_remote_urls', True, 'file:///home/lentilus/.local/share/qutebrowser/userscripts/*')
config.set('content.local_content_can_access_file_urls', False, 'file:///home/lentilus/.local/share/qutebrowser/userscripts/*')
config.set('content.blocking.enabled', True)
config.set('content.blocking.method', 'both')

# c.fileselect.handler = 'external'
# c.fileselect.folder.command = ['kitty', '-e', 'ranger', '--choosedir={}']
# c.fileselect.multiple_files.command = ['kitty', '-e', 'ranger', '--choosefiles={}']
# c.fileselect.single_file.command = ['kitty', '-e', 'ranger', '--choosefile={}']

config.set('fileselect.handler', 'external')
config.set('fileselect.folder.command', ['footclient', '-e', 'ranger', '--choosedir','{}'])
config.set('fileselect.single_file.command', ['footclient', '-e', 'ranger', '--choosefile','{}'])
config.set('fileselect.multiple_files.command', ['footclient', '-e', 'ranger', '--choosefiles', '{}'])
config.set('downloads.location.prompt', False)

config.bind('<Space>dl', 'hint links spawn -u ranger-dl {hint-url}')
config.bind('<Space>ff', 'cmd-set-text -s :tab-select')
config.bind('<Space>mv', 'hint links spawn mpv {hint-url}') # mpv
config.bind('<u>', 'undo --window')
config.set("colors.webpage.darkmode.enabled", True)

opts = ' --username-target secret --username-pattern "user: (.+)"'
config.bind('<Space><p>', 'spawn --userscript qute-pass' + opts)
config.bind('<Space><P>', 'spawn --userscript qute-pass --unfiltered' + opts)

config.set('tabs.tabs_are_windows', True)
config.set('tabs.show', 'never')

# config.bind('<z><u><l>', 'spawn --userscript qute-pass --username-only')
# config.bind('<z><p><l>', 'spawn --userscript qute-pass --password-only')
# config.bind('<z><o><l>', 'spawn --userscript qute-pass --otp-only')
# catppuccin
# catppuccin.setup(c, 'mocha', True)

