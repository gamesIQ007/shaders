using UnityEngine;

public class ChangeColor : MonoBehaviour
{
    [SerializeField] private new Renderer renderer;

    private void Update()
    {
        renderer.material.SetColor("_Color", Color.red);
    }
}
