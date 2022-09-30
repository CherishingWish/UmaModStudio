using UnityEngine;
using UnityEditor;

class SelectAllOfTagMesh : ScriptableWizard
{

    string tagName = "ExampleTag";


    [MenuItem("Mesh/Combine")]
    static void SelectAllOfTagSingleWizard()
    {
        ScriptableWizard.DisplayWizard(
            "Mesh/Combine",
            typeof(SelectAllOfTagMesh),
            "Combine");
    }

    void OnWizardCreate()
    {
        Vector4 col1 = new Vector4(1, 0, 0, 0);
        Vector4 col2 = new Vector4(0, 1, 0, 0);
        Vector4 col3 = new Vector4(0, 0, 1, 0);
        Vector4 col4 = new Vector4(0, 0, 0, 1);

        Matrix4x4 baseMatrix = new Matrix4x4(col1, col2, col3, col4);
        Debug.Log(baseMatrix.m00);

        CombineInstance[] combineInstances = new CombineInstance[2];

        combineInstances[0].mesh = (Mesh)Selection.objects[0];
        combineInstances[1].mesh = (Mesh)Selection.objects[1];

        combineInstances[0].transform = baseMatrix;
        combineInstances[1].transform = baseMatrix;

        Mesh newMesh = new Mesh();
        newMesh.name = "newMesh";

        newMesh.CombineMeshes(combineInstances, false);

        AssetDatabase.CreateAsset(newMesh, "Assets/combine.asset");
    }
}