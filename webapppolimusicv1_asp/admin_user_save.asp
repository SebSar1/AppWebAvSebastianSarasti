<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Guardar usuario (INSERT / UPDATE) - SOLO administrador
'=====================================================================
Call PM_RequireAdmin()

If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    Response.Redirect("admin_users.asp")
End If

Dim nId, sNombre, sPass, sEmail, sCumple, sFoto, sTipo, objRS, strSQL

nId     = PM_Num(Request.Form("hidId"))
sNombre = Trim(Request.Form("txtUsuario") & "")
sPass   = Trim(Request.Form("txtPassword") & "")
sEmail  = Trim(Request.Form("txtEmail") & "")
sCumple = Trim(Request.Form("txtCumple") & "")
sFoto   = Trim(Request.Form("txtFoto") & "")
sTipo   = Trim(Request.Form("selTipo") & "")
If sFoto = "" Then sFoto = "~/userImages/default.jpg"
If Not IsNumeric(sTipo) Then sTipo = "0"

If sNombre = "" Or sPass = "" Or sEmail = "" Then
    Response.Redirect("admin_user_form.asp?id=" & nId & "&err=datos")
End If

'--- Valida que el nombre de usuario no se repita -----------------------
Set objRS = PM_Query("SELECT ID_USER FROM TBL_USER WHERE USERNAME = '" & PM_SQL(sNombre) & "' AND ID_USER <> " & CStr(nId))
If Not objRS.EOF Then
    PM_Close objRS
    Response.Redirect("admin_user_form.asp?id=" & nId & "&err=dupli")
End If
PM_Close objRS

Dim sFecha
If sCumple = "" Then
    sFecha = "NULL"
Else
    sFecha = "'" & PM_SQL(sCumple) & "'"
End If

If nId > 0 Then
    strSQL = "UPDATE TBL_USER SET USERNAME = '" & PM_SQL(sNombre) & "', " & _
             " PASSWORD = '" & PM_SQL(sPass) & "', " & _
             " EMAIL = '" & PM_SQL(sEmail) & "', " & _
             " BIRTHDAY = " & sFecha & ", " & _
             " USER_PHOTO = '" & PM_SQL(sFoto) & "', " & _
             " USER_TYPE = " & CStr(CLng(sTipo)) & " " & _
             "WHERE ID_USER = " & CStr(nId)
Else
    strSQL = "INSERT INTO TBL_USER (USERNAME, PASSWORD, EMAIL, BIRTHDAY, USER_PHOTO, USER_TYPE) VALUES ('" & _
             PM_SQL(sNombre) & "', '" & PM_SQL(sPass) & "', '" & PM_SQL(sEmail) & "', " & _
             sFecha & ", '" & PM_SQL(sFoto) & "', " & CStr(CLng(sTipo)) & ")"
End If

PM_Execute strSQL
Response.Redirect("admin_users.asp?msg=saved")
%>
