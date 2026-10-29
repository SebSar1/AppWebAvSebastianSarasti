using System;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace WebAppPoliMusicV2.BLL
{
    public class Song
    {
        private string strConnectionString;
        public Song(string strConnString)
        {
            strConnectionString = strConnString;
        }

        public int Save(Entities.Song song)
        {
            return new DAL.Song(strConnectionString).Save(song);
        }

        public DataTable Read()
        {
            return new DAL.Song(strConnectionString).Read();
        }

        public DataTable ReadById(int idSong)
        {
            return new DAL.Song(strConnectionString).ReadById(idSong);
        }

        public int Update(Entities.Song song)
        {
            return new DAL.Song(strConnectionString).Update(song);
        }

        public int Delete(int idSong)
        {
            return new DAL.Song(strConnectionString).Delete(idSong);
        }

        public DataTable SearchByName(string songName)
        {
            return new DAL.Song(strConnectionString).SearchByName(songName);
        }

        public int IncrementPlays(int idSong)
        {
            return new DAL.Song(strConnectionString).IncrementPlays(idSong);
        }

        public string SongFieldsRequiredValidations(Entities.Song song)
        {
            if (song.SongName == string.Empty || song.SongName == null)
            {
                return "Song name is required!";
            }
            if (song.SongPath == string.Empty || song.SongPath == null)
            {
                return "Song file is required!";
            }
            return string.Empty;
        }
    }
}
