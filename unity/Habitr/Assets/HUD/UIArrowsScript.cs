using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UIElements;

public class UIArrowsScript : MonoBehaviour
{
    private Button leftButton, rightButton;

    [SerializeField]
    Camera m_Camera;
    // Start is called before the first frame update
    void Start()
    {
        var rootVisualElement = GetComponent<UIDocument>().rootVisualElement;
        leftButton = rootVisualElement.Q<Button>("LeftButton");
        rightButton = rootVisualElement.Q<Button>("RightButton");
        leftButton.RegisterCallback<ClickEvent>(ev => MoveCamera(-1));
        rightButton.RegisterCallback<ClickEvent>(ev => MoveCamera(1));
    }

    private void MoveCamera(int direction)
    {
        Vector3 movement;
        float hardLimitLeft = 35;
        float hardLimitRight = 55;
        Quaternion rotation;
        if (direction < 0 && m_Camera.transform.rotation.eulerAngles.y - 2.5 > hardLimitLeft) {
            movement = new Vector3(0, -2.5f, 0);
            
        } else if (direction > 0 && m_Camera.transform.rotation.eulerAngles.y + 2.5 < hardLimitRight)
        {
            movement = new Vector3(0, 2.5f, 0);
        } else
        {
            movement = Vector3.zero;
        }
        m_Camera.transform.Rotate(movement, Space.World);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
