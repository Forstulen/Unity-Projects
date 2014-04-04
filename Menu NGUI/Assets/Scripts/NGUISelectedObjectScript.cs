using UnityEngine;
using System.Collections;

public class NGUISelectedObjectScript : MonoBehaviour {

    // Public Variables
    public GameObject SelectedObject;

    public void SelectObject()
    {
        UICamera.selectedObject = this.SelectedObject;
    }
}
