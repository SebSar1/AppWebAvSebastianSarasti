<%
'=====================================================================
'  POLIMUSIC  -  Capa de datos (Classic ASP / VBScript + ADO)
'  Base de datos : BDD_PoliMusic  (SQL Server - localhost:1433)
'  Usuario       : usr_polimusic
'=====================================================================

'--- Cadena de conexion -------------------------------------------------
Const PM_CONN_STRING = "Provider=SQLOLEDB;Data Source=localhost,1433;Initial Catalog=BDD_PoliMusic;User ID=usr_polimusic;Password=Politecnica1;"

'--- Abre y devuelve una conexion ADO -----------------------------------
Function PM_Connection()
    Dim objConn
    Set objConn = Server.CreateObject("ADODB.Connection")
    objConn.CursorLocation = 3          ' adUseClient
    objConn.CommandTimeout = 30
    objConn.Open PM_CONN_STRING
    Set PM_Connection = objConn
End Function

'--- Cierra y libera una conexion ---------------------------------------
Sub PM_Close(ByRef objConn)
    On Error Resume Next
    If IsObject(objConn) Then
        If objConn.State <> 0 Then objConn.Close
        Set objConn = Nothing
    End If
    On Error GoTo 0
End Sub

'--- Devuelve un Recordset de solo lectura -------------------------------
Function PM_Query(ByVal strSQL)
    Dim objConn, objRS
    Set objConn = PM_Connection()
    Set objRS   = Server.CreateObject("ADODB.Recordset")
    objRS.CursorLocation = 3
    objRS.Open strSQL, objConn, 0, 1    ' adOpenForwardOnly, adLockReadOnly
    Set objRS.ActiveConnection = Nothing ' recordset desconectado
    PM_Close objConn
    Set PM_Query = objRS
End Function

'--- Ejecuta una sentencia que no devuelve filas -------------------------
Sub PM_Execute(ByVal strSQL)
    Dim objConn
    Set objConn = PM_Connection()
    objConn.Execute strSQL
    PM_Close objConn
End Sub

'--- Escapa comillas simples para SQL ------------------------------------
Function PM_SQL(ByVal vValor)
    If IsNull(vValor) Then
        PM_SQL = ""
    Else
        PM_SQL = Replace(CStr(vValor), "'", "''")
    End If
End Function

'--- Numero seguro para SQL ----------------------------------------------
Function PM_Num(ByVal vValor)
    Dim s
    s = Trim(CStr(vValor & ""))
    If Not IsNumeric(s) Then s = "0"
    PM_Num = CLng(s)
End Function

'--- Convierte rutas '~/xxx/yyy.ext' en rutas relativas del sitio --------
Function PM_Path(ByVal vRuta)
    Dim s
    s = Trim(CStr(vRuta & ""))
    If Left(s, 2) = "~/" Then s = Mid(s, 3)
    If s = "" Then s = "playlistImages/default.jpg"
    PM_Path = Replace(s, "\", "/")
End Function

'--- Salida segura a HTML -------------------------------------------------
Function PM_Html(ByVal vValor)
    If IsNull(vValor) Then
        PM_Html = ""
    Else
        PM_Html = Server.HTMLEncode(CStr(vValor))
    End If
End Function

'--- Condicional en linea (equivalente seguro a IIf) ----------------------
Function PM_If(ByVal bCondicion, ByVal vVerdadero, ByVal vFalso)
    If CBool(bCondicion) Then
        PM_If = vVerdadero
    Else
        PM_If = vFalso
    End If
End Function

'--- Parametro GET/POST ---------------------------------------------------
Function PM_Param(ByVal sNombre)
    Dim s
    s = Request.QueryString(sNombre)
    If s = "" Then s = Request.Form(sNombre)
    PM_Param = Trim(s & "")
End Function

'--- Portada de una cancion (imagen rotativa de la carpeta de assets) -----
Function PM_Cover(ByVal nIdSong)
    Dim n
    n = ((PM_Num(nIdSong) - 1) Mod 5) + 1
    If n < 1 Then n = 1
    PM_Cover = "playlistImages/playlist" & CStr(n) & ".png"
End Function
%>
