using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Xml;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UIElements;

public class PotHandler : MonoBehaviour
{
    public enum FlowerTypes
    {
        SaffyRed,
        SaffyBlue,
        SaffyOrange,
        Hibiscus,
        Rose,
        Sunflower,
        Dandelion
    }
    [SerializeField]
    GameObject hibiscusPrefab;
    [SerializeField]
    GameObject rosePrefab;
    [SerializeField]
    GameObject saffyRedPrefab;
    [SerializeField]
    GameObject saffyBluePrefab;
    [SerializeField]
    GameObject saffyOrangePrefab;
    [SerializeField]
    GameObject dandelionPrefab;
    [SerializeField]
    GameObject sunflowerPrefab;
    // Start is called before the first frame update
    [SerializeField]
    List<GameObject> pots;
    [SerializeField]
    List<bool> unlocks;
    [SerializeField]
    List<FlowerTypes> potFlowers;
    
    List<GameObject> potFlowerObjects = new List<GameObject>( new GameObject[16]);
    void Start()
    {
        for (int i = 0; i < 16; i++)
        {
            if (unlocks[i])
            {
                pots[i].SetActive(true);
                pots[i].SendMessage("SetIndex", i);
                if (i > potFlowers.Count - 1) continue; // No flowers for current pot
                Vector3 pos = pots[i].transform.position;
                if (potFlowerObjects.Count >= i && potFlowerObjects[i] != null)
                {
                    Destroy(potFlowerObjects[i]);
                }
                instantiateFlower(i, potFlowers[i]);
            }
        }
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void UnlockFlowers(String _numberOfUnlocks)
    {
        int numberOfUnlocks = int.Parse(_numberOfUnlocks);
        for (int i = 0; i < numberOfUnlocks; i++) {
            unlocks[i] = true;
        }
        for (int j = 16; j > numberOfUnlocks; j--)
        {
            unlocks[j] = false;
        }
    }
    public void ChangeFlowers(String _flowers) {
        int[] flowers = new int[16];
        var strArr = _flowers.Split(',');
        for (int i = 0; i < strArr.Length && i < 16; i++)  
        {
            flowers[i] = int.Parse(strArr[i]);
        }
        FlowerTypes tmp = FlowerTypes.SaffyRed;
        Array enumValues = Enum.GetValues(tmp.GetType());
        for (int i = 0; i < flowers.Length; i++)
        {
            if (potFlowerObjects.Count >= i && potFlowerObjects[i] != null)
            {
                Destroy(potFlowerObjects[i]);
            }
            if (unlocks[i])
            {
                instantiateFlower(i, (FlowerTypes)enumValues.GetValue(flowers[i]));
            }
        }
    }

    void instantiateFlower(int index, FlowerTypes type)
    {
        // Si, todas las posiciones y rotaciones de las flores estan hardcodeadas.
        // Tenía prisa y no soy bueno con Unity ni modelado 3D, y algunos de los modelos tenían el origen mal puesto.
        pots[index].SetActive(true);
        GameObject potFlower;
        Vector3 pos = pots[index].transform.position;
        Quaternion rotation = pots[index].transform.rotation;  
        bool left = isLeft(index);

        switch (type)
        {
            case FlowerTypes.Rose:
                potFlower = Instantiate(rosePrefab);
                pos.x = pos.x - 1f;
                pos.y = pos.y + 5;
                pos.z = pos.z - 1;
                potFlowerObjects[index] = potFlower;
                potFlower.transform.SetPositionAndRotation(pos, rotation);
                break;
            case FlowerTypes.Hibiscus:
                potFlower = Instantiate(hibiscusPrefab);
                pos.x = pos.x - 1;
                pos.y = pos.y + 5;
                pos.z = pos.z - 1;
                potFlowerObjects[index] = potFlower;
                potFlower.transform.SetPositionAndRotation(pos, rotation);
                break;
            case FlowerTypes.SaffyRed:
                potFlower = Instantiate(saffyRedPrefab);
                if (left)
                {
                    pos.y = pos.y + 3;
                    pos.x = pos.x + 2.5f;
                    pos.z = pos.z - 2;
                } else
                {
                    pos.y = pos.y + 3f;
                    pos.x = pos.x + 2f;
                    pos.z = pos.z + 2f;
                }
                potFlowerObjects[index] = potFlower;
                potFlower.transform.SetPositionAndRotation(pos, rotation);
                break;
            case FlowerTypes.SaffyBlue:
                potFlower = Instantiate(saffyBluePrefab);
                if (left)
                {
                    pos.x = pos.x + 2;
                    pos.y = pos.y + 5;
                    pos.z = pos.z + 1;
                } else
                {
                    Debug.Log("NotLeft Blue");
                    pos.x = pos.x - 1;
                    pos.y = pos.y + 2.5f;
                    pos.z = pos.z + 3; 
                }

                potFlowerObjects[index] = potFlower;
                potFlower.transform.SetPositionAndRotation(pos, rotation);
                break;
            case FlowerTypes.SaffyOrange:
                potFlower = Instantiate(saffyOrangePrefab);
                if (left)
                {
                    pos.x = pos.x - 1;
                    pos.y = pos.y + 3;
                    pos.z = pos.z - 1;
                } else
                {
                    Debug.Log("NotLeft Orange");
                    pos.x = pos.x + 4;
                    pos.y = pos.y + 3;
                    pos.z = pos.z - 2;
                }

                potFlowerObjects[index] = potFlower;
                potFlower.transform.SetPositionAndRotation(pos, rotation);
                break;
            case FlowerTypes.Dandelion:
                potFlower = Instantiate(dandelionPrefab);
                pos.x = pos.x + 1;
                pos.y = pos.y + 5;
                if (!left)
                {
                    pos.x = pos.x - 2f;
                    rotation.SetEulerAngles(0, (float)Math.PI / 2, 0);
                }
                potFlowerObjects[index] = potFlower;
                potFlower.transform.SetPositionAndRotation(pos, rotation);
                break;

            case FlowerTypes.Sunflower:
                potFlower = Instantiate(sunflowerPrefab);
                pos.x = pos.x - 1f;
                pos.y = pos.y + 5;
                pos.z = pos.z - 1;
                if (left)
                {
                    rotation.SetEulerAngles(0, (float)Math.PI, 0);
                }
                potFlowerObjects[index] = potFlower;
                potFlower.transform.SetPositionAndRotation(pos, rotation);
                break;
            default:
                Debug.Log("InstantiateFlowers Called with invalid index.");
                break;
        }
        
    }
    bool isLeft(int x)
    {
        return x < 4 || (x > 7 && x < 12);
    }
}
