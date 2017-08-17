Shader "Custom/ColorShader" 
{
	Properties
	{
		_CameraPos("_CameraPos", Vector) = (0,0,0)	// Camera position from main camera
		_Inverted("_Inverted", int) = 0				// Specifies if the shader should be inverted
		_Bandwidth("_Bandwidth", float) = 0.25		// Used to allow user to control bandwidth
		_FirstBand("_FirstBand", float) = 1.5
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }

		PASS
		{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		// Values must be declared outside of property block as well
		float3 _CameraPos;
		int _Inverted;
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

			// If the shader is not inverted, color bands go from red to blue
			if (_Inverted == 0)
			{
				if (distance <= _FirstBand) {
					ret.r = 165 / 255.0f;
					ret.g = 0 / 255.0f;
					ret.b = 38 / 255.0f;
				}
				else if ((distance > _FirstBand) && (distance <= _FirstBand + (_Bandwidth * 1))) {
					ret.r = 244 / 255.0f;
					ret.g = 109 / 255.0f;
					ret.b = 67 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 1)) && (distance <= _FirstBand + (_Bandwidth * 2))) {
					ret.r = 253 / 255.0f;
					ret.g = 174 / 255.0f;
					ret.b = 97 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 2)) && (distance <= _FirstBand + (_Bandwidth * 3))) {
					ret.r = 254 / 255.0f;
					ret.g = 224 / 255.0f;
					ret.b = 144 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 3)) && (distance <= _FirstBand + (_Bandwidth * 4))) {
					ret.r = 255 / 255.0f;
					ret.g = 255 / 255.0f;
					ret.b = 191 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 4)) && (distance <= _FirstBand + (_Bandwidth * 5))) {
					ret.r = 224 / 255.0f;
					ret.g = 243 / 255.0f;
					ret.b = 248 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 5)) && (distance <= _FirstBand + (_Bandwidth * 6))) {
					ret.r = 171 / 255.0f;
					ret.g = 217 / 255.0f;
					ret.b = 233 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 6)) && (distance <= _FirstBand + (_Bandwidth * 7))) {
					ret.r = 116 / 255.0f;
					ret.g = 173 / 255.0f;
					ret.b = 209 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 7)) && (distance <= _FirstBand + (_Bandwidth * 8))) {
					ret.r = 69 / 255.0f;
					ret.g = 117 / 255.0f;
					ret.b = 180 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 8)) && (distance <= _FirstBand + (_Bandwidth * 9))) {
					ret.r = 49 / 255.0f;
					ret.g = 54 / 255.0f;
					ret.b = 149 / 255.0f;
				}
				else {
					ret.r = 49 / 255.0f;
					ret.g = 54 / 255.0f;
					ret.b = 149 / 255.0f;
				}
			}
			// If the shader is inverted, color bands go from blue to red
			else
			{
				ret.r = 69 / 255.0f; ret.g = 117 / 255.0f; ret.b = 180 / 255.0f;
				if (distance <= _FirstBand) {
					ret.r = 49 / 255.0f;
					ret.g = 54 / 255.0f; 
					ret.b = 149 / 255.0f;
				}
				else if ((distance > _FirstBand) && (distance <= _FirstBand + (_Bandwidth * 1))) {
					ret.r = 49 / 255.0f;
					ret.g = 54 / 255.0f;
					ret.b = 149 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 1)) && (distance <= _FirstBand + (_Bandwidth * 2))) {
					ret.r = 69 / 255.0f;
					ret.g = 117 / 255.0f;
					ret.b = 180 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 2)) && (distance <= _FirstBand + (_Bandwidth * 3))) {
					ret.r = 116 / 255.0f;
					ret.g = 173 / 255.0f;
					ret.b = 209 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 3)) && (distance <= _FirstBand + (_Bandwidth * 4))) {
					ret.r = 171 / 255.0f;
					ret.g = 217 / 255.0f;
					ret.b = 233 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 4)) && (distance <= _FirstBand + (_Bandwidth * 5))) {
					ret.r = 224 / 255.0f;
					ret.g = 243 / 255.0f;
					ret.b = 248 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 5)) && (distance <= _FirstBand + (_Bandwidth * 6))) {
					ret.r = 255 / 255.0f;
					ret.g = 255 / 255.0f;
					ret.b = 191 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 6)) && (distance <= _FirstBand + (_Bandwidth * 7))) {
					ret.r = 254 / 255.0f;
					ret.g = 224 / 255.0f;
					ret.b = 144 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 7)) && (distance <= _FirstBand + (_Bandwidth * 8))) {
					ret.r = 253 / 255.0f;
					ret.g = 174 / 255.0f;
					ret.b = 97 / 255.0f;
				}
				else if ((distance > _FirstBand + (_Bandwidth * 8)) && (distance <= _FirstBand + (_Bandwidth * 9))) {
					ret.r = 244 / 255.0f;
					ret.g = 109 / 255.0f;
					ret.b = 67 / 255.0f;
				}
				else {
					ret.r = 165 / 255.0f;
					ret.g = 0 / 255.0f;
					ret.b = 38 / 255.0f;
				}
			}
			return ret;
		}
		ENDCG
		}
	}
}
