# rofi-xfce4-display-profile-chooser

rofi script to switch between xfce4 display profiles.

![image](https://github.com/airtonix/rofi-xfce4-display-profile-chooser/assets/61225/8a1115e8-5973-470b-b06c-64b218c5739a)

## Requires

- xfce4-display-settings
- xfconf-query
- rofi

## Install

1. copy the `rofi-xfce4-display-profile-chooser.bash` somewhere useful (ie `~/bin/rofi-xfce4-display-profile-chooser.bash` )
2. chmod +x `~/bin/rofi-xfce4-display-profile-chooser.bash`
3. `PREFIX="switch display" rofi -show  "$PREFIX" -modes "PREFIX:~/bin/rofi-xfce4-display-profile-chooser.bash"`
