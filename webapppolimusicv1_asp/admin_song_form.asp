<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Formulario de creacion / edicion de canciones (ADMIN)
'=====================================================================
Call PM_RequireAdmin()

PM_Title = "Cancion"
PM_Page  = "admin_songs"

Dim nId, sNombre, sRuta, sPlays, sError, objRS, bEditar
nId     = PM_Num(PM_Param("id"))
sNombre = ""
sRuta   = "~/songFiles/"
sPlays  = "0"
sError  = Request.QueryString("err")
bEditar = False

If nId > 0 Then
    Set objRS = PM_Query("SELECT ID_SONG, SONG_NAME, SONG_PATH, ISNULL(PLAYS,0) AS PLAYS FROM TBL_SONG WHERE ID_SONG = " & CStr(nId))
    If objRS.EOF Then
        PM_Close objRS
        Response.Redirect("admin_songs.asp?msg=error")
    End If
    sNombre = CStr(objRS("SONG_NAME") & "")
    sRuta   = CStr(objRS("SONG_PATH") & "")
    sPlays  = CStr(objRS("PLAYS"))
    bEditar = True
    PM_Close objRS
End If

If Request.QueryString("err") = "datos" Then
    sError = "Debe completar el nombre y la ruta de la cancion."
ElseIf Request.QueryString("err") = "numero" Then
    sError = "El numero de reproducciones debe ser un valor numerico."
End If
%>
<!--#include file="includes/header.asp"-->

<section class="pm-hero" style="padding:26px 32px">
    <div class="pm-hero-eyebrow">Administracion &middot; <%=PM_Html(PM_UserName())%></div>
    <h1 style="font-size:27px"><% If bEditar Then %>Editar cancion<% Else %>Nueva cancion<% End If %></h1>
    <p>Los cambios se guardan en la tabla <strong>TBL_SONG</strong>.</p>
</section>

<div class="pm-panel">
    <h2><% If bEditar Then %>Editar registro #<%=nId%><% Else %>Registrar nueva cancion<% End If %></h2>
    <p class="pm-sub">Complete los campos y presione el boton Guardar.</p>

<% If sError <> "" Then %>
    <div class="pm-alert pm-alert-error"><%=PM_Html(sError)%></div>
<% End If %>

    <form method="post" action="admin_song_save.asp" autocomplete="off">
        <input type="hidden" name="hidId" value="<%=nId%>">
        <div class="pm-form-grid">
            <div class="pm-field">
                <label for="txtNombre">Nombre de la cancion (*)</label>
                <input type="text" id="txtNombre" name="txtNombre" maxlength="50"
                       value="<%=PM_Html(sNombre)%>" placeholder="ej. Adventure" required>
            </div>
            <div class="pm-field">
                <label for="txtRuta">Ruta del archivo (*)</label>
                <input type="text" id="txtRuta" name="txtRuta" maxlength="255" list="lstRutas"
                       value="<%=PM_Html(sRuta)%>" placeholder="~/songFiles/bensound-adventure.mp3" required>
                <datalist id="lstRutas">
<%
Dim objFSO, objFile, sCarpeta
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
sCarpeta = Server.MapPath("songFiles")
If objFSO.FolderExists(sCarpeta) Then
    For Each objFile In objFSO.GetFolder(sCarpeta).Files
        If LCase(objFSO.GetExtensionName(objFile.Name)) = "mp3" Then
%>
                    <option value="~/songFiles/<%=PM_Html(objFile.Name)%>"></option>
<%
        End If
    Next
End If
Set objFSO = Nothing
%>
                </datalist>
            </div>
            <div class="pm-field">
                <label for="txtPlays">Reproducciones</label>
                <input type="number" id="txtPlays" name="txtPlays" min="0" step="1" value="<%=PM_Html(sPlays)%>">
            </div>
        </div>

        <div class="pm-form-actions">
            <button class="pm-btn pm-btn-primary" type="submit">Guardar</button>
            <a class="pm-btn" href="admin_songs.asp">Cancelar</a>
        </div>
    </form>
</div>

<!--#include file="includes/footer.asp"-->
