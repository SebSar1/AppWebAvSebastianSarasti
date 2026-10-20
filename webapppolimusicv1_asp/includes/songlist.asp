<%
'=====================================================================
'  POLIMUSIC - Componente reutilizable: listado de canciones
'  Uso:  Call PM_RenderSongList(True)   ' True = muestra botones de CRUD
'=====================================================================

Sub PM_RenderSongList(ByVal bConAcciones)

    Dim strSQL, objRS, nFila, sCover, sArtistas, sAlbumes, sRuta

    strSQL = "SELECT s.ID_SONG, s.SONG_NAME, s.SONG_PATH, ISNULL(s.PLAYS,0) AS PLAYS, " & _
             " (SELECT TOP 1 al.ALBUM_IMAGE_PATH FROM TBL_TRACKLIST tk " & _
             "  INNER JOIN TBL_ALBUM al ON al.ID_ALBUM = tk.ID_ALBUM WHERE tk.ID_SONG = s.ID_SONG) AS ALBUM_IMAGE, " & _
             " ISNULL(STUFF((SELECT ', ' + RTRIM(ar.ARTIST_NAME + ' ' + ISNULL(ar.ARTIST_LASTNAME,'')) " & _
             "   FROM TBL_PLAYER pl INNER JOIN TBL_ARTIST ar ON ar.ID_ARTIST = pl.ID_ARTIST " & _
             "   WHERE pl.ID_SONG = s.ID_SONG FOR XML PATH('')), 1, 2, ''), 'Artista desconocido') AS ARTISTS, " & _
             " ISNULL(STUFF((SELECT ', ' + al2.TITLE_ALBUM " & _
             "   FROM TBL_TRACKLIST tk2 INNER JOIN TBL_ALBUM al2 ON al2.ID_ALBUM = tk2.ID_ALBUM " & _
             "   WHERE tk2.ID_SONG = s.ID_SONG FOR XML PATH('')), 1, 2, ''), 'Single') AS ALBUMS " & _
             "FROM TBL_SONG s ORDER BY s.ID_SONG"

    Set objRS = PM_Query(strSQL)

    If objRS.EOF Then
%>
    <div class="pm-empty">Todavia no hay canciones registradas en la base de datos.</div>
<%
    Else
        nFila = 0
%>
    <div class="pm-songlist">
        <div class="pm-songlist-head">
            <div>#</div>
            <div>Cancion</div>
            <div>Artista</div>
            <div class="pm-col-album">Album</div>
            <div>Reprod.</div>
            <div style="text-align:right">Acciones</div>
        </div>
<%
        Do While Not objRS.EOF
            nFila   = nFila + 1
            sCover  = PM_Cover(objRS("ID_SONG"))
            sRuta   = PM_Path(objRS("SONG_PATH"))
            sArtistas = CStr(objRS("ARTISTS") & "")
            sAlbumes  = CStr(objRS("ALBUMS") & "")
%>
        <div class="pm-song-row"
             data-id="<%=objRS("ID_SONG")%>"
             data-src="<%=PM_Html(sRuta)%>"
             data-title="<%=PM_Html(objRS("SONG_NAME"))%>"
             data-artist="<%=PM_Html(sArtistas)%>"
             data-album="<%=PM_Html(sAlbumes)%>"
             data-cover="<%=PM_Html(sCover)%>">
            <div class="pm-song-lead">
                <div class="pm-song-index"><%=nFila%></div>
                <button class="pm-song-play" type="button" title="Reproducir">
                    <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
                </button>
            </div>

            <div class="pm-song-main">
                <img class="pm-song-cover" src="<%=PM_Html(sCover)%>" alt="Portada de <%=PM_Html(objRS("SONG_NAME"))%>">
                <div class="pm-song-titles">
                    <strong><%=PM_Html(objRS("SONG_NAME"))%></strong>
                    <span><%=PM_Html(sRuta)%></span>
                </div>
            </div>

            <div class="pm-song-text pm-col-artist"><%=PM_Html(sArtistas)%></div>
            <div class="pm-song-text pm-col-album"><%=PM_Html(sAlbumes)%></div>
            <div class="pm-song-plays pm-col-plays"><%=objRS("PLAYS")%></div>

            <div class="pm-song-actions">
<%          If bConAcciones Then %>
                <a class="pm-btn pm-btn-blue pm-btn-sm" href="admin_song_form.asp?id=<%=objRS("ID_SONG")%>">Editar</a>
                <a class="pm-btn pm-btn-danger pm-btn-sm" href="admin_song_delete.asp?id=<%=objRS("ID_SONG")%>"
                   data-confirm="¿Esta seguro de eliminar la cancion '<%=PM_Html(objRS("SONG_NAME"))%>'?">Eliminar</a>
<%          Else %>
                <a class="pm-btn pm-btn-sm" href="play_counter.asp?id=<%=objRS("ID_SONG")%>&back=1">+1 play</a>
<%          End If %>
            </div>
        </div>
<%
            objRS.MoveNext
        Loop
%>
    </div>
<%
    End If

    PM_Close objRS
End Sub
%>
