<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<!--#include file="includes/songlist.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Listado completo de canciones (Song List)
'=====================================================================
Call PM_RequireLogin()

PM_Title = "Canciones"
PM_Page  = "songs"

Dim nTotal
nTotal = 0
Dim objRSCount
Set objRSCount = PM_Query("SELECT COUNT(*) AS N FROM TBL_SONG")
If Not objRSCount.EOF Then nTotal = CLng(objRSCount("N"))
PM_Close objRSCount
%>
<!--#include file="includes/header.asp"-->

<section class="pm-hero" style="padding:26px 32px">
    <div class="pm-hero-eyebrow">Catalogo &middot; <%=PM_Html(PM_UserName())%></div>
    <h1 style="font-size:28px">Reproduce tu musica, <em><%=PM_Html(PM_UserName())%></em></h1>
    <p>Tienes <%=nTotal%> canciones disponibles en la base de datos. Usa el buscador de la barra superior para filtrar por titulo, artista o album.</p>
</section>

<section class="pm-section">
    <div class="pm-section-head">
        <div>
            <h2>Song List</h2>
            <p>A continuacion se presenta el listado de canciones almacenadas en la tabla TBL_SONG.</p>
        </div>
<% If PM_IsAdmin() Then %>
        <a class="pm-btn pm-btn-primary" href="admin_song_form.asp">+ Nueva cancion</a>
<% End If %>
    </div>
    <% Call PM_RenderSongList(PM_IsAdmin()) %>
</section>

<!--#include file="includes/footer.asp"-->
