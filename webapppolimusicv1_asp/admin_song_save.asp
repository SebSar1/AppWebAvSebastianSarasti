<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Guardar cancion (INSERT / UPDATE) - SOLO administrador
'=====================================================================
Call PM_RequireAdmin()

Dim nId, sNombre, sRuta, sPlays, strSQL

If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    Response.Redirect("admin_songs.asp")
End If

nId     = PM_Num(Request.Form("hidId"))
sNombre = Trim(Request.Form("txtNombre") & "")
sRuta   = Trim(Request.Form("txtRuta") & "")
sPlays  = Trim(Request.Form("txtPlays") & "")
If sPlays = "" Then sPlays = "0"

If sNombre = "" Or sRuta = "" Then
    Response.Redirect("admin_song_form.asp?id=" & nId & "&err=datos")
End If
If Not IsNumeric(sPlays) Then
    Response.Redirect("admin_song_form.asp?id=" & nId & "&err=numero")
End If

If nId > 0 Then
    strSQL = "UPDATE TBL_SONG SET SONG_NAME = '" & PM_SQL(sNombre) & "', " & _
             " SONG_PATH = '" & PM_SQL(sRuta) & "', " & _
             " PLAYS = " & CStr(CLng(sPlays)) & " " & _
             "WHERE ID_SONG = " & CStr(nId)
Else
    strSQL = "INSERT INTO TBL_SONG (SONG_NAME, SONG_PATH, PLAYS) VALUES ('" & _
             PM_SQL(sNombre) & "', '" & PM_SQL(sRuta) & "', " & CStr(CLng(sPlays)) & ")"
End If

PM_Execute strSQL
Response.Redirect("admin_songs.asp?msg=saved")
%>
