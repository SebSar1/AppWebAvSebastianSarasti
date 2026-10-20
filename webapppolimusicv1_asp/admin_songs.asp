<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - CRUD de canciones (SOLO administrador)
'  Tabla: TBL_SONG
'=====================================================================
Call PM_RequireAdmin()

PM_Title = "CRUD Canciones"
PM_Page  = "admin_songs"

Select Case Request.QueryString("msg")
    Case "saved"   : PM_Msg = "La cancion se guardo correctamente." : PM_MsgType = "ok"
    Case "deleted" : PM_Msg = "La cancion se elimino correctamente." : PM_MsgType = "ok"
    Case "error"   : PM_Msg = "No fue posible completar la operacion solicitada." : PM_MsgType = "error"
End Select

Dim strSQL, objRS, objTmp, nTotal
nTotal = 0
Set objTmp = PM_Query("SELECT COUNT(*) AS N FROM TBL_SONG")
If Not objTmp.EOF Then nTotal = CLng(objTmp("N"))
PM_Close objTmp

strSQL = "SELECT s.ID_SONG, s.SONG_NAME, s.SONG_PATH, ISNULL(s.PLAYS,0) AS PLAYS, " & _
         " ISNULL(STUFF((SELECT ', ' + RTRIM(ar.ARTIST_NAME + ' ' + ISNULL(ar.ARTIST_LASTNAME,'')) " & _
         "   FROM TBL_PLAYER pl INNER JOIN TBL_ARTIST ar ON ar.ID_ARTIST = pl.ID_ARTIST " & _
         "   WHERE pl.ID_SONG = s.ID_SONG FOR XML PATH('')), 1, 2, ''), '-') AS ARTISTS, " & _
         " ISNULL(STUFF((SELECT ', ' + al.TITLE_ALBUM " & _
         "   FROM TBL_TRACKLIST tk INNER JOIN TBL_ALBUM al ON al.ID_ALBUM = tk.ID_ALBUM " & _
         "   WHERE tk.ID_SONG = s.ID_SONG FOR XML PATH('')), 1, 2, ''), '-') AS ALBUMS " & _
         "FROM TBL_SONG s ORDER BY s.ID_SONG"
Set objRS = PM_Query(strSQL)
%>
<!--#include file="includes/header.asp"-->

<section class="pm-hero" style="padding:26px 32px">
    <div class="pm-hero-eyebrow">Administracion &middot; <%=PM_Html(PM_UserName())%></div>
    <h1 style="font-size:28px">CRUD de <em>canciones</em></h1>
    <p>Desde aqui puedes crear, editar y eliminar canciones del catalogo. Estas opciones solo estan disponibles para el rol ADMIN.</p>
</section>

<div class="pm-panel">
    <h2>Canciones registradas</h2>
    <p class="pm-sub">Tabla <strong>TBL_SONG</strong> &middot; <%=nTotal%> registro(s).</p>

    <div class="pm-form-actions" style="margin:0 0 18px 0">
        <a class="pm-btn pm-btn-primary" href="admin_song_form.asp">+ Nueva cancion</a>
        <a class="pm-btn" href="songs.asp">Ver listado publico</a>
    </div>

<% If objRS.EOF Then %>
    <div class="pm-empty">No hay canciones registradas. Utilice el boton "Nueva cancion".</div>
<% Else %>
    <table class="pm-table">
        <thead>
            <tr>
                <th style="width:60px">#</th>
                <th style="width:70px"></th>
                <th>Nombre</th>
                <th>Ruta del archivo</th>
                <th>Artista(s)</th>
                <th>Album(es)</th>
                <th style="width:80px">Plays</th>
                <th style="width:190px;text-align:right">Acciones</th>
            </tr>
        </thead>
        <tbody>
<%
    Dim nFila
    nFila = 0
    Do While Not objRS.EOF
        nFila = nFila + 1
%>
            <tr>
                <td><%=nFila%></td>
                <td><img src="<%=PM_Html(PM_Cover(objRS("ID_SONG")))%>" alt="" style="width:46px;height:46px;border-radius:10px;object-fit:cover"></td>
                <td><strong><%=PM_Html(objRS("SONG_NAME"))%></strong></td>
                <td style="color:var(--pm-muted-2)"><%=PM_Html(PM_Path(objRS("SONG_PATH")))%></td>
                <td><%=PM_Html(objRS("ARTISTS"))%></td>
                <td><%=PM_Html(objRS("ALBUMS"))%></td>
                <td><%=objRS("PLAYS")%></td>
                <td>
                    <div class="pm-row-actions">
                        <a class="pm-btn pm-btn-blue pm-btn-sm" href="admin_song_form.asp?id=<%=objRS("ID_SONG")%>">Editar</a>
                        <a class="pm-btn pm-btn-danger pm-btn-sm" href="admin_song_delete.asp?id=<%=objRS("ID_SONG")%>&confirm=1"
                           data-confirm="¿Eliminar la cancion '<%=PM_Html(objRS("SONG_NAME"))%>'? Se borraran tambien sus referencias en tracklist, player y playlists.">Eliminar</a>
                    </div>
                </td>
            </tr>
<%
        objRS.MoveNext
    Loop
%>
        </tbody>
    </table>
<% End If %>
</div>

<div class="pm-panel">
    <h2>Archivos de audio disponibles</h2>
    <p class="pm-sub">Coloca los archivos .mp3 en la carpeta <strong>songFiles</strong> y registra la ruta en la base de datos.</p>
    <table class="pm-table">
        <thead><tr><th>Archivo</th><th style="width:220px">Ruta a registrar en SONG_PATH</th></tr></thead>
        <tbody>
<%
Dim objFile, objFSO, sCarpeta
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
sCarpeta = Server.MapPath("songFiles")
If objFSO.FolderExists(sCarpeta) Then
    For Each objFile In objFSO.GetFolder(sCarpeta).Files
        If LCase(objFSO.GetExtensionName(objFile.Name)) = "mp3" Then
%>
            <tr>
                <td><%=PM_Html(objFile.Name)%></td>
                <td><code style="color:var(--pm-blue-soft)">~/songFiles/<%=PM_Html(objFile.Name)%></code></td>
            </tr>
<%
        End If
    Next
End If
Set objFSO = Nothing
%>
        </tbody>
    </table>
</div>

<!--#include file="includes/footer.asp"-->
