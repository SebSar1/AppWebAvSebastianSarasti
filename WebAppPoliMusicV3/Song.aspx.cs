using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAppPoliMusicV3
{
    public partial class Song : System.Web.UI.Page
    {
        private string strConnString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                LoadSongs();
            }
        }

        private void LoadSongs()
        {
            try
            {
                DataTable dtSongs = new BLL.PoliMusicV3.Song(strConnString).Read();

                if (dtSongs != null && dtSongs.Rows.Count > 0)
                {
                    rptSongs.DataSource = dtSongs;
                    rptSongs.DataBind();
                    lblSongCount.Text = dtSongs.Rows.Count.ToString();
                    pnlEmpty.Visible = false;
                }
                else
                {
                    rptSongs.DataSource = null;
                    rptSongs.DataBind();
                    lblSongCount.Text = "0";
                    pnlEmpty.Visible = true;
                }

                pnlError.Visible = false;
            }
            catch (Exception ex)
            {
                rptSongs.DataSource = null;
                rptSongs.DataBind();
                lblSongCount.Text = "0";
                pnlEmpty.Visible = false;
                lblErrorMessage.Text = "Error loading songs from database: " + ex.Message;
                pnlError.Visible = true;
            }
        }
    }
}
