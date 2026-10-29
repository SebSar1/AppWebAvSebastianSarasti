<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Song.aspx.cs" Inherits="WebAppPoliMusicV2.Song" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>PoliMusic - Song Library</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            color: #eee;
        }

        .navbar {
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(10px);
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar .logo {
            font-size: 24px;
            font-weight: 700;
            color: #e94560;
            letter-spacing: 1px;
        }

        .navbar .logo span {
            color: #eee;
        }

        .navbar .nav-links {
            display: flex;
            gap: 25px;
            align-items: center;
        }

        .navbar .nav-links a {
            color: #aaa;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s;
        }

        .navbar .nav-links a:hover {
            color: #e94560;
        }

        .navbar .user-badge {
            background: rgba(233, 69, 96, 0.2);
            border: 1px solid #e94560;
            border-radius: 20px;
            padding: 6px 16px;
            font-size: 13px;
            color: #e94560;
        }

        .container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        .page-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
            background: linear-gradient(90deg, #e94560, #f5a623);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .page-subtitle {
            font-size: 14px;
            color: #888;
            margin-bottom: 30px;
        }

        .upload-card {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 30px;
        }

        .upload-card h3 {
            font-size: 18px;
            margin-bottom: 20px;
            color: #e94560;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-size: 12px;
            color: #aaa;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input {
            background: rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 8px;
            padding: 12px 14px;
            color: #eee;
            font-size: 14px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #e94560;
            box-shadow: 0 0 0 3px rgba(233, 69, 96, 0.15);
        }

        .form-group-full {
            grid-column: 1 / -1;
        }

        .file-upload-wrapper {
            background: rgba(0, 0, 0, 0.3);
            border: 2px dashed rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            transition: border-color 0.3s, background 0.3s;
        }

        .file-upload-wrapper:hover {
            border-color: #e94560;
            background: rgba(233, 69, 96, 0.05);
        }

        .file-upload-wrapper input[type="file"] {
            display: inline-block;
        }

        .file-upload-hint {
            font-size: 12px;
            color: #666;
            margin-top: 8px;
        }

        .btn {
            border: none;
            border-radius: 8px;
            padding: 12px 28px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #e94560, #c73650);
            color: #fff;
            box-shadow: 0 4px 15px rgba(233, 69, 96, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(233, 69, 96, 0.4);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: #eee;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.15);
        }

        .btn-danger {
            background: rgba(220, 53, 69, 0.2);
            color: #ff6b6b;
            border: 1px solid rgba(220, 53, 69, 0.3);
            padding: 6px 14px;
            font-size: 12px;
            border-radius: 6px;
        }

        .btn-danger:hover {
            background: rgba(220, 53, 69, 0.35);
        }

        .btn-edit {
            background: rgba(0, 123, 255, 0.2);
            color: #4dabf7;
            border: 1px solid rgba(0, 123, 255, 0.3);
            padding: 6px 14px;
            font-size: 12px;
            border-radius: 6px;
        }

        .btn-edit:hover {
            background: rgba(0, 123, 255, 0.35);
        }

        .btn-row {
            grid-column: 1 / -1;
            display: flex;
            gap: 12px;
            margin-top: 10px;
        }

        .message-label {
            grid-column: 1 / -1;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            display: none;
        }

        .message-label.error {
            background: rgba(220, 53, 69, 0.15);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #ff6b6b;
            display: block;
        }

        .message-label.success {
            background: rgba(40, 167, 69, 0.15);
            border: 1px solid rgba(40, 167, 69, 0.3);
            color: #51cf66;
            display: block;
        }

        .search-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
        }

        .search-bar input {
            flex: 1;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 8px;
            padding: 12px 16px;
            color: #eee;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .search-bar input:focus {
            outline: none;
            border-color: #e94560;
        }

        .song-list-section {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            overflow: hidden;
        }

        .song-list-header {
            padding: 20px 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .song-list-header h3 {
            font-size: 18px;
            color: #e94560;
        }

        .song-count {
            font-size: 13px;
            color: #888;
            background: rgba(255, 255, 255, 0.05);
            padding: 4px 12px;
            border-radius: 20px;
        }

        .song-table {
            width: 100%;
            border-collapse: collapse;
        }

        .song-table thead th {
            background: rgba(0, 0, 0, 0.2);
            padding: 14px 20px;
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: #888;
            font-weight: 600;
        }

        .song-table tbody tr {
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: background 0.2s;
        }

        .song-table tbody tr:hover {
            background: rgba(233, 69, 96, 0.05);
        }

        .song-table tbody td {
            padding: 14px 20px;
            font-size: 14px;
            color: #ccc;
        }

        .song-table tbody td:first-child {
            color: #e94560;
            font-weight: 600;
        }

        .song-name-cell {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .song-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #e94560, #f5a623);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            color: #fff;
            flex-shrink: 0;
        }

        .plays-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            background: rgba(245, 166, 35, 0.2);
            color: #f5a623;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state .icon {
            font-size: 48px;
            margin-bottom: 16px;
        }

        .player-bar {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(15px);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding: 12px 30px;
            display: none;
            align-items: center;
            gap: 20px;
            z-index: 200;
        }

        .player-bar.active {
            display: flex;
        }

        .player-bar .now-playing {
            flex-shrink: 0;
            min-width: 200px;
        }

        .player-bar .now-playing .np-title {
            font-size: 14px;
            font-weight: 600;
            color: #eee;
        }

        .player-bar .now-playing .np-subtitle {
            font-size: 12px;
            color: #888;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .navbar {
                padding: 15px 20px;
            }
            .container {
                padding: 20px 15px;
            }
            .song-table thead {
                display: none;
            }
            .song-table, .song-table tbody, .song-table tr, .song-table td {
                display: block;
                width: 100%;
            }
            .song-table tr {
                margin-bottom: 10px;
                background: rgba(255, 255, 255, 0.03);
                border-radius: 10px;
                padding: 10px;
            }
            .song-table td {
                padding: 6px 10px;
                text-align: right;
            }
            .song-table td:first-child {
                text-align: left;
            }
        }
    </style>
