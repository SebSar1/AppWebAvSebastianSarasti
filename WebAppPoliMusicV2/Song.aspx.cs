using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAppPoliMusicV2
{
    public partial class Song : System.Web.UI.Page
    {
        private string strConnString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Entities.User currentUser = GetCurrentUser();
                if (currentUser == null)
                {
                    Response.Redirect("Login.aspx", true);
                    return;
                }
                lblUserInfo.Text = "Welcome, " + currentUser.UserName;
                txtPlays.Text = "0";
                LoadSongs();
            }
        }

        private Entities.User GetCurrentUser()
        {
            return Session[Util.Constants.USER] as Entities.User;
        }

        private void LoadSongs()
        {
            DataTable dtSongs = new BLL.Song(strConnString).Read();
            rptSongs.DataSource = dtSongs;
            rptSongs.DataBind();
            lblSongCount.Text = dtSongs.Rows.Count.ToString();
            pnlEmptyState.Visible = (dtSongs.Rows.Count == 0);
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string messageValidations = string.Empty;
            string songName = txtSongName.Text.Trim();
            int plays = 0;
            int.TryParse(txtPlays.Text.Trim(), out plays);

            string strSongFolder = ConfigurationManager.AppSettings["songFolderPath"];
            string newFileName = songName.Replace(" ", string.Empty);
            string strFileNameExtension = Path.GetExtension(fupSongFile.FileName);
            string songPath = "~/songFiles/" + newFileName + strFileNameExtension;

            Entities.Song song = new Entities.Song();
            song.SongName = songName;
            song.SongPath = songPath;
            song.Plays = plays;

            int songId = 0;
            int.TryParse(hfSongId.Value, out songId);
            song.ID = songId;

            messageValidations = new BLL.Song(strConnString).SongFieldsRequiredValidations(song);
            if (messageValidations != string.Empty)
            {
                ShowMessage(messageValidations, "error");
                return;
            }

            if (songId > 0)
            {
                // UPDATE existing song
                if (fupSongFile.HasFile)
                {
                    messageValidations = new FileManagement().SaveSongOnServer(fupSongFile, strSongFolder, newFileName);
                    if (messageValidations != string.Empty)
                    {
                        ShowMessage(messageValidations, "error");
                        return;
                    }
                }
                new BLL.Song(strConnString).Update(song);
                ShowMessage("Song updated successfully!", "success");
            }
            else
            {
                // INSERT new song
                if (!fupSongFile.HasFile)
                {
                    ShowMessage("Please select an MP3 file to upload.", "error");
                    return;
                }
                messageValidations = new FileManagement().SaveSongOnServer(fupSongFile, strSongFolder, newFileName);
                if (messageValidations != string.Empty)
                {
                    ShowMessage(messageValidations, "error");
                    return;
                }
                song.Plays = 0;
                new BLL.Song(strConnString).Save(song);
                ShowMessage("Song saved successfully!", "success");
            }

            ResetForm();
            LoadSongs();
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            if (string.IsNullOrEmpty(searchTerm))
            {
                LoadSongs();
                return;
            }
            DataTable dtSongs = new BLL.Song(strConnString).SearchByName(searchTerm);
            rptSongs.DataSource = dtSongs;
            rptSongs.DataBind();
            lblSongCount.Text = dtSongs.Rows.Count.ToString();
            pnlEmptyState.Visible = (dtSongs.Rows.Count == 0);
        }

        protected void BtnShowAll_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            LoadSongs();
        }

        protected void RptSongs_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Play")
            {
                int songId = Convert.ToInt32(e.CommandArgument);
                DataTable dtSong = new BLL.Song(strConnString).ReadById(songId);
                if (dtSong != null && dtSong.Rows.Count > 0)
                {
                    string songPath = dtSong.Rows[0]["SONG_PATH"].ToString();
                    string songName = dtSong.Rows[0]["SONG_NAME"].ToString();
                    string plays = dtSong.Rows[0]["PLAYS"].ToString();

                    lblPlayerTitle.Text = songName;
                    lblPlayerSubtitle.Text = plays + " plays";
                    playerBar.Attributes["class"] = "player-bar active";

                    string audioSrc = ResolveUrl(songPath);
                    litAudioPlayer.Text = "<audio controls=\"controls\" src=\"" + audioSrc + "\" style=\"flex:1;height:36px;\"></audio>";

                    new BLL.Song(strConnString).IncrementPlays(songId);
                }
            }
            else if (e.CommandName == "EditSong")
            {
                int songId = Convert.ToInt32(e.CommandArgument);
                DataTable dtSong = new BLL.Song(strConnString).ReadById(songId);
                if (dtSong != null && dtSong.Rows.Count > 0)
                {
                    hfSongId.Value = songId.ToString();
                    txtSongName.Text = dtSong.Rows[0]["SONG_NAME"].ToString();
                    txtPlays.Text = dtSong.Rows[0]["PLAYS"].ToString();
                    btnSave.Text = "Update Song";
                }
            }
            else if (e.CommandName == "DeleteSong")
            {
                int songId = Convert.ToInt32(e.CommandArgument);
                new BLL.Song(strConnString).Delete(songId);
                ShowMessage("Song deleted successfully!", "success");
                LoadSongs();
            }
        }

        protected void LnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Logout.aspx", true);
        }

        private void ResetForm()
        {
            hfSongId.Value = "0";
            txtSongName.Text = string.Empty;
            txtPlays.Text = "0";
            btnSave.Text = "Save Song";
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message-label " + type;
        }
    }
}
