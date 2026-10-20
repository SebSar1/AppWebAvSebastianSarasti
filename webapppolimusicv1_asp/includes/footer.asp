<%
'=====================================================================
'  POLIMUSIC - Pie comun + reproductor flotante
'=====================================================================
%>
</main>

<div class="pm-player" id="pmPlayer">
    <div class="pm-player-track">
        <img class="pm-player-cover" id="pmCover" src="playlistImages/default.jpg" alt="Portada">
        <div class="pm-player-meta">
            <strong id="pmTitle">Selecciona una cancion</strong>
            <span id="pmArtist">PoliMusic Web Player</span>
        </div>
    </div>

    <div class="pm-player-center">
        <div class="pm-player-buttons">
            <button class="pm-ctrl" id="pmPrev" type="button" title="Anterior">
                <svg viewBox="0 0 24 24"><path d="M6 6h2v12H6zm3 6 9-6v12z"/></svg>
            </button>
            <button class="pm-ctrl-main" id="pmPlay" type="button" title="Reproducir / Pausar">
                <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
            </button>
            <button class="pm-ctrl" id="pmNext" type="button" title="Siguiente">
                <svg viewBox="0 0 24 24"><path d="M16 6h2v12h-2zM6 18l9-6-9-6z"/></svg>
            </button>
        </div>
        <div class="pm-progress-row">
            <span class="pm-time" id="pmTime">0:00</span>
            <div class="pm-bar" id="pmBar"><div class="pm-bar-fill" id="pmFill"></div></div>
            <span class="pm-time right" id="pmDur">0:00</span>
        </div>
    </div>

    <div class="pm-player-right">
        <div class="pm-eq pm-paused" id="pmEq"><i></i><i></i><i></i></div>
        <svg viewBox="0 0 24 24"><path d="M4 9h3l4-4v14l-4-4H4zm12.5 3a4.5 4.5 0 0 1-1.6-3.4V8a4.6 4.6 0 0 1 .6-2.3l1.3 1.3A2.9 2.9 0 0 0 16.5 8v.6a3 3 0 0 0 .9 2.1zM14 3.2v2.1c1.3.9 2.1 2.3 2.1 3.9 0 1.6-.8 3-2.1 3.9v2.1c2.4-1 4-3.4 4-6s-1.6-5-4-6z"/></svg>
        <input class="pm-volume" id="pmVol" type="range" min="0" max="100" value="80" title="Volumen">
    </div>

    <audio id="pmAudio" preload="metadata"></audio>
</div>

<script src="js/app.js"></script>
</body>
</html>