</head>
<body>
    <form id="formSong" runat="server">
        <!-- NAVBAR -->
        <div class="navbar">
            <div class="logo">Poli<span>Music</span></div>
            <div class="nav-links">
                <asp:Label ID="lblUserInfo" runat="server" CssClass="user-badge" Text=""></asp:Label>
                <asp:LinkButton ID="lnkLogout" runat="server" OnClick="LnkLogout_Click" ForeColor="#aaa">Logout</asp:LinkButton>
            </div>
        </div>

        <!-- MAIN CONTENT -->
        <div class="container">
            <h1 class="page-title">Song Library</h1>
            <p class="page-subtitle">Manage your music collection - add, search, and play songs</p>

            <!-- UPLOAD / SAVE CARD -->
            <div class="upload-card">
                <h3>Add New Song</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Song Name *</label>
                        <asp:TextBox ID="txtSongName" runat="server" placeholder="Enter song name"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Plays</label>
                        <asp:TextBox ID="txtPlays" runat="server" placeholder="0" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group form-group-full">
                        <label>MP3 File *</label>
                        <div class="file-upload-wrapper">
                            <asp:FileUpload ID="fupSongFile" runat="server" />
                            <div class="file-upload-hint">Only .mp3 files are accepted. Max size: 50MB.</div>
                        </div>
                    </div>
                    <div class="btn-row">
                        <asp:Button ID="btnSave" runat="server" Text="Save Song" CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="BtnCancel_Click" />
                        <asp:HiddenField ID="hfSongId" runat="server" Value="0" />
                    </div>
                    <div class="form-group-full">
                        <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>
                    </div>
                </div>
            </div>

            <!-- SEARCH BAR -->
            <div class="search-bar">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search songs by name..."></asp:TextBox>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="BtnSearch_Click" />
                <asp:Button ID="btnShowAll" runat="server" Text="Show All" CssClass="btn btn-secondary" OnClick="BtnShowAll_Click" />
            </div>

            <!-- SONG LIST -->
            <div class="song-list-section">
                <div class="song-list-header">
                    <h3>All Songs</h3>
                    <span class="song-count"><asp:Label ID="lblSongCount" runat="server" Text="0"></asp:Label> songs</span>
                </div>
                <asp:Repeater ID="rptSongs" runat="server" OnItemCommand="RptSongs_ItemCommand">
                    <HeaderTemplate>
                        <table class="song-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Song Name</th>
                                    <th>Plays</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Container.ItemIndex + 1 %></td>
                            <td>
                                <div class="song-name-cell">
                                    <div class="song-icon">&#9835;</div>
                                    <span><%# Eval("SONG_NAME") %></span>
                                </div>
                            </td>
                            <td>
                                <span class="plays-badge"><%# Eval("PLAYS") %> plays</span>
                            </td>
                            <td>
                                <asp:LinkButton ID="lnkPlay" runat="server" CssClass="btn-edit" CommandName="Play" CommandArgument='<%# Eval("ID_SONG") %>'>&#9654; Play</asp:LinkButton>
                                <asp:LinkButton ID="lnkEdit" runat="server" CssClass="btn-edit" CommandName="EditSong" CommandArgument='<%# Eval("ID_SONG") %>'>Edit</asp:LinkButton>
                                <asp:LinkButton ID="lnkDelete" runat="server" CssClass="btn-danger" CommandName="DeleteSong" CommandArgument='<%# Eval("ID_SONG") %>'
                                    OnClientClick="return confirm('Are you sure you want to delete this song?');">Delete</asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlEmptyState" runat="server" Visible="false" CssClass="empty-state">
                    <div class="icon">&#9835;</div>
                    <p>No songs found. Upload your first song above!</p>
                </asp:Panel>
            </div>
        </div>

        <!-- PLAYER BAR -->
        <div id="playerBar" class="player-bar" runat="server">
            <div class="now-playing">
                <div class="np-title"><asp:Label ID="lblPlayerTitle" runat="server" Text=""></asp:Label></div>
                <div class="np-subtitle"><asp:Label ID="lblPlayerSubtitle" runat="server" Text=""></asp:Label></div>
            </div>
            <asp:Literal ID="litAudioPlayer" runat="server"></asp:Literal>
        </div>
    </form>
</body>
</html>
