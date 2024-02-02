using UnityEngine;

public class EnableHologram : MonoBehaviour
{
    [SerializeField] private new Renderer renderer;
    [SerializeField] private new string name;
    [SerializeField] [Range(0, 1)] private float amount;

    [SerializeField] private float activateTime;

    private bool activeHolo;
    private float timer;


    private void Start()
    {
        activeHolo = false;
        timer = activateTime;
    }

    private void Update()
    {
        timer -= Time.deltaTime;

        if (timer <= 0)
        {
            activeHolo = !activeHolo;
            timer = activateTime;
            float newAmount = 0;
            if (activeHolo)
            {
                newAmount = amount;
            }
            else
            {
                newAmount = 0;
            }

            MaterialPropertyBlock props = new MaterialPropertyBlock();
            props.SetFloat(name, newAmount);
            renderer.SetPropertyBlock(props);
        }
    }
}
