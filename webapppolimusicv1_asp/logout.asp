<%@ Language="VBScript" CodePage="65001" %>
<!--#include file="includes/bootstrap.asp"-->
<%
'=====================================================================
'  POLIMUSIC - Cierre de sesion
'=====================================================================
Session("pm_idUser")    = ""
Session("pm_username")  = ""
Session("pm_email")     = ""
Session("pm_userType")  = ""
Session("pm_userPhoto") = ""
Session("pm_loginAt")   = ""
Session.Abandon()
Response.Redirect("login.asp?msg=logout")
%>
