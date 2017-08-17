Shader "Custom/TransparentShader"
{
	Properties
	{
		_CameraPos("_CameraPos", Vector) = (0,0,0)	// Camera position from main camera
		_Bandwidth("_Bandwidth", float) = 0.25		// Used to allow user to control bandwidth
		_FirstBand("_FirstBand", float) = 1.5
	}
		SubShader
	{
		Tags{ "RenderType" = "Opaque" }

		PASS
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		// Values must be declared outside of property block as well
		float3 _CameraPos;
		float _Bandwidth;
		float _FirstBand;

		// This is the data structure that the vertex program provides to the fragment
		struct v2f
		{
			float4 viewPos : SV_POSITION;
			float3 normal : NORMAL;
			float4 worldPos: TEXCOORD0;
		};

		// Returns the position of a vertex
		v2f vert(appdata_base v)
		{
			v2f o;

			// Calculate where the vertex is in view space.
			o.viewPos = mul(UNITY_MATRIX_MVP, v.vertex);

			// Calculate the normal in WorldSpace.
			o.normal = UnityObjectToWorldNormal(v.normal);

			// Calculate where the object is in world space.
			o.worldPos = mul(unity_ObjectToWorld, v.vertex);

			return o;
		}

		// Sets the color of a fragment based on the distance and strategy/color inputs
		fixed4 frag(v2f i) : SV_Target
		{
			// Declare return value and initialize RGBA to 0,0,0,1 (so we don't have to set every time below)
			fixed4 ret;
			ret.r = 0; ret.g = 0; ret.b = 0; ret.a = 0;
			return ret;
		}
			ENDCG
		}
	}
}
