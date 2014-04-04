using UnityEngine;
using System.Collections;

public class OptionsScript : MonoBehaviour {

    // Public Variables
    public UISlider Music;
    public UISlider FX;
    public UIToggle Subtitles;
    public UILabel  Difficulty;

    public void SetMusic()
    {
        PlayerPrefs.SetFloat("Music", Music.value);
        PlayerPrefs.Save();
    }

    public void SetFX()
    {
        PlayerPrefs.SetFloat("FX", FX.value);
        PlayerPrefs.Save();
    }

    public void SetSubtitles()
    {
        PlayerPrefs.SetInt("Subtitles", (Subtitles.value == true) ? 1 : 0);
        PlayerPrefs.Save();
    }

    public void SetDifficulty()
    {
        PlayerPrefs.SetString("Difficulty", Difficulty.text);
        PlayerPrefs.Save();
    }

    public void LoadValue()
    {
        Music.value = PlayerPrefs.GetFloat("Music");
        FX.value = PlayerPrefs.GetFloat("FX");
        Subtitles.value = (PlayerPrefs.GetInt("Subtitles") == 1);
        Difficulty.text = PlayerPrefs.GetString("Difficulty");
    }
}
