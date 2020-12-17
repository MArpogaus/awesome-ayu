![](img/ayu.png)

> [ayu][] is a simple theme with bright colors and comes in three versions — dark, mirage and light for all day long comfortable work.

This theme has been inspired by the multicolor theme from [Awesome WM Copycats][awesome-copycats] and uses the gorgeous [ayu color palette][ayu-colors].

<!-- MarkdownTOC autolink="true" -->

- [Screenshoots](#screenshoots)
    - [dark](#dark)
    - [mirage](#mirage)
    - [light](#light)
- [Installation](#installation)
    - [Dependencies](#dependencies)
    - [Preconfigured awesome configuration](#preconfigured-awesome-configuration)
    - [Use theme with your custom configuration.](#use-theme-with-your-custom-configuration)
- [Configuration](#configuration)
    - [Widget Parameters](#widget-parameters)
- [Helper functions](#helper-functions)
- [License](#license)
- [Related projects](#related-projects)

<!-- /MarkdownTOC -->


# Screenshoots

## dark

![dark colors scheme](img/dark.png)

---

## mirage

![mirage colors scheme](img/mirage.png)

---

## light

![light colors scheme](img/light.png)


# Installation

## Dependencies

 * [awesome v4.3][awesome]
 * [vicious][vicious]
 * [owfont - symbol font for Open Weather Map API][owfont]
 * [Font Awesome 4][font-awesome4]
 * [mononoki][mononoki]

optional to switch colorschemes

 * [wpgtk][wpgtk]

## Preconfigured awesome configuration

My [awesome configuration][awesome-rc] uses this theme.
Follow the instruction in my [awesome-rc][awesome-rc] repo to use my setup as a starting point.

## Use theme with your custom configuration.

Follow these instruction to use my theme in your custom awesome configuration.

 1. Clone [vicious][vicious] and theme to `~/.config/awesome/`
    ```shell
    cd $HOME/.config/awesome
    mkdir themes
    git clone https://github.com/MArpogaus/awesome-ayu.git themes/ayu
    git clone https://github.com/vicious-widgets/vicious.git vicious
    ```

 1. Install [Font Awesome 4][font-awesome4] and [mononoki][mononoki]
    ```shell
    # Debian / Ubuntu
    apt install fonts-font-awesome fonts-mononoki
    # Manjaro
    pamac build ttf-font-awesome-4 ttf-mononoki
    ```
 
 1. Download and install [owfont][owfont]
    ```shell
    wget -O /usr/share/fonts/TTF/owfont-regular.ttf 'https://github.com/websygen/owfont/blob/master/fonts/owfont-regular.ttf?raw=true'
    ```

 1. Create your configuration file.
    ```shell
    cp themes/ayu/config.lua.template config.lua
    ```
 
 1. Load the theme in your `rc.lua`
    ```shell
    local chosen_theme= "ayu"
    beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
    awful.screen.connect_for_each_screen(beautiful.at_screen_connect)
    ```

 1. **Optional:** install [wpgtk][wpgtk] to switch colorschemes.
    [JSON colorschemes][json-colorschemes] and a `Rofi` template can be found in the `wpg` folder.
    ```shell
    # Install from Pip
    sudo pip3 install wpgtk
    # Install from AUR
    pamac build wpgtk-git
    
    # install colorschemes
    cd $HOME/.config/awesome/themes/ayu/img
    cs=light; wpg -a $cs.png; wpg -i $cs.png ../wpg/ayu_$cs.json
    cs=dark; wpg -a $cs.png; wpg -i $cs.png ../wpg/ayu_$cs.json
    cs=mirage; wpg -a $cs.png; wpg -i $cs.png ../wpg/ayu_$cs.json
    
    # install wpgtk templates for icons, gtk and rofi themes
    wpg-install.sh -gir

    # install modified rofi template
    cp $HOME/.config/awesome/themes/ayu/wpg/templates/rofi.base $HOME/.config/wpg/templates/rofi.base

    # restore on startup
    echo '$HOME/.config/wpg/wp_init.sh' > $HOME/.xprofile
    ```

# Configuration

The configuration file `config.lua` allows you to adjust the appearance of the theme to your needs.
The following table gives an overview of all configuration parameters:

| Name              | Description                             | Type             |
|:------------------|:----------------------------------------|:-----------------|
| `xresources`      | load colorschemes from xresources       | bool             |
| `color_scheme`    | colorscheme to use                      | string           |
| `dpi`             | number of pixels per inch of the screen | string           |
| `icon_theme`      | icon theme to use                       | string           |
| `wallpaper`       | path to your wallpaper                  | string           |
| `desktop_widgets` | enable/disable desktop widget           | bool             |
| `wibar_widgets`   | widgets for the wibar                   | array of strings |
| `arc_widgets`     | widgets for the the desktop pop up      | array of strings |
| `widgets_arg`     | widget parameters (see below)           | table            |


If parameters are unset the following defaults are used:

```lua
{
    -- Load colorschemes from xresources
    xresources = false,
    color_scheme = 'light',

    -- icon theme to use
    icon_theme = 'HighContrast',

    -- disable desktop widget
    desktop_widgets = true,

    -- widgets to be added to wibar
    wibar_widgets = {
        'net_down',
        'net_up',
        'vol',
        'mem',
        'cpu',
        'fs',
        'weather',
        'temp',
        'bat',
        'datetime'
    },

    -- widgets to be added to the desktop pop up
    arc_widgets = {'cpu', 'mem', 'fs', 'bat'}
}
```

## Widget Parameters

Some widgets (`weather`, `temp`, `net`) require additional configuration.
The parameters for each widget are stored in a table under the key `widgets_arg` in the configuration.

A example configuration is shown in the following listing:

```lua
{
    weather = {
        -- Your city for the weather widget
        city_id = '2643743',
        app_id = '4c57f0c88d9844630327623633ce269cf826ab99'
    },
    temp = {
        -- Set resource for temperature widget
        thermal_zone = 'thermal_zone0'
    },
    net = {
        -- Network interface
        net_interface = 'eth0'
    }
}
```

The following table gives an overview of all widget parameters:

| Name            | Description                                                                                                    | Type   |
|:----------------|:---------------------------------------------------------------------------------------------------------------|:-------|
| `city_id`       | open weather map id of your city. Find it here: https://openweathermap.org/find?q=                             | string |
| `app_id`        | open weather map API key. Sign up here: https://home.openweathermap.org/users/sign_up                          | string |
| `thermal_zone`  | resource for temperature widget: https://vicious.readthedocs.io/en/latest/widgets.html#vicious-widgets-thermal | string |
| `net_interface` | network interface to monitor: https://vicious.readthedocs.io/en/latest/widgets.html#vicious-widgets-net        | string |

# Helper functions

A set of helper functions is provided to toggle the colorscheme using key bindings.
This functionality is implemented in multiple steps:

 1. The awesome colorscheme is updated.
    This involves updating the theme colors and regenerating all widgets.
 2. [wpgtk][wpgtk] is used to update gtk and rofi themes.

    **Note:** remember to use `wpg-install.sh` to install the [wpk templates][wpk-templates] for gtk, icons and rofi
 3. sed is used to change the [sublime text colorscheme][ayu].

    **Note:** the settings file is expected to be found under `~/.config/sublime-text-3/Packages/User/Preferences.sublime-settings`
 4. [xsettingsd][xsettingsd] is used to change the icon theme.

**Warning:** This is optimized to work on my machine.
You might want to check the implementation to avoid any damage to your system.

To use these functions import the utilities packages

```lua
local util = require('themes.ayu.util')
```

and add the following key bindings to your `rc.lua`:

```lua
...
awful.key(
    {modkey, altkey, 'Control'}, 'l', util.set_light,
    {description = 'set light colorscheme', group = 'theme'}
), awful.key(
    {modkey, altkey, 'Control'}, 'm', util.set_mirage,
    {description = 'set mirage colorscheme', group = 'theme'}
), awful.key(
    {modkey, altkey, 'Control'}, 'd', util.set_dark,
    {description = 'set dark colorscheme', group = 'theme'}
)
...
```

# License

licensed under MIT License Copyright (c) 2020 Marcel Arpogaus. See [LICENSE](LICENSE) for further details.

# Related projects

- `ayu` for Ace: https://github.com/ayu-theme/ayu-ace
- `ayu` colors as NPM package: https://github.com/ayu-theme/ayu-colors
- `ayu` for VSCode: https://github.com/teabyii/vscode-ayu
- `ayu` for XCode: https://github.com/vburojevic/ayu-xcode-theme
- `ayu` for Sublime Text 3: https://github.com/dempfi/ayu

[ayu]: https://github.com/dempfi/ayu/blob/master/README.md
[awesome-copycats]: https://github.com/lcpz/awesome-copycats
[ayu-colors]: https://github.com/ayu-theme/ayu-colors
[awesome]: https://awesomewm.org/
[vicious]: https://github.com/vicious-widgets/vicious
[owfont]: http://websygen.github.io/owfont/
[font-awesome4]: https://github.com/FortAwesome/Font-Awesome
[mononoki]: https://madmalik.github.io/mononoki/
[wpgtk]: https://github.com/deviantfero/wpgtk
[json-colorschemes]: https://github.com/deviantfero/wpgtk/wiki/Colorschemes#import-a-colorscheme
[wpk-templates]: https://github.com/deviantfero/wpgtk-templates
[xsettingsd]: https://wiki.archlinux.org/index.php/Xsettingsd
[awesome-rc]: https://github.com/MArpogaus/awesome-rc
