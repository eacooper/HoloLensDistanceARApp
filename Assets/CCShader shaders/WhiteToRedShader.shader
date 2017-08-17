Shader "Custom/WhiteToRedShader"
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
			ret.r = 0; ret.g = 0; ret.b = 0; ret.a = 1;

			// Generate the distance value - distance here is distance from the user to the worldPos
			float x_dist = _CameraPos.x - i.worldPos.x;
			float x_sqrd = x_dist * x_dist;
			float y_dist = _CameraPos.y - i.worldPos.y;
			float y_sqrd = y_dist * y_dist;
			float z_dist = _CameraPos.z - i.worldPos.z;
			float z_sqrd = z_dist * z_dist;
			float total = x_sqrd + y_sqrd + z_sqrd;
			float distance = sqrt(total);

			if (distance <= _FirstBand) {
				ret.r = 255 / 255.0f;
				ret.g = 255 / 255.0f;
				ret.b = 255 / 255.0f;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_Bandwidth * 1))) {
				ret.r = 255 / 255.0f;
				ret.g = 230 / 255.0f;
				ret.b = 230 / 255.0f;
			}
			else if ((distance > _FirstBand + (_Bandwidth * 1)) && (distance <= _FirstBand + (_Bandwidth * 2))) {
				ret.r = 255 / 255.0f;
				ret.g = 204 / 255.0f;
				ret.b = 204 / 255.0f;
			}
			else if ((distance > _FirstBand + (_Bandwidth * 2)) && (distance <= _FirstBand + (_Bandwidth * 3))) {
				ret.r = 255 / 255.0f;
				ret.g = 179 / 255.0f;
				ret.b = 179 / 255.0f;
			}
			else if ((distance > _FirstBand + (_Bandwidth * 3)) && (distance <= _FirstBand + (_Bandwidth * 4))) {
				ret.r = 255 / 255.0f;
				ret.g = 153 / 255.0f;
				ret.b = 153 / 255.0f;
			}
			else if ((distance > _FirstBand + (_Bandwidth * 4)) && (distance <= _FirstBand + (_Bandwidth * 5))) {
				ret.r = 255 / 255.0f;
				ret.g = 128 / 255.0f;
				ret.b = 128 / 255.0f;
			}
			else if ((distance > _FirstBand + (_Bandwidth * 5)) && (distance <= _FirstBand + (_Bandwidth * 6))) {
				ret.r = 255 / 255.0f;
				ret.g = 102 / 255.0f;
				ret.b = 102 / 255.0f;
			}
			else if ((distance > _FirstBand + (_Bandwidth * 6)) && (distance <= _FirstBand + (_Bandwidth * 7))) {
				ret.r = 255 / 255.0f;
				ret.g = 77 / 255.0f;
				ret.b = 77 / 255.0f;
			}
			else if ((distance > _FirstBand + (_Bandwidth * 7)) && (distance <= _FirstBand + (_Bandwidth * 8))) {
				ret.r = 255 / 255.0f;
				ret.g = 51 / 255.0f;
				ret.b = 51 / 255.0f;
			}
			else if ((distance > _FirstBand + (_Bandwidth * 8)) && (distance <= _FirstBand + (_Bandwidth * 9))) {
				ret.r = 255 / 255.0f;
				ret.g = 26 / 255.0f;
				ret.b = 26 / 255.0f;
			}
			else {
				ret.r = 255 / 255.0f;
				ret.g = 0 / 255.0f;
				ret.b = 0 / 255.0f;
			}

			return ret;
		}
			ENDCG
		}
	}
}
