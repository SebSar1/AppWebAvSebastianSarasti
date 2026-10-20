/* =====================================================================
   POLIMUSIC - Logica de cliente (reproductor, buscador, confirmaciones)
   ===================================================================== */
(function () {
    "use strict";

    /* ------------------------- Utilidades ---------------------------- */
    function $(id) { return document.getElementById(id); }
    function fmtTime(seg) {
        if (isNaN(seg) || seg < 0) { seg = 0; }
        var m = Math.floor(seg / 60);
        var s = Math.floor(seg % 60);
        return m + ":" + (s < 10 ? "0" + s : s);
    }
    function post(url) {
        try {
            var x = new XMLHttpRequest();
            x.open("GET", url, true);
            x.send(null);
        } catch (e) { /* silencioso */ }
    }

    /* ------------------------- Reproductor --------------------------- */
    var audio   = $("pmAudio");
    var queue   = [];
    var current = -1;

    function buildQueue() {
        queue = [];
        var rows = document.querySelectorAll(".pm-song-row");
        for (var i = 0; i < rows.length; i++) {
            if (rows[i].style.display === "none") { continue; }
            queue.push({
                el:     rows[i],
                id:     rows[i].getAttribute("data-id"),
                src:    rows[i].getAttribute("data-src"),
                title:  rows[i].getAttribute("data-title"),
                artist: rows[i].getAttribute("data-artist"),
                cover:  rows[i].getAttribute("data-cover")
            });
        }
    }

    function highlight() {
        var rows = document.querySelectorAll(".pm-song-row");
        for (var i = 0; i < rows.length; i++) { rows[i].classList.remove("pm-playing"); }
        if (queue[current]) { queue[current].el.classList.add("pm-playing"); }
    }

    function paint() {
        var t = queue[current];
        if (!t) { return; }
        $("pmCover").src   = t.cover;
        $("pmTitle").textContent  = t.title;
        $("pmArtist").textContent = t.artist || "PoliMusic";
        highlight();
    }

    function playIndex(i) {
        if (!queue.length) { buildQueue(); }
        if (i < 0) { i = queue.length - 1; }
        if (i >= queue.length) { i = 0; }
        current = i;
        var t = queue[current];
        audio.src = t.src;
        audio.volume = ($("pmVol").value / 100);
        paint();
        var p = audio.play();
        if (p && typeof p.catch === "function") { p.catch(function () { setPlayIcon(false); }); }
        /* registra la reproduccion en TBL_SONG.PLAYS */
        post("play_counter.asp?id=" + encodeURIComponent(t.id));
    }

    function setPlayIcon(playing) {
        $("pmPlay").innerHTML = playing
            ? '<svg viewBox="0 0 24 24"><path d="M6 5h4v14H6zM14 5h4v14h-4z"/></svg>'
            : '<svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>';
        var eq = $("pmEq");
        if (eq) { eq.className = playing ? "pm-eq" : "pm-eq pm-paused"; }
    }

    function toggle() {
        if (!audio.src) {
            if (!queue.length) { buildQueue(); }
            if (!queue.length) { return; }
            playIndex(0);
            return;
        }
        if (audio.paused) { audio.play(); } else { audio.pause(); }
    }

    function bindPlayer() {
        if (!audio) { return; }

        var btnPlay = $("pmPlay");
        if (btnPlay) { btnPlay.addEventListener("click", toggle); }
        if ($("pmNext")) { $("pmNext").addEventListener("click", function () { playIndex(current + 1); }); }
        if ($("pmPrev")) { $("pmPrev").addEventListener("click", function () { playIndex(current - 1); }); }

        audio.addEventListener("play",  function () { setPlayIcon(true);  });
        audio.addEventListener("pause", function () { setPlayIcon(false); });
        audio.addEventListener("ended", function () { playIndex(current + 1); });
        audio.addEventListener("loadedmetadata", function () {
            $("pmDur").textContent = fmtTime(audio.duration);
        });
        audio.addEventListener("timeupdate", function () {
            if (!audio.duration) { return; }
            var pct = (audio.currentTime / audio.duration) * 100;
            $("pmFill").style.width = pct + "%";
            $("pmTime").textContent = fmtTime(audio.currentTime);
        });

        var bar = $("pmBar");
        if (bar) {
            bar.addEventListener("click", function (e) {
                if (!audio.duration) { return; }
                var r = bar.getBoundingClientRect();
                var pct = (e.clientX - r.left) / r.width;
                audio.currentTime = pct * audio.duration;
            });
        }

        var vol = $("pmVol");
        if (vol) {
            vol.addEventListener("input", function () { audio.volume = vol.value / 100; });
        }
        setPlayIcon(false);
    }

    /* Clic en cualquier fila / boton de play */
    function bindRows() {
        var rows = document.querySelectorAll(".pm-song-row");
        for (var i = 0; i < rows.length; i++) {
            (function (row) {
                row.addEventListener("click", function (e) {
                    if (e.target.closest("a") || e.target.closest("button.pm-btn")) { return; }
                    buildQueue();
                    for (var j = 0; j < queue.length; j++) {
                        if (queue[j].el === row) { playIndex(j); return; }
                    }
                });
            })(rows[i]);
        }
    }

    /* ------------------------- Buscador ------------------------------ */
    function bindSearch() {
        var input = $("pmSearch");
        if (!input) { return; }
        input.addEventListener("keyup", function () {
            var q = input.value.toLowerCase();
            var rows = document.querySelectorAll(".pm-song-row");
            for (var i = 0; i < rows.length; i++) {
                var txt = (rows[i].getAttribute("data-title") + " " +
                           rows[i].getAttribute("data-artist") + " " +
                           rows[i].getAttribute("data-album")).toLowerCase();
                rows[i].style.display = (txt.indexOf(q) === -1) ? "none" : "";
            }
            buildQueue();
        });
    }

    /* ------------------------- Confirmaciones ------------------------ */
    function bindConfirm() {
        var els = document.querySelectorAll("[data-confirm]");
        for (var i = 0; i < els.length; i++) {
            (function (el) {
                el.addEventListener("click", function (e) {
                    if (!window.confirm(el.getAttribute("data-confirm"))) { e.preventDefault(); }
                });
            })(els[i]);
        }
    }

    /* ------------------------- Inicio -------------------------------- */
    document.addEventListener("DOMContentLoaded", function () {
        buildQueue();
        bindPlayer();
        bindRows();
        bindSearch();
        bindConfirm();
    });
})();
