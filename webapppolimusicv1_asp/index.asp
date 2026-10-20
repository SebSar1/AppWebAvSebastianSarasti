<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<!--#include file="includes/songlist.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Pagina principal del reproductor
'  Muestra el mensaje de bienvenida (variable de sesion), el listado
'  de canciones (Song List), playlists y albumes.
'=====================================================================
Call PM_RequireLogin()

PM_Title = "Inicio"
PM_Page  = "home"

If Request.QueryString("msg") = "denied" Then
    PM_Msg     = "Acceso denegado: solo el usuario administrador puede usar las opciones CRUD."
    PM_MsgType = "error"
End If

'--- Estadisticas ------------------------------------------------------
Dim objRS, nCanciones, nPlaylists, nAlbumes
nCanciones = 0 : nPlaylists = 0 : nAlbumes = 0

Set objRS = PM_Query("SELECT COUNT(*) AS N FROM TBL_SONG")
If Not objRS.EOF Then nCanciones = CLng(objRS("N"))
PM_Close objRS

Set objRS = PM_Query("SELECT COUNT(*) AS N FROM TBL_PLAYLIST")
If Not objRS.EOF Then nPlaylists = CLng(objRS("N"))
PM_Close objRS

Set objRS = PM_Query("SELECT COUNT(*) AS N FROM TBL_ALBUM")
If Not objRS.EOF Then nAlbumes = CLng(objRS("N"))
PM_Close objRS
%>
<!--#include file="includes/header.asp"-->

<section class="pm-hero">
    <div class="pm-hero-eyebrow">Sesion iniciada &middot; <%=PM_Html(PM_RoleLabel())%></div>
    <h1>¡Bienvenido, <em><%=PM_Html(Session("pm_username"))%></em>!</h1>
    <p>
        Hola <strong><%=PM_Html(Session("pm_username"))%></strong>, nos alegra tenerte de vuelta en PoliMusic.
        Tu sesion se encuentra activa<% If Session("pm_loginAt") <> "" Then %> desde el
        <%=PM_Html(Session("pm_loginAt"))%><% End If %> y tu rol actual es
        <strong><%=PM_Html(PM_RoleLabel())%></strong>.
<% If PM_IsAdmin() Then %>
        Como administrador puedes crear, editar y eliminar canciones y usuarios desde el panel CRUD.
<% Else %>
        Disfruta del catalogo: selecciona cualquier cancion para reproducirla en el reproductor inferior.
<% End If %>
    </p>
    <div class="pm-hero-stats">
        <div class="pm-hero-stat"><strong><%=nCanciones%></strong><span>Canciones</span></div>
        <div class="pm-hero-stat"><strong><%=nPlaylists%></strong><span>Playlists</span></div>
        <div class="pm-hero-stat"><strong><%=nAlbumes%></strong><span>Albumes</span></div>
        <div class="pm-hero-stat"><strong><%=PM_Html(Session("pm_email"))%></strong><span>Correo</span></div>
    </div>
</section>

<% If PM_IsAdmin() Then %>
<div class="pm-panel">
    <h2>Panel de administracion</h2>
    <p class="pm-sub">Opciones disponibles unicamente para el rol <strong>ADMIN</strong>.</p>
    <div class="pm-form-actions" style="margin-top:0">
        <a class="pm-btn pm-btn-primary" href="admin_songs.asp">CRUD de canciones</a>
        <a class="pm-btn pm-btn-blue" href="admin_users.asp">CRUD de usuarios</a>
    </div>
</div>
<% End If %>

<section class="pm-section">
    <div class="pm-section-head">
        <div>
            <h2>Song List</h2>
            <p>A continuacion se presenta el listado de canciones disponibles en PoliMusic. Haz clic en una cancion para reproducirla.</p>
        </div>
        <a class="pm-btn" href="songs.asp">Ver listado completo</a>
    </div>
    <% Call PM_RenderSongList(False) %>
