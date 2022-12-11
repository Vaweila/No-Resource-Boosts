@echo off

set thisPath=%~dp0%\
set modPath=%UserProfile%\AppData\LocalLow\BlackSeaGames\Sovereign\Saves\Mods\No Resource Boosts\
set externalSteamGamePathWithoutDrive=:\SteamLibrary\steamapps\common\Knights of Honor II\
set gamePath=

:: YOU CAN MANUALLY SET THE GAMES PATH HERE!
:: REMOVE THE TWO COLONS (::) BEFORE THE NEXT LINE TO MANUALLY SET THE GAME PATH
::set gamePath=S:\SteamLibrary\steamapps\common\Knights of Honor II\

:: IF THE PATH TO THE GAME WAS NOT MANUALLY SET, WE'LL SEARCH FOR IT
if not "%gamePath%" == "" (
  echo The "gamePath"-variable was manually set!
  echo Using: %gamePath%!
) else (
  echo Starting: Automatic search for game path

  :: WE LOOK INTO THE REGISTRY TO FIND OUT WHERE ON THE SYSTEM STEAM IS INSTALLED
  for /f "Tokens=1,2*" %%A in ('Reg Query HKCU\SOFTWARE\Valve\Steam') do (
    if "%%A" equ "SteamPath" (
	  if exist "%%C\steamapps\common\Knights of Honor II\" (
        set gamePath=%%C\steamapps\common\Knights of Honor II\
	  ) else (
	    :: IF THE GAME IS NOT IN THE MAIN STEAM FOLDER WE WILL LOOK ON ALL DRIVES TO FIND A FOLDER CALLED 'STEAMLIBRARY'
		:: 'STEAMLIBRARY' IS THE DEFAULT WAY STEAM CALLS ITS GAME FOLDERS WHICH ARE ON DIFFERENT HARD DRIVES
	    for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
          if exist "%%i%externalSteamGamePathWithoutDrive%" (
            set gamePath=%%i%externalSteamGamePathWithoutDrive%
          )
        )
	  )
    )
  )
  
  echo Finished: Automatic search for game path
)

:: IF THE %gamePath% IS NOT A VALID DIRECTORY, WE WERE NOT ABLE TO FIND IT AUTOMATICALLY
:: WE HAVE TO EXIT THE INSTALLATION AND TELL THE USER THAT HE HAS TO MANUALLY ENTER THE GAME PATH
if not exist "%gamePath%" (
  echo ERROR: The "gamePath"-variable was not found!
  echo ERROR: Please set the game path manually by editing this script.
  echo ERROR: Installation failed!
  pause
  exit
) else (
  echo Detected game at: "%gamePath%"
)

echo Starting: Preparing mod folder

:: IF THE MOD ALREADY EXISTS, WE DELETE THE FOLDER WITH EVERYTHING INSIDE IT
if exist "%modPath%" (
  echo Deleting existing mod folder
  rmdir /s /q "%modPath%"
)

:: CREATING THE EMPTY FOLDERS FOR THE MOD
echo Creating mod folder
md "%modPath%"
md "%modPath%Defs"
md "%modPath%Maps"
md "%modPath%Texts"

echo Copying moddable files into mod folder

:: COPYING ALL THE FILES FROM THE GAME PATH INTO THE MOD FOLDER
robocopy /e /NFL /NDL /NJH /NJS /nc /ns /np "%gamePath%Defs" "%modPath%Defs"
robocopy /e /NFL /NDL /NJH /NJS /nc /ns /np "%gamePath%Maps" "%modPath%Maps"
robocopy /e /NFL /NDL /NJH /NJS /nc /ns /np "%gamePath%Texts" "%modPath%Texts"

echo Finished: Preparing mod folder
echo Starting: Copying mod files into prepared mod folder

:: FOR EVERY FOLDER THE MOD HAS FROM 'Defs', 'Maps' AND 'Texts', WE OVERWRITE THE DEFAULT GAME FILES WITH OUR MOD FILES
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
