using UnityEngine;
using System.Collections;

public class MenuActionScript : MonoBehaviour {

    public string Level;

    public void QuitGame()
    {
        Application.Quit();
    }

    public void LoadScene()
    {
        Application.LoadLevelAsync(this.Level);
    }
}
