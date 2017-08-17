Shader "Custom/Flashlight"
{
	Properties
	{
		_GazePosition("_GazePosition", Vector) = (0,0,0)	// Position of the user's gaze
		_CameraPos("_CameraPos", Vector) = (0,0,0)			// Camera position from main camera
		_Inverted("_Inverted", int) = 0						// Specifies whether the shader is inverted
		_Bandwidth("_Bandwidth", float) = 0.1				// Used to allow user to control bandwidth
	}
		SubShader
	{
		Tags{ "RenderType" = "Opaque" }

		Pass
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		// Values must be declared outside of property block as well
		Vector _GazePosition;
		float3 _CameraPos;
		int _Inverted;
		float _Bandwidth;

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
			ret.r = 69 / 255.0f; ret.g = 117 / 255.0f; ret.b = 180 / 255.0f;

			// Generate the distance value from the raycast position to the vertex
			float x_raycast_dist = _GazePosition.x - i.worldPos.x;
			float x_raycast_sq = x_raycast_dist * x_raycast_dist;
			float y_raycast_dist = _GazePosition.y - i.worldPos.y;
			float y_raycast_sq = y_raycast_dist * y_raycast_dist;
			float z_raycast_dist = _GazePosition.z - i.worldPos.z;
			float z_raycast_sq = z_raycast_dist * z_raycast_dist;
			float raycast_total = x_raycast_sq + y_raycast_sq + z_raycast_sq;
			float raycast_distance = sqrt(raycast_total);

			// Generate the distance value from the raycast position to the user's position
			float x_user_dist = _GazePosition.x - _CameraPos.x;
			float x_user_dist_sq = x_user_dist * x_user_dist;
			float y_user_dist = _GazePosition.y - _CameraPos.y;
			float y_user_dist_sq = y_user_dist * y_user_dist;
			float z_user_dist = _GazePosition.z - _CameraPos.z;
			float z_user_dist_sq = z_user_dist * z_user_dist;
			float user_dist_total = x_user_dist_sq + y_user_dist_sq + z_user_dist_sq;
			float user_distance = sqrt(user_dist_total);

			// Set the bandwidth based on the user's distance from the raycast
			if (user_distance < 1.25f)
			{
				_Bandwidth = 0.05;
			}
			else if ((user_distance >= 1.25f) && (user_distance < 4.0f))
			{
				_Bandwidth = 0.1;
			}
			else
			{
				_Bandwidth = 0.15;
			}

			// If the shader is not inverted, go from high alpha to low alpha
			if (_Inverted == 0)
			{
				if (raycast_distance < _Bandwidth) {
					ret.a = 1.0;
				}
				else if ((raycast_distance >= _Bandwidth) && (raycast_distance < (_Bandwidth * 2))) {
					ret.a = 0.9;
				}
				else if ((raycast_distance >= (_Bandwidth * 2)) && (raycast_distance < (_Bandwidth * 3))) {
					ret.a = 0.8;
				}
				else if ((raycast_distance >= (_Bandwidth * 3)) && (raycast_distance < (_Bandwidth * 4))) {
					ret.a = 0.7;
				}
				else if ((raycast_distance >= (_Bandwidth * 4)) && (raycast_distance < (_Bandwidth * 5))) {
					ret.a = 0.6;
				}
				else if ((raycast_distance >= (_Bandwidth * 5)) && (raycast_distance < (_Bandwidth * 6))) {
					ret.a = 0.5;
				}
				else if ((raycast_distance >= (_Bandwidth * 6)) && (raycast_distance < (_Bandwidth * 7))) {
					ret.a = 0.4;
				}
				else if ((raycast_distance >= (_Bandwidth * 7)) && (raycast_distance < (_Bandwidth * 8))) {
					ret.a = 0.3;
				}
				else if ((raycast_distance >= (_Bandwidth * 8)) && (raycast_distance < (_Bandwidth * 9))) {
					ret.a = 0.2;
				}
				else if ((raycast_distance >= (_Bandwidth * 9)) && (raycast_distance < (_Bandwidth * 10))) {
					ret.a = 0.1;
				}
				else {
					ret.a = 0.0;
				}
			}
			// If the shader is inverted, go from low alpha to high alpha
			else
			{
				if (raycast_distance < _Bandwidth) {
					ret.a = 0.0;
				}
				else if ((raycast_distance >= _Bandwidth) && (raycast_distance < (_Bandwidth * 2))) {
					ret.a = 0.1;
				}
				else if ((raycast_distance >= (_Bandwidth * 2)) && (raycast_distance < (_Bandwidth * 3))) {
					ret.a = 0.2;
				}
				else if ((raycast_distance >= (_Bandwidth * 3)) && (raycast_distance < (_Bandwidth * 4))) {
					ret.a = 0.3;
				}
				else if ((raycast_distance >= (_Bandwidth * 4)) && (raycast_distance < (_Bandwidth * 5))) {
					ret.a = 0.4;
				}
				else if ((raycast_distance >= (_Bandwidth * 5)) && (raycast_distance < (_Bandwidth * 6))) {
					ret.a = 0.5;
				}
				else if ((raycast_distance >= (_Bandwidth * 6)) && (raycast_distance < (_Bandwidth * 7))) {
					ret.a = 0.6;
				}
				else if ((raycast_distance >= (_Bandwidth * 7)) && (raycast_distance < (_Bandwidth * 8))) {
					ret.a = 0.7;
				}
				else if ((raycast_distance >= (_Bandwidth * 8)) && (raycast_distance < (_Bandwidth * 9))) {
					ret.a = 0.8;
				}
				else if ((raycast_distance >= (_Bandwidth * 9)) && (raycast_distance < (_Bandwidth * 10))) {
					ret.a = 0.9;
				}
				else {
					ret.a = 1.0;
				}
			}

			ret.r *= ret.a;
			ret.g *= ret.a;
			ret.b *= ret.a;

			return ret;

		}
		ENDCG
		}
	}
}
