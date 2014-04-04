using UnityEngine;
using System.Collections;

public class DisplayOptionsScript : MonoBehaviour {

    // Public Variables
    public UILabel Music;
    public UILabel FX;
    public UILabel Subtitles;
    public UILabel Difficulty;

	// Use this for initialization
	void Start () {
        this.DisplayOptions();
	}

    void DisplayOptions()
    {
        Music.text = "Music level " + PlayerPrefs.GetFloat("Music").ToString();
        FX.text = "FX level " + PlayerPrefs.GetFloat("FX").ToString();
        Subtitles.text = "Subtitles is set with " + PlayerPrefs.GetInt("Subtitles").ToString();
        Difficulty.text = "Difficulty level " + PlayerPrefs.GetString("Difficulty");
    }
}
