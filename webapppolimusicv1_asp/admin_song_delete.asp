<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Eliminar cancion - SOLO administrador
'  Borra primero las referencias en TBL_PLAYLIST_SONG, TBL_TRACKLIST
'  y TBL_PLAYER para respetar las llaves foraneas.
'=====================================================================
Call PM_RequireAdmin()

Dim nId, sNombre, objRS, objConn

PM_Title = "Eliminar cancion"
PM_Page  = "admin_songs"

nId = PM_Num(PM_Param("id"))
If nId <= 0 Then Response.Redirect("admin_songs.asp?msg=error")

Set objRS = PM_Query("SELECT SONG_NAME FROM TBL_SONG WHERE ID_SONG = " & CStr(nId))
If objRS.EOF Then
    PM_Close objRS
    Response.Redirect("admin_songs.asp?msg=error")
End If
sNombre = CStr(objRS("SONG_NAME") & "")
PM_Close objRS

If PM_Param("confirm") <> "1" Then
%>
<!--#include file="includes/header.asp"-->
<div class="pm-panel">
    <h2>Confirmar eliminacion</h2>
    <p class="pm-sub">¿Esta seguro de eliminar la cancion <strong><%=PM_Html(sNombre)%></strong>?</p>
    <div class="pm-form-actions">
        <a class="pm-btn pm-btn-danger" href="admin_song_delete.asp?id=<%=nId%>&confirm=1">Si, eliminar</a>
        <a class="pm-btn" href="admin_songs.asp">Cancelar</a>
    </div>
</div>
<!--#include file="includes/footer.asp"-->
<%
Else
    Set objConn = PM_Connection()
    objConn.BeginTrans()
    objConn.Execute "DELETE FROM TBL_PLAYLIST_SONG WHERE ID_SONG = " & CStr(nId)
    objConn.Execute "DELETE FROM TBL_TRACKLIST     WHERE ID_SONG = " & CStr(nId)
    objConn.Execute "DELETE FROM TBL_PLAYER        WHERE ID_SONG = " & CStr(nId)
    objConn.Execute "DELETE FROM TBL_SONG          WHERE ID_SONG = " & CStr(nId)
    objConn.CommitTrans()
    PM_Close objConn
    Response.Redirect("admin_songs.asp?msg=deleted")
End If
%>
