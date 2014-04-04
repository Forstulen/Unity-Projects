using UnityEngine;
using System.Collections;

public class DissolutionValueScript : MonoBehaviour {

    public Material DissolutionMaterial;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        float disolve = Mathf.PingPong(Time.time, 1.0F);
        DissolutionMaterial.SetFloat("_DisolveAmount", disolve);
	}
}
