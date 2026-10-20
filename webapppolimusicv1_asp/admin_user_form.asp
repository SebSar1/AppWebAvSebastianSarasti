<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Formulario de creacion / edicion de usuarios (ADMIN)
'=====================================================================
Call PM_RequireAdmin()

PM_Title = "Usuario"
PM_Page  = "admin_users"

Dim nId, sNombre, sPass, sEmail, sFoto, sTipo, sCumple, sError, objRS, bEditar
nId     = PM_Num(PM_Param("id"))
sNombre = "" : sPass = "" : sEmail = "" : sFoto = "~/userImages/default.jpg"
sTipo   = "0" : sCumple = "" : sError = "" : bEditar = False

If nId > 0 Then
    Set objRS = PM_Query("SELECT ID_USER, USERNAME, PASSWORD, EMAIL, BIRTHDAY, USER_PHOTO, USER_TYPE FROM TBL_USER WHERE ID_USER = " & CStr(nId))
    If objRS.EOF Then
        PM_Close objRS
        Response.Redirect("admin_users.asp?msg=error")
    End If
    sNombre = CStr(objRS("USERNAME") & "")
    sPass   = CStr(objRS("PASSWORD") & "")
    sEmail  = CStr(objRS("EMAIL") & "")
    sFoto   = CStr(objRS("USER_PHOTO") & "")
    sTipo   = CStr(objRS("USER_TYPE"))
    If Not IsNull(objRS("BIRTHDAY")) Then sCumple = Year(objRS("BIRTHDAY")) & "-" & Right("0" & Month(objRS("BIRTHDAY")),2) & "-" & Right("0" & Day(objRS("BIRTHDAY")),2)
    bEditar = True
    PM_Close objRS
End If

Select Case Request.QueryString("err")
    Case "datos" : sError = "Usuario, contrasena y correo son obligatorios."
    Case "dupli" : sError = "Ya existe otro usuario con ese nombre."
End Select
%>
<!--#include file="includes/header.asp"-->

<section class="pm-hero" style="padding:26px 32px">
    <div class="pm-hero-eyebrow">Administracion &middot; <%=PM_Html(PM_UserName())%></div>
    <h1 style="font-size:27px"><% If bEditar Then %>Editar usuario<% Else %>Nuevo usuario<% End If %></h1>
    <p>Los cambios se guardan en la tabla <strong>TBL_USER</strong>.</p>
</section>

<div class="pm-panel">
    <h2><% If bEditar Then %>Editar usuario #<%=nId%><% Else %>Registrar nuevo usuario<% End If %></h2>
    <p class="pm-sub">USER_TYPE: 0 = usuario normal, 1 = administrador.</p>

<% If sError <> "" Then %>
    <div class="pm-alert pm-alert-error"><%=PM_Html(sError)%></div>
<% End If %>

    <form method="post" action="admin_user_save.asp" autocomplete="off">
        <input type="hidden" name="hidId" value="<%=nId%>">
        <div class="pm-form-grid">
            <div class="pm-field">
                <label for="txtUsuario">Usuario (*)</label>
                <input type="text" id="txtUsuario" name="txtUsuario" maxlength="50" value="<%=PM_Html(sNombre)%>" required>
            </div>
            <div class="pm-field">
                <label for="txtPassword">Contrasena (*)</label>
                <input type="text" id="txtPassword" name="txtPassword" maxlength="50" value="<%=PM_Html(sPass)%>" required>
            </div>
            <div class="pm-field">
                <label for="txtEmail">Correo (*)</label>
                <input type="email" id="txtEmail" name="txtEmail" maxlength="50" value="<%=PM_Html(sEmail)%>" required>
            </div>
            <div class="pm-field">
                <label for="txtCumple">Cumpleanos</label>
                <input type="date" id="txtCumple" name="txtCumple" value="<%=PM_Html(sCumple)%>">
            </div>
            <div class="pm-field">
                <label for="txtFoto">Foto</label>
                <input type="text" id="txtFoto" name="txtFoto" maxlength="255" list="lstFotos" value="<%=PM_Html(sFoto)%>">
                <datalist id="lstFotos">
<%
Dim objFSO, objFile, sCarpeta
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
sCarpeta = Server.MapPath("userImages")
If objFSO.FolderExists(sCarpeta) Then
    For Each objFile In objFSO.GetFolder(sCarpeta).Files
%>
                    <option value="~/userImages/<%=PM_Html(objFile.Name)%>"></option>
<%
    Next
End If
Set objFSO = Nothing
%>
                </datalist>
            </div>
            <div class="pm-field">
                <label for="selTipo">Rol (*)</label>
                <select id="selTipo" name="selTipo">
<%
Dim objCat
Set objCat = PM_Query("SELECT COD_CATALOG, VALUE FROM TBL_CATALOG WHERE COD_CATALOG_PARENT = '1' ORDER BY COD_CATALOG")
Do While Not objCat.EOF
%>
                    <option value="<%=PM_Html(objCat("COD_CATALOG"))%>" <%=PM_If(CStr(objCat("COD_CATALOG")) = sTipo, "selected", "")%>>
                        <%=PM_Html(objCat("VALUE"))%> (<%=PM_Html(objCat("COD_CATALOG"))%>)
                    </option>
<%
    objCat.MoveNext
Loop
PM_Close objCat
%>
                </select>
            </div>
        </div>

        <div class="pm-form-actions">
            <button class="pm-btn pm-btn-primary" type="submit">Guardar</button>
            <a class="pm-btn" href="admin_users.asp">Cancelar</a>
        </div>
    </form>
</div>

<!--#include file="includes/footer.asp"-->
