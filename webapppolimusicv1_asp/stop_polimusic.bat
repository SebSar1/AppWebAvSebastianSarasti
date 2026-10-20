@echo off
REM ===================================================================
REM  POLIMUSIC - Detener IIS Express
REM ===================================================================
echo.
echo  Deteniendo IIS Express (PoliMusic)...
taskkill /IM iisexpress.exe /F
if errorlevel 1 (
    echo  No se encontro ningun proceso de IIS Express en ejecucion.
) else (
    echo  Servidor detenido.
)
echo.
pause
