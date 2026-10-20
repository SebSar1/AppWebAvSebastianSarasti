<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Eliminar usuario - SOLO administrador
'  Borra primero sus playlists (TBL_PLAYLIST_SONG -> TBL_PLAYLIST)
'=====================================================================
Call PM_RequireAdmin()

Dim nId, sNombre, objRS, objConn

PM_Title = "Eliminar usuario"
PM_Page  = "admin_users"

nId = PM_Num(PM_Param("id"))
If nId <= 0 Then Response.Redirect("admin_users.asp?msg=error")

' No se permite eliminar el usuario de la sesion actual
If CStr(Session("pm_idUser")) = CStr(nId) Then
    Response.Redirect("admin_users.asp?msg=self")
End If

Set objRS = PM_Query("SELECT USERNAME FROM TBL_USER WHERE ID_USER = " & CStr(nId))
If objRS.EOF Then
    PM_Close objRS
    Response.Redirect("admin_users.asp?msg=error")
End If
sNombre = CStr(objRS("USERNAME") & "")
PM_Close objRS

If PM_Param("confirm") <> "1" Then
%>
<!--#include file="includes/header.asp"-->
<div class="pm-panel">
    <h2>Confirmar eliminacion</h2>
    <p class="pm-sub">¿Esta seguro de eliminar al usuario <strong><%=PM_Html(sNombre)%></strong>? Se borraran tambien sus playlists.</p>
    <div class="pm-form-actions">
        <a class="pm-btn pm-btn-danger" href="admin_user_delete.asp?id=<%=nId%>&confirm=1">Si, eliminar</a>
        <a class="pm-btn" href="admin_users.asp">Cancelar</a>
    </div>
</div>
<!--#include file="includes/footer.asp"-->
<%
Else
    Set objConn = PM_Connection()
    objConn.BeginTrans()
    objConn.Execute "DELETE FROM TBL_PLAYLIST_SONG WHERE ID_PLAYLIST IN (SELECT ID_PLAYLIST FROM TBL_PLAYLIST WHERE ID_USER = " & CStr(nId) & ")"
    objConn.Execute "DELETE FROM TBL_PLAYLIST WHERE ID_USER = " & CStr(nId)
    objConn.Execute "DELETE FROM TBL_USER WHERE ID_USER = " & CStr(nId)
    objConn.CommitTrans()
    PM_Close objConn
    Response.Redirect("admin_users.asp?msg=deleted")
End If
%>
