@echo off
REM ===================================================================
REM  POLIMUSIC - Iniciar el sitio (ASP clasico) con IIS Express
REM  Doble clic sobre este archivo o ejecutarlo desde CMD.
REM  El servidor se abre en una ventana nueva; esa ventana muestra el log.
REM ===================================================================
setlocal
set PORT=8099
set IISEXPRESS=C:\Program Files\IIS Express\iisexpress.exe
set PROJECT=%~dp0
if "%PROJECT:~-1%"=="\" set PROJECT=%PROJECT:~0,-1%

echo.
echo  ============================================
echo   POLIMUSIC - ASP Clasico + VBScript
echo  ============================================
echo   Carpeta : %PROJECT%
echo   Puerto  : %PORT%
echo   URL     : http://localhost:%PORT%/login.asp
echo.

if not exist "%IISEXPRESS%" (
    echo  [ERROR] No se encontro IIS Express en:
    echo          %IISEXPRESS%
    echo          Instala "IIS Express" o usa el IIS completo
    echo          ^(inetmgr ^) creando un sitio apuntando a esta carpeta.
    echo.
    pause
    exit /b 1
)

start "PoliMusic - IIS Express (no cerrar)" "%IISEXPRESS%" /path:"%PROJECT%" /port:%PORT%
timeout /t 3 /nobreak >nul
start "" http://localhost:%PORT%/login.asp

echo.
echo   Servidor en ejecucion.
echo   Para DETENERLO:
echo      a) Ctrl+C dentro de la ventana "PoliMusic - IIS Express" ^(responde S^), o
echo      b) ejecuta stop_polimusic.bat, o
echo      c) desde otra ventana CMD:  taskkill /IM iisexpress.exe /F
echo.
echo   Usuarios:  userAdmin / 12345678   ^(admin^)
echo              userNormal / 12345678  ^(normal^)
echo.
endlocal
