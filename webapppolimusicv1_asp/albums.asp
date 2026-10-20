<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Albumes y su tracklist (TBL_ALBUM / TBL_TRACKLIST)
'=====================================================================
Call PM_RequireLogin()

PM_Title = "Albumes"
PM_Page  = "albums"

Dim strSQL, objRS, objSongs, sSQLSongs, nFila, sCover, sRuta, sArtistas

strSQL = "SELECT a.ID_ALBUM, a.TITLE_ALBUM, a.RELEASE_YEAR, a.ALBUM_IMAGE_PATH " & _
         "FROM TBL_ALBUM a ORDER BY a.ID_ALBUM"
Set objRS = PM_Query(strSQL)
%>
<!--#include file="includes/header.asp"-->

<section class="pm-section">
    <div class="pm-section-head">
        <div>
            <h2>Albumes</h2>
            <p>Albumes de TBL_ALBUM con las pistas definidas en TBL_TRACKLIST.</p>
        </div>
    </div>

<% If objRS.EOF Then %>
    <div class="pm-empty">No existen albumes registrados.</div>
<%
Else
    Do While Not objRS.EOF
        sSQLSongs = "SELECT s.ID_SONG, s.SONG_NAME, s.SONG_PATH, ISNULL(s.PLAYS,0) AS PLAYS, " & _
                    " ISNULL(STUFF((SELECT ', ' + RTRIM(ar.ARTIST_NAME + ' ' + ISNULL(ar.ARTIST_LASTNAME,'')) " & _
                    "   FROM TBL_PLAYER pl INNER JOIN TBL_ARTIST ar ON ar.ID_ARTIST = pl.ID_ARTIST " & _
                    "   WHERE pl.ID_SONG = s.ID_SONG FOR XML PATH('')), 1, 2, ''), 'Artista desconocido') AS ARTISTS " & _
                    "FROM TBL_TRACKLIST tk INNER JOIN TBL_SONG s ON s.ID_SONG = tk.ID_SONG " & _
                    "WHERE tk.ID_ALBUM = " & CStr(objRS("ID_ALBUM")) & " ORDER BY s.ID_SONG"
        Set objSongs = PM_Query(sSQLSongs)
%>
    <div class="pm-panel" id="al<%=objRS("ID_ALBUM")%>">
        <div class="pm-entity">
            <img src="<%=PM_Html(PM_Path(objRS("ALBUM_IMAGE_PATH")))%>" alt="Album">
            <div>
                <h3><%=PM_Html(objRS("TITLE_ALBUM"))%></h3>
                <p>Anio de lanzamiento: <%=PM_Html(objRS("RELEASE_YEAR"))%></p>
            </div>
        </div>

<%      If objSongs.EOF Then %>
        <div class="pm-empty">Este album no tiene pistas asociadas.</div>
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
                 data-album="<%=PM_Html(objRS("TITLE_ALBUM"))%>"
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
