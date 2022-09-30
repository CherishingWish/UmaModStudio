using UnityEngine;
using UnityEditor;

class SelectAllOfTagCombine : ScriptableWizard
{
    public GameObject from;
    public GameObject to;

    string tagName = "ExampleTag";


    [MenuItem("Example/Combine")]
    static void SelectAllOfTagCombineWizard()
    {
        ScriptableWizard.DisplayWizard(
            "Example/Combine",
            typeof(SelectAllOfTagCombine),
            "Make Selection");
    }

    void OnWizardCreate()
    {

        Transform[] fromList = from.GetComponentsInChildren<Transform>();
        Transform[] toList = to.GetComponentsInChildren<Transform>();

        foreach(Transform a in fromList)
        {
            foreach(Transform b in toList)
            {
                if(a.name == b.name)
                {
                    a.position = b.position;
                    a.SetParent(b);
                }
            }
        }

    }
}