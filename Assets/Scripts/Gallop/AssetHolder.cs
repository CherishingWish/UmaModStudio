using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

namespace Gallop
{

	[System.Serializable]
	public abstract class KeyAndValue<TKey, TValue>
	{
		public TKey Key;
		public TValue Value;
	}

	[System.Serializable]
	public class TableBase<TKey, TValue, Type>
	{
		[SerializeField] // RVA: 0x1EC0 Offset: 0x1EC0 VA: 0x7FFD44411EC0
		public List<Type> list; // 0x0
		public Dictionary<TKey, TValue> _dataDic; // 0x0
	}

	public class AssetHolder : MonoBehaviour
	{
		[System.Serializable]
		public class StringObjectPair : KeyAndValue<string, Object>
		{

		}

		[System.Serializable]
		public class StringValuePair : KeyAndValue<string, float>
		{

		}

		[System.Serializable]
		public class AssetTable : TableBase<string, Object, AssetHolder.StringObjectPair>{

		}

		[System.Serializable]
		public class AssetTableValue : TableBase<string, float, AssetHolder.StringValuePair>
		{

		}

		public const float BOOL_THRESHOLD = 0.5f;
		public const string ASSET_HOLDER_KEY_HAIR_STYLE = "hair_style";
		[SerializeField] // RVA: 0x1EC0 Offset: 0x1EC0 VA: 0x7FFD44411EC0
		public AssetHolder.AssetTable _assetTable; // 0x18
		[SerializeField] // RVA: 0x1EC0 Offset: 0x1EC0 VA: 0x7FFD44411EC0
		public AssetHolder.AssetTableValue _assetTableValue; // 0x20
	}
}

