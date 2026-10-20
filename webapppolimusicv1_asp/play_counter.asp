<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Contador de reproducciones
'  Llamado por AJAX desde el reproductor (js/app.js).
'  Incrementa TBL_SONG.PLAYS y devuelve "ok".
'  Con ?back=1 redirige a la pagina de origen (uso desde enlaces).
'=====================================================================
Call PM_RequireLogin()

Dim nId, sRef
nId = PM_Num(PM_Param("id"))

If nId > 0 Then
    PM_Execute "UPDATE TBL_SONG SET PLAYS = ISNULL(PLAYS,0) + 1 WHERE ID_SONG = " & CStr(nId)
End If

If PM_Param("back") = "1" Then
    sRef = Request.ServerVariables("HTTP_REFERER")
    If sRef = "" Then sRef = "songs.asp"
    Response.Redirect(sRef)
Else
    Response.ContentType = "text/plain"
    Response.Write "ok"
End If
%>
