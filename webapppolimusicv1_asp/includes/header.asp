<%
'=====================================================================
'  POLIMUSIC - Cabecera comun (marca, navegacion, barra superior)
'  Variables que la pagina puede definir ANTES del include:
'     PM_Title  -> titulo de la pagina
'     PM_Page   -> clave de la opcion activa del menu
'     PM_Msg    -> texto de mensaje (aviso)
'     PM_MsgType-> "ok" | "error" | "warn"
'=====================================================================
If IsEmpty(PM_Title)   Or IsNull(PM_Title)   Then PM_Title = "PoliMusic"
If IsEmpty(PM_Page)    Or IsNull(PM_Page)    Then PM_Page  = ""
If IsEmpty(PM_Msg)     Or IsNull(PM_Msg)     Then PM_Msg   = ""
If IsEmpty(PM_MsgType) Or IsNull(PM_MsgType) Then PM_MsgType = "ok"

Function PM_Active(ByVal sClave)
    If CStr(PM_Page) = sClave Then PM_Active = " pm-active" Else PM_Active = ""
End Function
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="PoliMusic - reproductor de musica en linea (Classic ASP + VBScript)">
<title><%=PM_Html(PM_Title)%> &middot; PoliMusic</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body class="pm-body">

<aside class="pm-sidebar">
    <div class="pm-brand">
        <div class="pm-brand-mark">
            <svg viewBox="0 0 24 24"><path d="M12 3v10.55A4 4 0 1 0 14 17V7h4V3h-6z"/></svg>
        </div>
        <div class="pm-brand-text">
            <strong>PoliMusic</strong>
            <span>Web Player</span>
        </div>
    </div>

    <div class="pm-nav-group">
        <div class="pm-nav-label">Descubrir</div>
        <div class="pm-nav">
            <a href="index.asp" class="<%=Trim(PM_Active("home"))%>">
                <svg viewBox="0 0 24 24"><path d="M12 3 2 12h3v8h6v-6h2v6h6v-8h3z"/></svg> Inicio
            </a>
            <a href="songs.asp" class="<%=Trim(PM_Active("songs"))%>">
                <svg viewBox="0 0 24 24"><path d="M12 3v10.55A4 4 0 1 0 14 17V7h4V3h-6z"/></svg> Canciones
            </a>
            <a href="playlists.asp" class="<%=Trim(PM_Active("playlists"))%>">
                <svg viewBox="0 0 24 24"><path d="M3 6h12v2H3zm0 5h12v2H3zm0 5h8v2H3zm14-6 6 3-6 3z"/></svg> Playlists
            </a>
            <a href="albums.asp" class="<%=Trim(PM_Active("albums"))%>">
                <svg viewBox="0 0 24 24"><path d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm0 5a5 5 0 1 1 0 10 5 5 0 0 1 0-10zm0 3a2 2 0 1 0 0 4 2 2 0 0 0 0-4z"/></svg> Albumes
            </a>
        </div>
    </div>

<% If PM_IsAdmin() Then %>
    <div class="pm-nav-group">
        <div class="pm-nav-label">Administracion</div>
        <div class="pm-nav">
            <a href="admin_songs.asp" class="<%=Trim(PM_Active("admin_songs"))%>">
                <svg viewBox="0 0 24 24"><path d="M19.4 13a7.6 7.6 0 0 0 0-2l2-1.6-2-3.4-2.4 1a7.6 7.6 0 0 0-1.7-1L15 3H9l-.3 2a7.6 7.6 0 0 0-1.7 1l-2.4-1-2 3.4L4.6 11a7.6 7.6 0 0 0 0 2l-2 1.6 2 3.4 2.4-1c.5.4 1.1.8 1.7 1L9 21h6l.3-2c.6-.2 1.2-.6 1.7-1l2.4 1 2-3.4zM12 15.5a3.5 3.5 0 1 1 0-7 3.5 3.5 0 0 1 0 7z"/></svg>
                CRUD Canciones
            </a>
            <a href="admin_users.asp" class="<%=Trim(PM_Active("admin_users"))%>">
                <svg viewBox="0 0 24 24"><path d="M12 12a5 5 0 1 0 0-10 5 5 0 0 0 0 10zm0 2c-4 0-8 2-8 5v3h16v-3c0-3-4-5-8-5z"/></svg>
                CRUD Usuarios
            </a>
        </div>
    </div>
<% End If %>

    <div class="pm-side-card">
        <h4>Tu sesion</h4>
        <p>Conectado como <strong><%=PM_Html(PM_UserName())%></strong><br>
           Rol: <strong><%=PM_Html(PM_RoleLabel())%></strong></p>
    </div>
</aside>

<header class="pm-topbar">
    <div class="pm-search">
        <svg viewBox="0 0 24 24"><path d="M10 2a8 8 0 1 0 4.9 14.3l4.4 4.4 1.4-1.4-4.4-4.4A8 8 0 0 0 10 2zm0 2a6 6 0 1 1 0 12 6 6 0 0 1 0-12z"/></svg>
        <input type="text" id="pmSearch" placeholder="Buscar cancion, artista o album..." autocomplete="off">
    </div>

    <div class="pm-topbar-right">
        <span class="pm-role-badge <%=PM_If(PM_IsAdmin(),"pm-role-admin","pm-role-user")%>"><%=PM_Html(PM_RoleLabel())%></span>
        <div class="pm-user-chip">
            <img src="<%=PM_Html(PM_UserPhoto())%>" alt="Foto de <%=PM_Html(PM_UserName())%>">
            <div>
                <strong><%=PM_Html(PM_UserName())%></strong>
                <span>Sesion activa</span>
            </div>
        </div>
        <a class="pm-logout" href="logout.asp">
            <svg viewBox="0 0 24 24"><path d="M16 13v-2H7V8l-5 4 5 4v-3zM14 3h-4v2h4v14h-4v2h6a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2z"/></svg>
            Cerrar sesion
        </a>
    </div>
</header>

<main class="pm-main">
<% If PM_Msg <> "" Then %>
    <div class="pm-alert pm-alert-<%=PM_Html(PM_MsgType)%>"><%=PM_Html(PM_Msg)%></div>
<% End If %>
