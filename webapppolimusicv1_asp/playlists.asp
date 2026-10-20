<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Playlists y sus canciones (TBL_PLAYLIST)
'=====================================================================
Call PM_RequireLogin()

PM_Title = "Playlists"
PM_Page  = "playlists"

Dim strSQL, objRS, objSongs, sSQLSongs, nFila, sCover, sRuta, sArtistas

strSQL = "SELECT p.ID_PLAYLIST, p.TITLE, p.CREATION_DATE, p.[TYPE], p.PHOTO, " & _
         " ISNULL((SELECT TOP 1 c.VALUE FROM TBL_CATALOG c WHERE c.COD_CATALOG_PARENT = '2' " & _
         "        AND c.COD_CATALOG = CAST(p.[TYPE] AS varchar(8))), 'Publica') AS TYPE_LABEL " & _
         "FROM TBL_PLAYLIST p ORDER BY p.ID_PLAYLIST"
Set objRS = PM_Query(strSQL)
%>
<!--#include file="includes/header.asp"-->

<section class="pm-section">
    <div class="pm-section-head">
        <div>
            <h2>Playlists</h2>
            <p>Playlists almacenadas en TBL_PLAYLIST con las canciones de TBL_PLAYLIST_SONG.</p>
        </div>
    </div>

<% If objRS.EOF Then %>
    <div class="pm-empty">No existen playlists registradas.</div>
<%
Else
    Do While Not objRS.EOF
        sSQLSongs = "SELECT s.ID_SONG, s.SONG_NAME, s.SONG_PATH, ISNULL(s.PLAYS,0) AS PLAYS, " & _
                    " ISNULL(STUFF((SELECT ', ' + RTRIM(ar.ARTIST_NAME + ' ' + ISNULL(ar.ARTIST_LASTNAME,'')) " & _
                    "   FROM TBL_PLAYER pl INNER JOIN TBL_ARTIST ar ON ar.ID_ARTIST = pl.ID_ARTIST " & _
                    "   WHERE pl.ID_SONG = s.ID_SONG FOR XML PATH('')), 1, 2, ''), 'Artista desconocido') AS ARTISTS " & _
                    "FROM TBL_PLAYLIST_SONG ps INNER JOIN TBL_SONG s ON s.ID_SONG = ps.ID_SONG " & _
                    "WHERE ps.ID_PLAYLIST = " & CStr(objRS("ID_PLAYLIST")) & " ORDER BY s.ID_SONG"
        Set objSongs = PM_Query(sSQLSongs)
%>
    <div class="pm-panel" id="pl<%=objRS("ID_PLAYLIST")%>">
        <div class="pm-entity">
            <img src="<%=PM_Html(PM_Path(objRS("PHOTO")))%>" alt="Playlist">
            <div>
                <h3><%=PM_Html(objRS("TITLE"))%></h3>
                <p>Creada el <%=PM_Html(objRS("CREATION_DATE"))%> &middot;
                   <%=PM_If(CLng(objRS("TYPE")) = 1, "Privada", "Publica")%>
                   (<%=PM_Html(objRS("TYPE_LABEL"))%>)</p>
            </div>
        </div>

<%      If objSongs.EOF Then %>
        <div class="pm-empty">Esta playlist no tiene canciones asociadas.</div>
<%      Else
            nFila = 0
%>
        <div class="pm-songlist pm-list-compact">
            <div class="pm-songlist-head">
                <div>#</div><div>Cancion</div><div>Artista</div><div>Reprod.</div><div style="text-align:right">Audio</div>
            </div>
<%          Do While Not objSongs.EOF
                nFila  = nFila + 1
                sCover = PM_Cover(objSongs("ID_SONG"))
                sRuta  = PM_Path(objSongs("SONG_PATH"))
                sArtistas = CStr(objSongs("ARTISTS") & "")
%>
            <div class="pm-song-row"
                 data-id="<%=objSongs("ID_SONG")%>"
                 data-src="<%=PM_Html(sRuta)%>"
                 data-title="<%=PM_Html(objSongs("SONG_NAME"))%>"
                 data-artist="<%=PM_Html(sArtistas)%>"
                 data-album="<%=PM_Html(objRS("TITLE"))%>"
                 data-cover="<%=PM_Html(sCover)%>">
                <div class="pm-song-lead">
                    <div class="pm-song-index"><%=nFila%></div>
                    <button class="pm-song-play" type="button" title="Reproducir">
                        <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
                    </button>
                </div>
                <div class="pm-song-main">
                    <img class="pm-song-cover" src="<%=PM_Html(sCover)%>" alt="Portada">
                    <div class="pm-song-titles">
                        <strong><%=PM_Html(objSongs("SONG_NAME"))%></strong>
                        <span><%=PM_Html(sRuta)%></span>
                    </div>
                </div>
                <div class="pm-song-text"><%=PM_Html(sArtistas)%></div>
                <div class="pm-song-plays"><%=objSongs("PLAYS")%></div>
                <div class="pm-song-actions"><span class="pm-btn pm-btn-sm">Reproducir</span></div>
            </div>
<%              objSongs.MoveNext
            Loop %>
        </div>
<%      End If
        PM_Close objSongs
%>
    </div>
<%
        objRS.MoveNext
    Loop
End If
PM_Close objRS
%>
</section>

<!--#include file="includes/footer.asp"-->
