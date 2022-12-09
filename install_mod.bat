@echo off

set thisPath=%~dp0%\
set modPath=%UserProfile%\AppData\LocalLow\BlackSeaGames\Sovereign\Saves\Mods\No Resource Boosts\
set gamePath=

:: YOU CAN MANUALLY SET THE GAMES PATH HERE! REMOVE THE TWO COLONS (::) BEFORE THE NEXT LINE TO USE IT
:: set gamePath=S:\SteamLibrary\steamapps\common\Knights of Honor II\

if not "%gamePath%" == "" (
  echo The "gamePath"-variable was manually set! Using: %gamePath%!
) else (
  echo The "gamePath"-variable was not set manually!
  echo Starting: Automatic search for game path

  for /f "Tokens=1,2*" %%A in ('Reg Query HKCU\SOFTWARE\Valve\Steam') do (
    if "%%A" equ "SteamPath" (
      set gamePath=%%C
    )
  )
)

set gamePath=%gamePath%\steamapps\common\Knights of Honor II\
set gamePathWithoutDrive=:\SteamLibrary\steamapps\common\Knights of Honor II\

:: TODO SEARCH IN "SteamLibrary"
if not exist "%gamePath%" (
  for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%i%gamePathWithoutDrive%" (
      set gamePath=%%i%gamePathWithoutDrive%
    )
  )
)

echo Finished: Automatic search for game path
echo Found "gamePath": %gamePath%

:: IF THE %gamePath% IS NOT A VALID DIRECTORY, WE WERE NOT ABLE TO FIND IT AUTOMATICALLY
if not exist "%gamePath%" (
  echo ERROR: The "gamePath"-variable was not found!
  echo ERROR: Please set the game path manually by editing this script.
  echo ERROR: Installation failed!
  pause
  exit
)

echo Starting: Preparing mod folder

if exist "%modPath%" (
  echo Deleting existing mod folder
  rmdir /s /q "%modPath%"
)

echo Creating mod folder
md "%modPath%"
md "%modPath%Defs"
md "%modPath%Maps"
md "%modPath%Texts"

echo Copying moddable files into mod folder

robocopy /e /NFL /NDL /NJH /NJS /nc /ns /np "%gamePath%Defs" "%modPath%Defs"
robocopy /e /NFL /NDL /NJH /NJS /nc /ns /np "%gamePath%Maps" "%modPath%Maps"
robocopy /e /NFL /NDL /NJH /NJS /nc /ns /np "%gamePath%Texts" "%modPath%Texts"

echo Finished: Preparing mod folder
echo Starting: Copying mod files into prepared mod folder

if exist "%thisPath%Defs" (
  robocopy /e /NFL /NDL /NJH /NJS /nc /ns /np "%thisPath%Defs" "%modPath%Defs"
)
if exist "%~dp0%Maps" (
  robocopy /e /NFL /NDL /NJH /NJS /nc /ns /np "%thisPath%Maps" "%modPath%Maps"
)
if exist "%~dp0%Texts" (
  robocopy /e /NFL /NDL /NJH /NJS /nc /ns /np "%thisPath%Texts" "%modPath%Texts"
)

echo Finished: Copying mod files into prepared mod folder
echo Mod installation finished. Enjoy!

pause
