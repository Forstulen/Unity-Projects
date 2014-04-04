using UnityEngine;
using System.Collections;

public class CometSpawnerScript : MonoBehaviour {

    // Public Variables
    public GameObject Comet;

    // Private Variables
    private float _min = 5.0f;
    private float _max = 15.0f;

    private float _timer = 0.0f;
    private float _nextSpawn;

	// Use this for initialization
	void Start () {
	    
	}
	
	// Update is called once per frame
	void Update () {
        this._timer += Time.deltaTime;

        if (this._timer >= this._nextSpawn)
        {
            UISprite sprite = this.Comet.GetComponent<UISprite>();

            sprite.color = new Color(Random.value, Random.value, Random.value, 0.4f);
            Vector3 tmp = this.gameObject.transform.position;

            //tmp.y += Random.Range(-100, 100);

            this.Comet.transform.position = tmp;
            TweenPosition.Begin(this.Comet, 0.5f, new Vector3(this.Comet.transform.position.x + 2000, 
                                                                this.Comet.transform.position.y + Random.Range(-100, 100), 
                                                                0));

            this._timer = 0.0f;
            this._nextSpawn = Random.Range(this._min, this._max);
        }
	}
}
