<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Pantalla de login
'  Valida contra TBL_USER y guarda los datos en variables de sesion.
'  USER_TYPE:  0 = usuario normal   1 = administrador
'=====================================================================

' Si ya existe una sesion activa, entra directamente al reproductor
If Session("pm_idUser") <> "" And Session("pm_username") <> "" Then
    Response.Redirect("index.asp")
End If

Dim sError, sAviso, sUsuario
sError   = ""
sAviso   = ""
sUsuario = ""

Select Case Request.QueryString("msg")
    Case "required" : sAviso = "Debe iniciar sesion para acceder al reproductor."
    Case "logout"   : sAviso = "Su sesion se ha cerrado correctamente. Hasta pronto."
    Case "denied"   : sError = "No tiene permisos de administrador para esa opcion."
End Select

'---------------------------------------------------------------------
' Procesamiento del formulario (POST sobre la misma pagina)
'---------------------------------------------------------------------
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then

    sUsuario = Trim(Request.Form("txtUsuario") & "")
    Dim sPassword
    sPassword = Trim(Request.Form("txtPassword") & "")

    If sUsuario = "" Or sPassword = "" Then
        sError = "Debe ingresar el usuario y la contrasena."
    Else
        Dim objRS, strSQL
        strSQL = "SELECT ID_USER, USERNAME, EMAIL, USER_PHOTO, USER_TYPE " & _
                 "FROM TBL_USER " & _
                 "WHERE USERNAME = '" & PM_SQL(sUsuario) & "' " & _
                 "  AND PASSWORD = '" & PM_SQL(sPassword) & "'"
        Set objRS = PM_Query(strSQL)

        If objRS.EOF Then
            sError = "Usuario o contrasena incorrectos. Intente nuevamente."
        Else
            '---- Se guardan los datos en variables de sesion ----
            Session("pm_idUser")    = CStr(objRS("ID_USER"))
            Session("pm_username")  = CStr(objRS("USERNAME"))
            Session("pm_email")     = CStr(objRS("EMAIL") & "")
            Session("pm_userType")  = CStr(objRS("USER_TYPE"))
            Session("pm_userPhoto") = CStr(objRS("USER_PHOTO") & "")
            Session("pm_loginAt")   = Now()
            PM_Close objRS
            Response.Redirect("index.asp")
        End If
        PM_Close objRS
    End If
End If
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Iniciar sesion &middot; PoliMusic</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body class="pm-body">

<div class="pm-login-wrap">
    <div class="pm-login-card">

        <div class="pm-login-art">
            <div>
                <div class="pm-login-badge">
                    <svg viewBox="0 0 24 24" style="width:16px;height:16px;fill:#FF6B80"><path d="M12 3v10.55A4 4 0 1 0 14 17V7h4V3h-6z"/></svg>
                    PoliMusic Web Player
                </div>
                <h1>Tu musica,<br>en azul y rojo.</h1>
                <p>Un reproductor web construido con HTML, CSS, JavaScript y ASP clasico (VBScript) sobre SQL Server.</p>
                <ul>
                    <li><svg viewBox="0 0 24 24"><path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/></svg> Catalogo de canciones con reproductor integrado</li>
                    <li><svg viewBox="0 0 24 24"><path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/></svg> Playlists y albumes desde la base de datos</li>
                    <li><svg viewBox="0 0 24 24"><path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/></svg> Panel CRUD exclusivo para administradores</li>
                </ul>
            </div>
            <div style="font-size:12px;color:#A8B3D6">Escuela Politecnica Nacional &middot; Proyecto Web ASP</div>
        </div>

        <div class="pm-login-form">
            <h2>Iniciar sesion</h2>
            <p>Ingrese sus credenciales para acceder al listado de canciones.</p>

<% If sError <> "" Then %>
            <div class="pm-alert pm-alert-error"><%=PM_Html(sError)%></div>
<% End If %>
<% If sAviso <> "" Then %>
            <div class="pm-alert pm-alert-warn"><%=PM_Html(sAviso)%></div>
<% End If %>

            <form method="post" action="login.asp" autocomplete="off">
                <div class="pm-field">
                    <label for="txtUsuario">Usuario</label>
                    <input type="text" id="txtUsuario" name="txtUsuario" value="<%=PM_Html(sUsuario)%>" placeholder="ej. userAdmin" required>
                </div>
                <div class="pm-field">
                    <label for="txtPassword">Contrasena</label>
                    <input type="password" id="txtPassword" name="txtPassword" placeholder="********" required>
                </div>
                <div class="pm-form-actions" style="margin-top:22px">
                    <button class="pm-btn pm-btn-primary" type="submit" style="flex:1 1 auto;justify-content:center;padding:13px">
                        Entrar a PoliMusic
                    </button>
                </div>
            </form>

            <div class="pm-login-hint">
                <strong>Usuarios de prueba (creados por el script de BD):</strong><br>
                Administrador &rarr; <code>userAdmin</code> / <code>12345678</code><br>
                Usuario normal &rarr; <code>userNormal</code> / <code>12345678</code>
            </div>
        </div>

    </div>
</div>

</body>
</html>
