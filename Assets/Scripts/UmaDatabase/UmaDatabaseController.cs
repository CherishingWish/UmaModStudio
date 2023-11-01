using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mono.Data.Sqlite;
using static TMPro.SpriteAssetUtilities.TexturePacker_JsonArray;

public class UmaDatabaseController
{


    private static UmaDatabaseController instance;

    /// <summary>
    /// Database Loader instance
    /// </summary>
    public static UmaDatabaseController Instance
    {
        get
        {
            if (instance == null)
            {
                instance = new UmaDatabaseController();
            }
            return instance;
        }
    }


    public IEnumerable<UmaDatabaseEntry> MetaEntries;

    public string MainPath;

    private SqliteConnection metaDb;

    public static string CharaPath = "3d/chara/";
    public static string CharaBodyPath = "3d/chara/body";
    public static string CharaHeadPath = "3d/chara/head";
    public static string CharaTexPath = "sourceresources/3d/chara";

    // Start is called before the first frame update
    public UmaDatabaseController()
    {
        MainPath = $@"{Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData) + "Low"}\Cygames\umamusume";
        metaDb = new SqliteConnection($@"Data Source={MainPath}\meta;");
        Debug.Log(MainPath);

        metaDb.Open();
        MetaEntries = ReadMeta(metaDb);
    }

    static IEnumerable<UmaDatabaseEntry> ReadMeta(SqliteConnection conn)
    {
        List<UmaDatabaseEntry> entries = new List<UmaDatabaseEntry>();
        SqliteCommand sqlite_cmd = conn.CreateCommand();
        sqlite_cmd.CommandText = "SELECT m,n,h,c,d FROM a";
        SqliteDataReader sqlite_datareader = sqlite_cmd.ExecuteReader();
        while (sqlite_datareader.Read())
        {
            try
            {
                UmaDatabaseEntry entry = new UmaDatabaseEntry()
                {
                    Type = (UmaFileType)Enum.Parse(typeof(UmaFileType), sqlite_datareader["m"] as String),
                    Name = sqlite_datareader["n"] as String,
                    Url = sqlite_datareader["h"] as String,
                    Checksum = sqlite_datareader["c"].ToString(),
                    Prerequisites = sqlite_datareader["d"] as String
                };
                entries.Add(entry);
            }
            catch (Exception e) { Debug.LogError("Error caught: " + e); }
        }
        return entries;
    }
}
