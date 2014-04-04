using UnityEngine;
using System.Collections;

public class MouseOrbitScript : MonoBehaviour {

    public GameObject Camera;
    public GameObject Light;
    public GameObject Target;
    public UILabel Text;

    private Vector3 _position1;
    private Quaternion _rotation1;

    private Vector3 _position2;
    private Quaternion _rotation2;

    private GameObject _object;
    private bool _bool = true;

    void Start()
    {
        this._position1 = this.Camera.transform.position;
        this._rotation1 = this.Camera.transform.rotation;

        this._position2 = this.Light.transform.position;
        this._rotation2 = this.Light.transform.rotation;

        this._object = this.Camera;
    }

    void OnDrag (Vector2 delta)
    {
        Vector3 axis = new Vector3(-delta.y, delta.x, 0);

        this._object.transform.RotateAround(Target.transform.position, axis, 100 * Time.deltaTime);
    }

    public void ChangeTarget()
    {
        if (this._bool)
        {
            this._object = this.Light;
            this.Text.text = "Rotate Camera";
        }
        else
        {
            this._object = this.Camera;
            this.Text.text = "Rotate Light";
        }
        this._bool = !this._bool;
    }

    public void Reset()
    {
        this.Camera.transform.position = this._position1;
        this.Camera.transform.rotation = this._rotation1;

        this.Light.transform.position = this._position2;
        this.Light.transform.rotation = this._rotation2;
    }
}
