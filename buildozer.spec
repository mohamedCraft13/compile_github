[app]
title = Iot Control
package.name = iotcontrol
package.domain = com.iotcontrol
source.dir = .
source.include_exts = py,png,jpg,kv,atlas
version = 1.1
requirements = python3,kivy==2.3.0,kivymd,pillow,paho-mqtt,plyer
orientation = portrait
osx.python_version = 3
osx.kivy_version = 1.9.1
fullscreen = 0
android.permissions = INTERNET
android.api = 34
android.minapi = 21
android.archs = armeabi-v7a, arm64-v8a
android.allow_backup = True

[buildozer]
log_level = 2
warn_on_root = 1
