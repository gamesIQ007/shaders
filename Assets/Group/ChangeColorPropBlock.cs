using UnityEngine;

public class ChangeColorPropBlock : MonoBehaviour
{
    [SerializeField] private new Renderer renderer;
    [SerializeField] private new string name;
    [SerializeField] private Color value;
    [SerializeField] private float offset;

    private void Update()
    {
        MaterialPropertyBlock props = new MaterialPropertyBlock();
        props.SetColor(name, value);
        props.SetFloat("_Offset", offset);
        renderer.SetPropertyBlock(props);
    }
}
