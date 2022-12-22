using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IK
{
    public class IKCollisionData : ScriptableObject
    {
        [System.Serializable]
        public class Parameter
        {
            public enum CollisionType
            {
                Sphere = 0
            }

            public enum Scene
            {
                Event = 1,
                Live = 2,
                All = 65535
            }


            public IKCollisionData.Parameter.CollisionType Type; // 0x10
            public string LinkBoneName; // 0x18
            public Vector3 Offset; // 0x20
            public IKCollisionData.Parameter.Scene SceneType; // 0x2C
            public float Param1; // 0x30
        }


        public IKCollisionData.Parameter[] ParameterArray; // 0x18
        public bool IsHeightScale; // 0x20
    }

}
