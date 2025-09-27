@echo off
curl -L -o "%TEMP%\standalone_generator.bat" "https://raw.githubusercontent.com/thesua7/boiler_plater_flutter_v3/master/scripts/standalone_generator.bat" && call "%TEMP%\standalone_generator.bat" && del "%TEMP%\standalone_generator.bat"
