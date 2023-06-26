using FlutterUnityIntegration;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class PotUIScript : MonoBehaviour
{

    RectTransform rt;
    Camera m_Camera;
    UnityMessageManager m_MessageManager;
    int index = 0;
    // Start is called before the first frame update
    void Start()
    {
        m_Camera = Camera.main;
        m_MessageManager = GetComponent<UnityMessageManager>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnMouseDown()
    {

        var worldPos = transform.position;
        m_Camera.transform.LookAt(worldPos);
 
        m_MessageManager.SendMessageToFlutter("ChangeFlower," + index);
        // TODO: Improve this


    }
    public void SetIndex(int idx)
    {
        index = idx;
    }
}
