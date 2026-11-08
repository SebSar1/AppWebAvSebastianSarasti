<%@ Page Title="Songs" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Song.aspx.cs" Inherits="WebAppPoliMusicV3.Song" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row mb-4 mt-3">
        <div class="col-md-8">
            <h2 class="fw-bold">Song Library</h2>
            <p class="text-muted">Browse and play your music collection.</p>
        </div>
        <div class="col-md-4 text-end">
            <span class="badge bg-secondary fs-6">
                <asp:Label ID="lblSongCount" runat="server" Text="0"></asp:Label>
                songs
            </span>
        </div>
    </div>

    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
        <asp:Label ID="lblErrorMessage" runat="server" Text=""></asp:Label>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <asp:Repeater ID="rptSongs" runat="server">
        <HeaderTemplate>
            <div class="table-responsive">
                <table class="table table-hover table-striped align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col" style="width: 60px;">#</th>
                            <th scope="col">Song Name</th>
                            <th scope="col" style="width: 100px;">Plays</th>
                            <th scope="col" style="width: 350px;">Player</th>
                        </tr>
                    </thead>
                    <tbody>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
                <td class="fw-bold text-primary"><%# Container.ItemIndex + 1 %></td>
                <td>
                    <i class="bi bi-music-note-beamed text-primary me-2"></i>
                    <%# Eval("SONG_NAME") %>
                </td>
                <td>
                    <span class="badge bg-warning text-dark"><%# Eval("PLAYS") %> plays</span>
                </td>
                <td>
                    <audio controls preload="none" style="width: 100%; height: 36px;"
                        src='<%# ResolveUrl(Eval("SONG_PATH").ToString()) %>'></audio>
                </td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
                    </tbody>
                </table>
            </div>
        </FooterTemplate>
    </asp:Repeater>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="text-center py-5">
        <i class="bi bi-music-note-list display-1 text-muted"></i>
        <p class="text-muted mt-3">No songs found in the database.</p>
    </asp:Panel>

</asp:Content>