</section>

<section class="pm-section" id="playlists">
    <div class="pm-section-head">
        <div>
            <h2>Playlists destacadas</h2>
            <p>Playlists registradas en la base de datos para el usuario <%=PM_Html(Session("pm_username"))%>.</p>
        </div>
    </div>
<%
Dim strSQLPlaylists
strSQLPlaylists = "SELECT p.ID_PLAYLIST, p.TITLE, p.CREATION_DATE, p.TYPE, p.PHOTO, " & _
                  " ISNULL((SELECT COUNT(*) FROM TBL_PLAYLIST_SONG ps WHERE ps.ID_PLAYLIST = p.ID_PLAYLIST),0) AS N_SONGS, " & _
                  " ISNULL((SELECT TOP 1 c.VALUE FROM TBL_CATALOG c WHERE c.COD_CATALOG_PARENT = '2' " & _
                  "         AND c.COD_CATALOG = CAST(p.[TYPE] AS varchar(8))), 'Publica') AS TYPE_LABEL " & _
                  "FROM TBL_PLAYLIST p ORDER BY p.ID_PLAYLIST"
Set objRS = PM_Query(strSQLPlaylists)
If objRS.EOF Then
%>
    <div class="pm-empty">No existen playlists registradas.</div>
<%
Else
%>
    <div class="pm-card-grid">
<%
    Do While Not objRS.EOF
%>
        <a class="pm-card" href="playlists.asp#pl<%=objRS("ID_PLAYLIST")%>">
            <img src="<%=PM_Html(PM_Path(objRS("PHOTO")))%>" alt="Playlist <%=PM_Html(objRS("TITLE"))%>">
            <strong><%=PM_Html(objRS("TITLE"))%></strong>
            <span><%=objRS("N_SONGS")%> canciones &middot; <%=PM_Html(objRS("CREATION_DATE"))%></span>
            <span class="pm-tag <%=PM_If(CLng(objRS("TYPE")) = 1, "pm-tag-private", "pm-tag-public")%>"><%=PM_Html(objRS("TYPE_LABEL"))%></span>
        </a>
<%
        objRS.MoveNext
    Loop
%>
    </div>
<%
End If
PM_Close objRS
%>
</section>

<section class="pm-section" id="albums">
    <div class="pm-section-head">
        <div>
            <h2>Albumes</h2>
            <p>Catalogo de albumes y su cantidad de pistas.</p>
        </div>
    </div>
<%
Dim strSQLAlbums
strSQLAlbums = "SELECT a.ID_ALBUM, a.TITLE_ALBUM, a.RELEASE_YEAR, a.ALBUM_IMAGE_PATH, " & _
               " ISNULL((SELECT COUNT(*) FROM TBL_TRACKLIST t WHERE t.ID_ALBUM = a.ID_ALBUM),0) AS N_SONGS " & _
               "FROM TBL_ALBUM a ORDER BY a.ID_ALBUM"
Set objRS = PM_Query(strSQLAlbums)
If objRS.EOF Then
%>
    <div class="pm-empty">No existen albumes registrados.</div>
<%
Else
%>
    <div class="pm-card-grid">
<%
    Do While Not objRS.EOF
%>
        <a class="pm-card" href="albums.asp#al<%=objRS("ID_ALBUM")%>">
            <img src="<%=PM_Html(PM_Path(objRS("ALBUM_IMAGE_PATH")))%>" alt="Album <%=PM_Html(objRS("TITLE_ALBUM"))%>">
            <strong><%=PM_Html(objRS("TITLE_ALBUM"))%></strong>
            <span><%=objRS("N_SONGS")%> pistas &middot; <%=PM_Html(objRS("RELEASE_YEAR"))%></span>
        </a>
<%
        objRS.MoveNext
    Loop
%>
    </div>
<%
End If
PM_Close objRS
%>
</section>

<!--#include file="includes/footer.asp"-->
