using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Gallop
{
	[System.Serializable]
	public class TRS
	{
		public string _path; // 0x10
		public bool _isValidScaleTransform; // 0x18
		public Vector3 _position; // 0x1C
		public Vector3 _scale; // 0x28
		public Vector3 _rotation; // 0x34
		public bool IsOverrideTarget; // 0x40
	}

	[System.Serializable]
	public class TargetGroupInfomation
	{
		public TRS[] _trsArray;
	}

	[System.Serializable]
	public class TargetInfomation
	{
		public TargetGroupInfomation[] _faceGroupInfo;
	}

	public class FaceDrivenKeyTarget : ScriptableObject
	{
		public TargetInfomation[] _eyeTarget; // 0x18
		public TargetInfomation[] _eyebrowTarget; // 0x20
		public TargetInfomation[] _mouthTarget; // 0x28
	}
}

