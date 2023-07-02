using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;


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
                GameObject potFlower;
                if (i > potFlowers.Count - 1) continue; // No flowers for current pot
                Vector3 pos = pots[i].transform.position;
                if (potFlowerObjects.Count >= i && potFlowerObjects[i] != null)
                {
                    DestroyImmediate(potFlowerObjects[i]);
                }
                switch (potFlowers[i]) {
                    // TODO: Make them children of their pot. I give up.
                    case FlowerTypes.Rose:
                        potFlower = Instantiate(rosePrefab);
                        pos.x = pos.x - 1f;
                        pos.y = pos.y + 5;
                        pos.z = pos.z - 1;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        potFlowerObjects[i] = potFlower;
                        break;
                    case FlowerTypes.Hibiscus:
                        potFlower = Instantiate(hibiscusPrefab);
                        pos.x = pos.x - 1;
                        pos.y = pos.y + 5;
                        pos.z = pos.z - 1;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        potFlowerObjects[i] = potFlower;
                        break;
                    //TODO: Fix position for saffy flowers
                    case FlowerTypes.SaffyRed:
                        potFlower = Instantiate(saffyRedPrefab);
                        pos.y = pos.y + 3;
                        pos.x = pos.x + 2.5f;
                        pos.z = pos.z - 2;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        potFlowerObjects[i] = potFlower;
                        break;
                    case FlowerTypes.SaffyBlue:
                        potFlower = Instantiate(saffyBluePrefab);
                        pos.x = pos.x + 2;
                        pos.y = pos.y + 5;
                        pos.z = pos.z + 1;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        potFlowerObjects[i] = potFlower;
                        break;
                    case FlowerTypes.SaffyOrange:
                        potFlower = Instantiate(saffyOrangePrefab);
                        pos.x = pos.x - 1;
                        pos.y = pos.y + 3;
                        pos.z = pos.z - 1;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        potFlowerObjects[i] = potFlower;
                        break;
                    case FlowerTypes.Dandelion:
                        potFlower = Instantiate(dandelionPrefab);
                        pos.x = pos.x + 1;
                        pos.y = pos.y + 5;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        potFlowerObjects[i] = potFlower;
                        break;

                    case FlowerTypes.Sunflower:
                        potFlower = Instantiate(sunflowerPrefab);
                        pos.x = pos.x - 1f;
                        pos.y = pos.y + 5;
                        pos.z = pos.z - 1;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        potFlowerObjects[i] = potFlower;
                        break;
                    default:
                        break;

                }
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

                pots[i].SetActive(true);
                GameObject potFlower;
                if (i > potFlowers.Count - 1) continue; // No flowers for current pot
                Vector3 pos = pots[i].transform.position;
                
                switch (enumValues.GetValue(flowers[i]))
                {
                    // TODO: Make them children of their pot. I give up.
                    case FlowerTypes.Rose:
                        potFlower = Instantiate(rosePrefab);
                        pos.x = pos.x - 1f;
                        pos.y = pos.y + 5;
                        pos.z = pos.z - 1;
                        potFlowerObjects[i] = potFlower;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        break;
                    case FlowerTypes.Hibiscus:
                        potFlower = Instantiate(hibiscusPrefab);
                        pos.x = pos.x - 1;
                        pos.y = pos.y + 5;
                        pos.z = pos.z - 1;
                        potFlowerObjects[i] = potFlower;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        break;
                    //TODO: Fix position for saffy flowers
                    case FlowerTypes.SaffyRed:
                        potFlower = Instantiate(saffyRedPrefab);
                        pos.y = pos.y + 3;
                        pos.x = pos.x + 2.5f;
                        pos.z = pos.z - 2;
                        potFlowerObjects[i] = potFlower;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        break;
                    case FlowerTypes.SaffyBlue:
                        potFlower = Instantiate(saffyBluePrefab);
                        pos.x = pos.x + 2;
                        pos.y = pos.y + 5;
                        pos.z = pos.z + 1;
                        potFlowerObjects[i] = potFlower;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        break;
                    case FlowerTypes.SaffyOrange:
                        potFlower = Instantiate(saffyOrangePrefab);
                        pos.x = pos.x - 1;
                        pos.y = pos.y + 3;
                        pos.z = pos.z - 1;
                        potFlowerObjects[i] = potFlower;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        break;
                    case FlowerTypes.Dandelion:
                        potFlower = Instantiate(dandelionPrefab);
                        pos.x = pos.x + 1;
                        pos.y = pos.y + 5;
                        potFlowerObjects[i] = potFlower;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        break;

                    case FlowerTypes.Sunflower:
                        potFlower = Instantiate(sunflowerPrefab);
                        pos.x = pos.x - 1f;
                        pos.y = pos.y + 5;
                        pos.z = pos.z - 1;
                        potFlowerObjects[i] = potFlower;
                        potFlower.transform.SetPositionAndRotation(pos, pots[i].transform.rotation);
                        break;
                    default:
                        Debug.Log("Found flower with no corresponding index: " + flowers[i].ToString());
                        break;

                }
            }
        }
    }
}
