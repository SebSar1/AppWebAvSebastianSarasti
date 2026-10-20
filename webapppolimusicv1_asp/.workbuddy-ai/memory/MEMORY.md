# MEMORIA DEL PROYECTO - webapppolimusicv1_asp

## Contexto
Clon de YouTube Music en **ASP clásico + VBScript** (NO ASP.NET / C#), páginas con extensión `.asp`.
Base de datos: `BDD_PoliMusic` en SQL Server (localhost, puerto 1433), usuario `usr_polimusic`.
Regla del proyecto: **no crear tablas nuevas**, solo usar las del script `BDD_PoliMusic.sql`.

## Convenciones del código
- Toda página empieza con `<%@ Language="VBScript" CodePage="65001" %>` y incluye
  `includes/bootstrap.asp` (conexión + seguridad + UTF-8), y luego `includes/header.asp` /
  `includes/footer.asp`.
- Variables de sesión: `pm_idUser`, `pm_username`, `pm_email`, `pm_userType`, `pm_userPhoto`,
  `pm_loginAt` (se guardan en login.asp).
- Roles: `USER_TYPE` 0 = usuario normal, 1 = administrador. Solo admin accede a `admin_*.asp`
  (`PM_RequireAdmin`).
- Helpers en `includes/connection.asp`: `PM_Query`, `PM_Execute`, `PM_SQL`, `PM_Num`, `PM_Path`,
  `PM_Html`, `PM_Cover`, `PM_If`, `PM_Param`.
- **No usar `IIf`** (provoca Type mismatch en VBScript) → usar `PM_If`.
- **No usar `Option Explicit`**; las `Const` deben ser literales de una sola línea.
- Estilos en `css/style.css` (paleta azul #2E6BFF + rojo #FF2E4D sobre azul noche) y lógica en
  `js/app.js` (reproductor: cola, next/prev, progreso, volumen, contador de plays).

## Usuarios de prueba
- `userAdmin` / `12345678`  (admin)
- `userNormal` / `12345678` (normal)

## Cómo ejecutar
IIS Express: `"C:\Program Files\IIS Express\iisexpress.exe" /path:"<raíz del proyecto>" /port:8099`
(o crear un sitio/aplicación en el IIS local con ASP clásico habilitado).
Atajos en la raíz del proyecto: `start_polimusic.bat` (arranca y abre el navegador) y
`stop_polimusic.bat` (detiene: `taskkill /IM iisexpress.exe /F`). Puerto por defecto: 8099.
