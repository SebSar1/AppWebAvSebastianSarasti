<%'=====================================================================
'  POLIMUSIC - Carga comun: conexion + seguridad + encoding
'  Incluir SIEMPRE al inicio de cada pagina .asp
'=====================================================================
%>
<!--#include file="connection.asp"-->
<!--#include file="auth.asp"-->
<%
Response.Buffer = True
Response.CodePage = 65001
Response.CharSet  = "UTF-8"
Session.CodePage  = 65001
Session.LCID      = 2058      ' espanol (Mexico)
Session.Timeout   = 60
%>
