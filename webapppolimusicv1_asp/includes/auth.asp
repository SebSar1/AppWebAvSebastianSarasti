<%
'=====================================================================
'  POLIMUSIC - Control de acceso por roles
'  TBL_USER.USER_TYPE :  0 = Usuario normal   1 = Administrador
'=====================================================================

'--- Exige sesion activa, si no existe va a login.asp ---------------------
Sub PM_RequireLogin()
    If Session("pm_idUser") = "" Or Session("pm_username") = "" Then
        Response.Redirect("login.asp?msg=required")
    End If
End Sub

'--- Exige rol de administrador -------------------------------------------
Sub PM_RequireAdmin()
    Call PM_RequireLogin()
    If CStr(Session("pm_userType") & "") <> "1" Then
        Response.Redirect("index.asp?msg=denied")
    End If
End Sub

'--- Datos de la sesion -----------------------------------------------------
Function PM_UserName()
    PM_UserName = CStr(Session("pm_username") & "")
End Function

Function PM_IsAdmin()
    PM_IsAdmin = (CStr(Session("pm_userType") & "") = "1")
End Function

Function PM_RoleLabel()
    If PM_IsAdmin() Then
        PM_RoleLabel = "Administrador"
    Else
        PM_RoleLabel = "Usuario normal"
    End If
End Function

'--- Foto del usuario logueado ----------------------------------------------
Function PM_UserPhoto()
    Dim s
    s = CStr(Session("pm_userPhoto") & "")
    If s = "" Then s = "userImages/default.jpg"
    PM_UserPhoto = PM_Path(s)
End Function
%>
