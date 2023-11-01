using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using Gallop.Live.Cutt;
using System;
using UnityEngine.XR;

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
        [InlineButton("UploadToMouth", "上传", ShowIf = "@_isBase && _isMouth")]
        [InlineButton("DelAll", "清空")]
        [InlineButton("Record", "记录")]
        [InlineButton("Preview", "预览")]
        public List<TRS> _trsArray;

        private bool _isBase = false;
        private bool _isMouth = false;
        private bool _isEyeL = false;
        private bool _isEyeR = false;
        private bool _isEyebrowL = false;
        private bool _isEyebrowR = false;


        private void Preview()
        {
			
			if(FaceDrivenKeyTarget.TargetObj == null || FaceDrivenKeyTarget.objs == null)
			{
				Debug.Log("请先指定要应用表情的对象!");
				return;
			}
			else
			{
                Debug.Log(FaceDrivenKeyTarget.objs[0].name == "pfb_chr1024_00(Clone)");
                Debug.Log(_isBase);
                for (int n = 0; n < _trsArray.Count; n++)
                {
                    foreach(Transform obj in FaceDrivenKeyTarget.objs)
                    {
                        if(obj.name == _trsArray[n]._path)
                        {
                            if (!(_trsArray[n].IsOverrideTarget || _isBase))
                            {
                                obj.localPosition += _trsArray[n]._position;
                                obj.localEulerAngles += fromMaya(_trsArray[n]._rotation);
                                obj.localScale += _trsArray[n]._scale;
                            }
                            else
                            {
                                obj.localPosition = _trsArray[n]._position;
                                obj.localEulerAngles = fromMaya(_trsArray[n]._rotation);
                                obj.localScale = _trsArray[n]._scale;
                            }
                            
                            break;
                        }
                    }
                }
            }
			
        }


        //怎么感觉用处不大的样子...这个
        private void DelAll()
        {
            _trsArray.Clear();
        }

        private void Record()
        {
            List<Vector3> newTrans = new List<Vector3>();
            List<Quaternion> newRots = new List<Quaternion>();
            List<Vector3> newScal = new List<Vector3>();

            if (FaceDrivenKeyTarget.TargetObj == null || FaceDrivenKeyTarget.objs == null)
            {
                Debug.Log("请先指定要记录表情的对象!");
                return;
            }
            else
            {
                _trsArray.Clear();

                List<Transform> _useObjs = null;

                if (_isMouth)
                {
                    _useObjs = FaceDrivenKeyTarget.mouthObjs;
                }

                if (_useObjs != null)
                {
                    for (int i = 0; i < _useObjs.Count; i++)
                    {

                        if (_isBase)
                        {
                            var newTRS = new TRS();
                            newTRS._path = _useObjs[i].name;
                            newTRS._isValidScaleTransform = false;
                            newTRS._position = _useObjs[i].localPosition;
                            newTRS._scale = _useObjs[i].localScale;
                            newTRS._rotation = toMaya(_useObjs[i].localRotation);
                            newTRS.IsOverrideTarget = false;

                            _trsArray.Add(newTRS);
                        }
                        else
                        {
                            var newTRS = new TRS();
                            newTRS._path = _useObjs[i].name;
                            newTRS._isValidScaleTransform = false;
                            newTRS._position = _useObjs[i].localPosition - FaceDrivenKeyTarget.oriTrans[_useObjs[i]];
                            newTRS._scale = _useObjs[i].localScale - FaceDrivenKeyTarget.oriScal[_useObjs[i]];
                            newTRS._rotation = toMaya(_useObjs[i].localRotation) - toMaya(FaceDrivenKeyTarget.oriRots[_useObjs[i]]);
                            newTRS.IsOverrideTarget = false;

                            _trsArray.Add(newTRS);
                        }
                    }
                }
            }
        }

        public static Vector3 fromMaya(Vector3 euler_angle)
        {
            euler_angle.x *= Mathf.Deg2Rad;
            euler_angle.y *= Mathf.Deg2Rad;
            euler_angle.z *= Mathf.Deg2Rad;

            float c = Mathf.Cos(euler_angle[0] / 2);
            float d = Mathf.Cos(euler_angle[1] / 2);
            float e = Mathf.Cos(euler_angle[2] / 2);
            float f = Mathf.Sin(euler_angle[0] / 2);
            float g = Mathf.Sin(euler_angle[1] / 2);
            float h = Mathf.Sin(euler_angle[2] / 2);

            float x = f * d * e - c * g * h;
            float y = c * g * e + f * d * h;
            float z = c * d * h - f * g * e;
            float w = c * d * e + f * g * h;

            Vector3 realAngle = new Quaternion(x, y, z, w).eulerAngles;
            if (realAngle.x > 180) realAngle.x -= 360;
            if (realAngle.y > 180) realAngle.y -= 360;
            if (realAngle.z > 180) realAngle.z -= 360;

            return realAngle;
        }

        public static Quaternion fromMayaQ(Vector3 euler_angle)
        {
            euler_angle.x *= Mathf.Deg2Rad;
            euler_angle.y *= Mathf.Deg2Rad;
            euler_angle.z *= Mathf.Deg2Rad;

            float c = Mathf.Cos(euler_angle[0] / 2);
            float d = Mathf.Cos(euler_angle[1] / 2);
            float e = Mathf.Cos(euler_angle[2] / 2);
            float f = Mathf.Sin(euler_angle[0] / 2);
            float g = Mathf.Sin(euler_angle[1] / 2);
            float h = Mathf.Sin(euler_angle[2] / 2);

            float x = f * d * e - c * g * h;
            float y = c * g * e + f * d * h;
            float z = c * d * h - f * g * e;
            float w = c * d * e + f * g * h;

            return new Quaternion(x, y, z, w);
            
        }

        public static Vector3 threeaxisrot(double r11, double r12, double r21, double r31, double r32)
        {
            Vector3 res = new Vector3();
            res[0] = (float)Math.Atan2(r31, r32) * Mathf.Rad2Deg;
            res[1] = (float)Math.Asin(r21) * Mathf.Rad2Deg;
            res[2] = (float)Math.Atan2(r11, r12) * Mathf.Rad2Deg;
            return res;
        }

        public static Vector3 toMaya(Quaternion q)
        {
            double x = (double)q.x;
            double y = (double)q.y;
            double z = (double)q.z;
            double w = (double)q.w;

            double a = 2 * (x * y + w * z);
            double b = w * w + x * x - y * y - z * z;
            double c = -2 * (x * z - w * y);
            double d = 2 * (y * z + w * x);
            double e = w * w - x * x - y * y + z * z;

            return threeaxisrot(a, b, c, d, e);
        }

        public void UploadToMouth()
        {
            if (FaceDrivenKeyTarget.TargetObj == null || FaceDrivenKeyTarget.objs == null)
            {
                Debug.Log("请先指定要记录表情的对象!");
            }
            else
            {
                FaceDrivenKeyTarget.mouthObjs.Clear();
                foreach (var trs in _trsArray)
                {
                    for(int i = 0; i < FaceDrivenKeyTarget.objs.Count; i++)
                    {
                        if(trs._path == FaceDrivenKeyTarget.objs[i].name)
                        {
                            FaceDrivenKeyTarget.mouthObjs.Add(FaceDrivenKeyTarget.objs[i]);
                        }
                    }
                }
            }
        }

        public void setBase()
        {
            this._isBase = true;
        }

        public void setMouth()
        {
            this._isMouth = true;
        }

        public void setEyeL()
        {
            this._isEyeL = true;
        }

        public void setEyeR()
        {
            this._isEyeR = true;
        }

        public void setEyebrowL()
        {
            this._isEyebrowL = true;
        }

        public void setEyebrowR()
        {
            this._isEyebrowR = true;
        }

    }

	[System.Serializable]
    public class TargetInfomation
	{
        public TargetGroupInfomation[] _faceGroupInfo;
    }

	public class FaceDrivenKeyTarget : ScriptableObject
	{
		[BoxGroup("原始数据区", Order = 0)]
        public TargetInfomation[] _eyeTarget; // 0x18
        [BoxGroup("原始数据区")]
        public TargetInfomation[] _eyebrowTarget; // 0x20
        [BoxGroup("原始数据区")]
        public TargetInfomation[] _mouthTarget; // 0x28

        [SerializeField, HideInInspector]
        public static GameObject _targetObj;

        [BoxGroup("目标模型设定", Order = 1)]
		[InlineButton("RecordTRS", "记录")]
        [InlineButton("Recover", "还原")]
        [ShowInInspector]
        public static GameObject TargetObj
        {
            get { return _targetObj; }
            set 
			{ 
				_targetObj = value;
                objs.Clear();
                oriTrans.Clear();
                oriRots.Clear();
                oriScal.Clear();
                if (_targetObj != null)
				{
                    var neck = _targetObj.transform.Find("Neck");
                    if(neck != null)
                    {
                        var head = neck.Find("Head");
                        if(head != null)
                        {
                            foreach(var t in head.GetComponentsInChildren<Transform>())
                            {
                                if(t != head)
                                {
                                    objs.Add(t);
                                }
                            }
                            foreach (Transform g in objs)
                            {
                                oriTrans.Add(g, g.localPosition);
                                oriRots.Add(g, g.localRotation);
                                oriScal.Add(g, g.localScale);
                            }
                            Debug.Log("选择模型成功，当前表情已保存为基础表情");
                        }
                        else
                        {
                            Debug.Log("获取表情对象失败，必须Neck下方有Head");
                        }
                    }
                    else
                    {
                        Debug.Log("获取表情对象失败，必须有Neck");
                    }  
                }
			}
        }

        [BoxGroup("目标模型设定")]
        [ShowInInspector]
        public static List<Transform> objs = new List<Transform>();
        public static Dictionary<Transform, Vector3> oriTrans = new Dictionary<Transform, Vector3>();
        public static Dictionary<Transform, Quaternion> oriRots = new Dictionary<Transform, Quaternion>();
        public static Dictionary<Transform, Vector3> oriScal = new Dictionary<Transform, Vector3>();

        [BoxGroup("目标模型设定")]
        [ShowInInspector]
        public static List<Transform> mouthObjs = new List<Transform>();

        [BoxGroup("目标模型设定")]
        [ShowInInspector]
        public static List<Transform> eyeLObjs = new List<Transform>();

        [BoxGroup("目标模型设定")]
        [ShowInInspector]
        public static List<Transform> eyeRObjs = new List<Transform>();

        [BoxGroup("目标模型设定")]
        [ShowInInspector]
        public static List<Transform> eyebrowLObjs = new List<Transform>();

        [BoxGroup("目标模型设定")]
        [ShowInInspector]
        public static List<Transform> eyebrowRObjs = new List<Transform>();



        [BoxGroup("工作区", Order = 2)]
        [ShowInInspector]
        private Dictionary<string, TargetGroupInfomation[]> _mouthDic;

        [BoxGroup("工作区")]
        [ShowInInspector]
        private Dictionary<string, TargetGroupInfomation[]> _eyesDic;

        [BoxGroup("工作区")]
        [ShowInInspector]
        private Dictionary<string, TargetGroupInfomation[]> _eyebrowsDic;


        [BoxGroup("工作区")]
        [Button("获取嘴部表情")]
        private void GetMouthDic()
		{
			Debug.Log("!!!!");
			Debug.Log(_mouthTarget.Length);

			_mouthDic = new Dictionary<string, TargetGroupInfomation[]>();
			for(int i = 0; i < _mouthTarget.Length; i++)
			{
				_mouthDic[Enum.GetName(typeof(LiveTimelineDefine.FacialMouthId), i)] = _mouthTarget[i]._faceGroupInfo;
                _mouthTarget[i]._faceGroupInfo[0].setMouth();

            }

            _mouthTarget[0]._faceGroupInfo[0].setBase();
        }

        [BoxGroup("工作区")]
        [Button("获取眼睛表情")]
        private void GetEyesDic()
        {
            Debug.Log("!!!!");
            Debug.Log(_eyeTarget.Length);

            _eyesDic = new Dictionary<string, TargetGroupInfomation[]>();
            for (int i = 0; i < _eyeTarget.Length; i++)
            {
                _eyesDic[Enum.GetName(typeof(LiveTimelineDefine.FacialEyeId), i)] = _eyeTarget[i]._faceGroupInfo;
            }

            _eyeTarget[0]._faceGroupInfo[0].setBase();
            _eyeTarget[0]._faceGroupInfo[1].setBase();
        }

        [BoxGroup("工作区")]
        [Button("获取眉毛表情")]
        private void GetEyebrowsDic()
        {
            Debug.Log("!!!!");
            Debug.Log(_eyebrowTarget.Length);

            _eyebrowsDic = new Dictionary<string, TargetGroupInfomation[]>();
            for (int i = 0; i < _eyebrowTarget.Length; i++)
            {
                _eyebrowsDic[Enum.GetName(typeof(LiveTimelineDefine.FacialEyebrowId), i)] = _eyebrowTarget[i]._faceGroupInfo;
            }

            _eyebrowTarget[0]._faceGroupInfo[0].setBase();
            _eyebrowTarget[0]._faceGroupInfo[1].setBase();
        }



        private void RecordTRS()
		{
            objs.Clear();
            oriTrans.Clear();
            oriRots.Clear();
            oriScal.Clear();
            if (_targetObj != null)
            {
                objs.AddRange(_targetObj.GetComponentsInChildren<Transform>());
                foreach (Transform g in objs)
                {
                    oriTrans.Add(g, g.localPosition);
                    oriRots.Add(g, g.localRotation);
                    oriScal.Add(g, g.localScale);
                }
            }
			Debug.Log("成功将当前表情记录为基础表情，之后计算表情变化将以此为基准");
        }

        private void Recover()
        {
            if (_targetObj != null)
            {
                for (int i = 0; i < objs.Count; i++)
                {
                    objs[i].localPosition = oriTrans[objs[i]];
                    objs[i].localRotation = oriRots[objs[i]];
                    objs[i].localScale = oriScal[objs[i]];
                }
            }
        }
    }
}

