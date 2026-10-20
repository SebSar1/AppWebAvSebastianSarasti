<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - CRUD de usuarios (SOLO administrador)
'  Tabla: TBL_USER  (USER_TYPE toma el valor del catalogo padre '1')
'=====================================================================
Call PM_RequireAdmin()

PM_Title = "CRUD Usuarios"
PM_Page  = "admin_users"

Select Case Request.QueryString("msg")
    Case "saved"   : PM_Msg = "El usuario se guardo correctamente." : PM_MsgType = "ok"
    Case "deleted" : PM_Msg = "El usuario se elimino correctamente." : PM_MsgType = "ok"
    Case "error"   : PM_Msg = "No fue posible completar la operacion solicitada." : PM_MsgType = "error"
    Case "self"    : PM_Msg = "No puede eliminar el usuario con el que tiene la sesion abierta." : PM_MsgType = "warn"
End Select

Dim strSQL, objRS
strSQL = "SELECT u.ID_USER, u.USERNAME, u.EMAIL, u.BIRTHDAY, u.USER_PHOTO, u.USER_TYPE, " & _
         " ISNULL((SELECT TOP 1 c.VALUE FROM TBL_CATALOG c WHERE c.COD_CATALOG_PARENT = '1' " & _
         "        AND c.COD_CATALOG = CAST(u.USER_TYPE AS varchar(8))), 'USER') AS ROLE_LABEL " & _
         "FROM TBL_USER u ORDER BY u.ID_USER"
Set objRS = PM_Query(strSQL)
%>
<!--#include file="includes/header.asp"-->

<section class="pm-hero" style="padding:26px 32px">
    <div class="pm-hero-eyebrow">Administracion &middot; <%=PM_Html(PM_UserName())%></div>
    <h1 style="font-size:28px">CRUD de <em>usuarios</em></h1>
    <p>Administre los usuarios y sus roles (0 = usuario normal, 1 = administrador). El rol se muestra con la etiqueta del catalogo.</p>
</section>

<div class="pm-panel">
    <h2>Usuarios registrados</h2>
    <p class="pm-sub">Tabla <strong>TBL_USER</strong>.</p>

    <div class="pm-form-actions" style="margin:0 0 18px 0">
        <a class="pm-btn pm-btn-primary" href="admin_user_form.asp">+ Nuevo usuario</a>
    </div>

<% If objRS.EOF Then %>
    <div class="pm-empty">No hay usuarios registrados.</div>
<% Else %>
    <table class="pm-table">
        <thead>
            <tr>
                <th style="width:60px">#</th>
                <th style="width:70px"></th>
                <th>Usuario</th>
                <th>Correo</th>
                <th>Cumpleanos</th>
                <th style="width:140px">Rol</th>
                <th style="width:190px;text-align:right">Acciones</th>
            </tr>
        </thead>
        <tbody>
<%  Do While Not objRS.EOF %>
            <tr>
                <td><%=objRS("ID_USER")%></td>
                <td><img src="<%=PM_Html(PM_Path(objRS("USER_PHOTO")))%>" alt="" style="width:44px;height:44px;border-radius:50%;object-fit:cover;border:2px solid var(--pm-red)"></td>
                <td>
                    <strong><%=PM_Html(objRS("USERNAME"))%></strong>
<%      If CStr(Session("pm_idUser")) = CStr(objRS("ID_USER")) Then %>
                    <span class="pm-tag pm-tag-public" style="margin-left:6px">Tu sesion</span>
<%      End If %>
                </td>
                <td><%=PM_Html(objRS("EMAIL"))%></td>
                <td><% If IsNull(objRS("BIRTHDAY")) Then %>-<% Else %><%=PM_Html(objRS("BIRTHDAY"))%><% End If %></td>
                <td>
                    <span class="pm-tag <%=PM_If(CLng(objRS("USER_TYPE")) = 1, "pm-tag-private", "pm-tag-public")%>">
                        <%=PM_Html(objRS("ROLE_LABEL"))%> (<%=objRS("USER_TYPE")%>)
                    </span>
                </td>
                <td>
                    <div class="pm-row-actions">
                        <a class="pm-btn pm-btn-blue pm-btn-sm" href="admin_user_form.asp?id=<%=objRS("ID_USER")%>">Editar</a>
                        <a class="pm-btn pm-btn-danger pm-btn-sm" href="admin_user_delete.asp?id=<%=objRS("ID_USER")%>&confirm=1"
                           data-confirm="¿Eliminar al usuario '<%=PM_Html(objRS("USERNAME"))%>'? Tambien se borraran sus playlists.">Eliminar</a>
                    </div>
                </td>
            </tr>
<%      objRS.MoveNext
    Loop %>
        </tbody>
    </table>
<% End If %>
</div>

<!--#include file="includes/footer.asp"-->
