Shader "Custom/DepthMap"
{
	Properties{
		_CameraPos("_CameraPos", Vector) = (0,0,0)	// Camera position from main camera
		_Equation("_Equation", int) = 0				// Specifies depth mapping strategy (from Voice Placement)
		_Color("_Color", int) = 0					// Specifies color to use (from Voice Placement)
		// variables to adjust shaders: bandwidth, number of bands, flicker frequency, alpha values
		_FirstBand("_FirstBand", float)						= 0.0 // Specifies the width of the first band of a shader
		_ColorBandwidth("_ColorBandwidth", float)			= 1.0 // Specifies the bandwidth of the color depth map shader
		_FrequencyBandwidth("_FrequencyBandwidth", float)	= 1.0 // Specifies bandwith of frequency depth map shader
		_AlphaBandwidth("_AlphaBandwidth", float)			= 1.0 // Specifies the bandwidth of the alpha depth map shader
		_ColorBandnumber("_ColorBandnumber", int)			= 11  // Specifies the number of bands in color depth map shader
		_FrequencyBandnumber("_FrequencyBandnumber", int)	= 1   // Specifies the number of bands in frequency depth shader
		_AlphaBandnumber("_AlphaBandnumber", int)			= 1   // Specifies the number of bands in alpha depth shader
		_FlickerFrequencyMax("_FlickerFrequencyMax", float)	= 1.0 // Specifies the maximum flicker frequency in frequency shader
		_FlickerFrequencyDiff("_FlickerFrequencyDiff", float)= 1.0// Specifies the difference in flicker frequency between bands in frequency depth shader
		_AlphaMax("_AlphaMax", float)						= 1.0 // Specifies the maximum alpha value in transparency depth shader
		_AlphaDiff("_AlphaDiff", float)						= 0.2 // Specifies the difference in alpha value in between bands in transparency depth shader
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
		float3 _CameraPos;
		int _Equation;
		int _Color;
		float _ColorBandwidth;
		float _FrequencyBandwidth;
		float _AlphaBandwidth;
		float _FirstBand;			// Specifies the width of the first band of a shader
		int	_ColorBandnumber;
		int	_FrequencyBandnumber;
		int	_AlphaBandnumber;
		float _FlickerFrequencyMax;
		float _FlickerFrequencyDiff;
		float _AlphaMax;
		float _AlphaDiff;
		int _MaxBandnumber = 20;

		// settings for Zebra shader and set them to false
		int zebraSwitch = 0;

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

			// Generate the distance value
			float x_dist = _CameraPos.x - i.worldPos.x;
			float x_sqrd = x_dist * x_dist;
			float y_dist = _CameraPos.y - i.worldPos.y;
			float y_sqrd = y_dist * y_dist;
			float z_dist = _CameraPos.z - i.worldPos.z;
			float z_sqrd = z_dist * z_dist;
			float total = x_sqrd + y_sqrd + z_sqrd;
			float distance = sqrt(total);

			// Return the fragment containing depth info
			ret.r = 69 / 255.0f; ret.g = 117 / 255.0f; ret.b = 180 / 255.0f;
			ret.a = 0.5;
			return ret;

		}
			ENDCG
		}
	}
}

	/*
	// Set the depth depending on strategy input from user
	float depth = 0;
	if (distance <= 0.5) {					// Any distance within arm's length will have the
		depth = 1;							// max depth value regardless

											// Standard strategy - calculate depth based on standardized distance from user
	}
	else if (_Equation == 0) {
		depth = distance / 15;

		// Inverted strategy - calculate depth based on standardized inverted distance from user
	}
	else if (_Equation == 1) {
		depth = 1 - distance / 15;

		// Scaled strategy - calculate depth based on scaled inverted distance from user
	}
	else if (_Equation == 2) {
		depth = 1 - distance / 5;

		// Non-linear strategy - calculate depth based on scaled non-linear inverted distance from user
	}
	else if (_Equation == 3) {
		depth = ((1 / distance) - (1 / 5)) / ((1 / 0.5) - (1 / 5));

		// Color-code stragegy - color codes specific distances from the user: 4 different colors
	}

	else if (_Equation == 4) {
		if (distance <= 1.5) {							    // 0 - 1.5 meters = red
			ret.r = 1;
		}
		else if ((distance > 1.5) && (distance <= 3.5)) {		// 1.5 - 2.5 meters = orange
			ret.r = 1; ret.g = 0.5;
		}
		else if ((distance > 3.5) && (distance <= 5.5)) {		// 2.5 - 3.5 meters = yellow
			ret.r = 1; ret.g = 1;
		}
		else {							// 5.5+ meters = dark grey
			ret.r = 0.1; ret.g = 0.1; ret.b = 0.1;
		}

		return ret;	    // Need to return frag here with color code strategy so color isn't changed below


	}
	// same as before but 5 different colors
	else if (_Equation == 5) {
		if (distance <= 1.5) {							    // 0 - 1.5 meters = red
			ret.r = 1; ret.a = 0.5;
		}
		else if ((distance > 1.5) && (distance <= 2.84)) {		// 1.5 - 2.5 meters = orange
			ret.r = 1; ret.g = 0.5; ret.a = 0.6;
		}
		else if ((distance > 2.84) && (distance <= 4.17)) {		// 2.5 - 3.5 meters = yellow
			ret.r = 1; ret.g = 1; ret.a = 0.7;
		}
		else if ((distance > 4.17) && (distance <= 5.5)) {		// 3.5 - 4.5 meters = green
			ret.g = 1; ret.a = 0.8;
		}
		else {							// 5.5+ meters
			ret.b = 1; ret.a = 0.9;
		}

		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;	    // Need to return frag here with color code strategy so color isn't changed below


	}
	// same as before but 6 colors
	else if (_Equation == 6) {
		if (distance <= 1.5) {							    // 0 - 1.5 meters = red
			ret.r = 1; ret.a = 0.5;
		}
		else if ((distance > 1.5) && (distance <= 2.5)) {		// 1.5 - 2.5 meters = orange
			ret.r = 1; ret.g = 0.5; ret.a = 0.6;
		}
		else if ((distance > 2.5) && (distance <= 3.5)) {		// 2.5 - 3.5 meters = yellow
			ret.r = 1; ret.g = 1; ret.a = 0.7;
		}
		else if ((distance > 3.5) && (distance <= 4.5)) {		// 3.5 - 4.5 meters = green
			ret.g = 1; ret.a = 0.8;
		}
		else if ((distance > 4.5) && (distance <= 5.5)) {		// 4.5 - 5.5 meters = blue
			ret.b = 1; ret.a = 0.9;
		}
		else {							// 5.5+ meters = purple
			ret.r = 0.63; ret.g = 0.13; ret.b = 0.95; ret.a = 1;
		}

		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;	    // Need to return frag here with color code strategy so color isn't changed below


	}
	// dynamic shader 1: Flickering stripes at 1Hz			
	else if (_Equation == 7) {

		// try this 
		
		if (distance + _Time.y  % 15 < 3) {

		

		
		if (_Time.y % 2 >= 0 && _Time.y % 2 < 1) {
			//ret.g = 1; ret.a = 1.0;
			if (distance <= 0.5) {							    // 0 - 0.5 meters	= white
				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 0.5) && (distance <= 1.0)) {		// 1.5 - 2.5 meters = dark grey
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 1.0) && (distance <= 1.5)) {		// 2.5 - 3.5 meters = white
				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 1.5) && (distance <= 2)) {		// 3.5 - 4.5 meters = dark grey
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 2.0) && (distance <= 2.5)) {		// 4.5 - 5.5 meters = white
				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 2.5) && (distance <= 3.0)) {		// 3.5 - 4.5 meters = dark grey
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 3.0) && (distance <= 3.5)) {		// 4.5 - 5.5 meters = white
				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 3.5) && (distance <= 4.0)) {		// 3.5 - 4.5 meters = dark grey
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 4.0) && (distance <= 4.5)) {		// 4.5 - 5.5 meters = white
				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 4.5) && (distance <= 5.0)) {		// 3.5 - 4.5 meters = dark grey
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 5.0) && (distance <= 5.5)) {		// 4.5 - 5.5 meters = white
				ret.g = 1; ret.a = 1.0;
			}
			else {							// 5.5+ meters = dark grey
				ret.g = 1; ret.a = 0.5;
			}
		}
		else if (_Time.y % 2 >= 1 && _Time.y % 2< 2) {
			//ret.r = 0; ret.g = 1; ret.b = 1;  ret.a = 0.5;
			if (distance <= 0.5) {							    // 0 - 0.5 meters	= dark grey
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 0.5) && (distance <= 1.0)) {		// 1.5 - 2.5 meters = white
				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 1.0) && (distance <= 1.5)) {		// 2.5 - 3.5 meters = dark grey
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 1.5) && (distance <= 2)) {		// 3.5 - 4.5 meters  = white

				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 2.0) && (distance <= 2.5)) {		// 4.5 - 5.5 meters = dark grey
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 2.5) && (distance <= 3.0)) {		// 3.5 - 4.5 meters = white

				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 3.0) && (distance <= 3.5)) {		// 4.5 - 5.5 meters = dark grey
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 3.5) && (distance <= 4.0)) {		// 3.5 - 4.5 meters = white

				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 4.0) && (distance <= 4.5)) {		// 4.5 - 5.5 meters
				ret.g = 1; ret.a = 0.5;
			}
			else if ((distance > 4.5) && (distance <= 5.0)) {		// 3.5 - 4.5 meters = dark grey

				ret.g = 1; ret.a = 1.0;
			}
			else if ((distance > 5.0) && (distance <= 5.5)) {		// 4.5 - 5.5 meters = white
				ret.g = 1; ret.a = 0.5;
			}
			else {							// 5.5+ meters = dark grey
				ret.g = 1; ret.a = 1.0;
			}
		}
		
		ret.r = 69 / 255.0f; ret.g = 117 / 255.0f; ret.b = 180 / 255.0f;
		ret.a = 1;
		
		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		

		return ret;	    // Need to return frag here with color code strategy so color isn't changed below

	}
	// Dynamic shader 2: Flicker rate changes over distance (the closer the higher the flicker rate
	else if (_Equation == 8) {

		if (distance <= 1.5) {											// 1 - 1.5 meters	= white
			if (_Time.y % 0.1 >= 0 && _Time.y % 0.1 < 0.05) {			// 6Hz flicker
				ret.g = 1; ret.a = 0.5;									// red
			}
			else if (_Time.y % 0.1 >= 0.05 && _Time.y % 0.1 < 0.1) {
				ret.g = 1; ret.a = 1;									// blue
			}
		}
		else if ((distance > 1.5) && (distance <= 2.5)) {			// 2.5 - 2.5 meters
			if (_Time.y % 0.2 >= 0 && _Time.y % 0.2 < 0.1) {		// 5.5Hz flicker
				ret.g = 1; ret.a = 1;								// blue  (red and blue grey alternate)
			}
			else if (_Time.y % 0.2 >= 0.1 && _Time.y % 0.2 < 0.2) {
				ret.g = 1; ret.a = 0.5;								 // red
			}
		}
		else if ((distance > 2.5) && (distance <= 3.5)) {		// 2.5 - 3.5 meters
			if (_Time.y % 0.3 >= 0 && _Time.y % 0.3 < 0.15) {	// 5Hz flicker
				ret.g = 1; ret.a = 0.5;
			}
			else if (_Time.y % 0.3 >= 0.15 && _Time.y % 0.3 < 0.3) {
				ret.g = 1; ret.a = 1;
			}
		}
		else if ((distance > 3.5) && (distance <= 4.5)) {					// 3.5 - 4.5 m
			if (_Time.y % 0.4 >= 0 && _Time.y % 0.4 < 0.2) {		// 4.5Hz flicker
				ret.g = 1; ret.a = 1;
			}
			else if (_Time.y % 0.4 >= 0.2 && _Time.y % 0.4 < 0.4) {
				ret.g = 1; ret.a = 0.5;
			}
		}
		else if ((distance > 4.5) && (distance <= 5.5)) {					// 4.5 - 5.5 m
			if (_Time.y % 0.5 >= 0 && _Time.y % 0.5 < 0.25) {		// 4.5Hz flicker
				ret.g = 1; ret.a = 0.5;
			}
			else if (_Time.y % 0.5 >= 0.25 && _Time.y % 0.5 < 0.5) {
				ret.g = 1; ret.a = 1;
			}
		}
		else {							// 5.5+ meters = dark grey
			ret.g = 1; ret.a = 0.5;
		}


		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;

		return ret;	    // Need to return frag here with color code strategy so color isn't changed below

	}
	// distance shader but all one color (alpha step): same strategy as equation 1-4 but discretized
	else if (_Equation == 9) {

		// Set the color
		ret.r = 69 / 255.0f; ret.g = 117 / 255.0f; ret.b = 180 / 255.0f;

		
		// Create multiple bands
		#pragma unroll
 		for (int i = 1; i < _MaxBandnumber; i++) {
			if (distance <= _FirstBand + _AlphaBandwidth) {
				ret.a = _AlphaMax;
				break;
			}
			else {
				ret.a = 0.5;
				break;
			}
			
			else if ((distance > _FirstBand + (_AlphaBandwidth * i)) && (distance <= _FirstBand + (_AlphaBandwidth * (i + 1)))) {
				ret.a = 0.5;
				break;
			}
			
		}
		if (_AlphaBandnumber == 11) {
			if (distance <= _FirstBand) { // first band of shader

				ret.a = _AlphaMax;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_AlphaBandwidth * 1))) {
				ret.a = _AlphaMax - 0.1;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 1)) && (distance <= _FirstBand + (_AlphaBandwidth * 2))) {
				ret.a = _AlphaMax - 0.2;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 2)) && (distance <= _FirstBand + (_AlphaBandwidth * 3))) {
				ret.a = _AlphaMax - 0.3;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 3)) && (distance <= _FirstBand + (_AlphaBandwidth * 4))) {
				ret.a = _AlphaMax - 0.4;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 4)) && (distance <= _FirstBand + (_AlphaBandwidth * 5))) {
				ret.a = _AlphaMax - 0.5;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 5)) && (distance <= _FirstBand + (_AlphaBandwidth * 6))) {
				ret.a = _AlphaMax - 0.6;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 6)) && (distance <= _FirstBand + (_AlphaBandwidth * 7))) {
				ret.a = _AlphaMax - 0.7;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 7)) && (distance <= _FirstBand + (_AlphaBandwidth * 8))) {
				ret.a = _AlphaMax - 0.8;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 8)) && (distance <= _FirstBand + (_AlphaBandwidth * 9))) {
				ret.a = _AlphaMax - 0.9;
			}
			else {
				ret.a = _AlphaMax - 0.95;
			}
		}
		if (_AlphaBandnumber == 10) {
			//ret.r = 255.0f / 255.0f; ret.g = 255.0f / 255.0f; ret.b = 255.0f / 255.0f;
			ret.r = 69 / 255.0f; ret.g = 117 / 255.0f; ret.b = 180 / 255.0f;
			if (distance <= _FirstBand) { // first band of shader = red
				// ret.r = 215 / 255.0f; ret.g = 48 / 255.0f; ret.b = 39 / 255.0f;
				ret.a = _AlphaMax - 0.0;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_AlphaBandwidth * 1))) {
				ret.a = _AlphaMax - 0.05;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 1)) && (distance <= _FirstBand + (_AlphaBandwidth * 2))) {
				ret.a = _AlphaMax - 0.1;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 2)) && (distance <= _FirstBand + (_AlphaBandwidth * 3))) {
				ret.a = _AlphaMax - 0.15;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 3)) && (distance <= _FirstBand + (_AlphaBandwidth * 4))) {
				ret.a = _AlphaMax - 0.25;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 4)) && (distance <= _FirstBand + (_AlphaBandwidth * 5))) {
				ret.a = _AlphaMax - 0.30;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 5)) && (distance <= _FirstBand + (_AlphaBandwidth * 6))) {
				ret.a = _AlphaMax - 0.35;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 6)) && (distance <= _FirstBand + (_AlphaBandwidth * 7))) {
				ret.a = _AlphaMax - 0.4;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 7)) && (distance <= _FirstBand + (_AlphaBandwidth * 8))) {
				ret.a = _AlphaMax - 1.0;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 8)) && (distance <= _FirstBand + (_AlphaBandwidth * 9))) {
				ret.a = _AlphaMax - 1.0;
			}
			else {
				ret.a = _AlphaMax - 1.0;
			}
		}
		else if (_AlphaBandnumber == 9) {
			if (distance <= _FirstBand) { // first band of shader
				ret.a = _AlphaMax;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_AlphaBandwidth * 1))) {
				ret.a = _AlphaMax - 0.1;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 1)) && (distance <= _FirstBand + (_AlphaBandwidth * 2))) {
				ret.a = _AlphaMax - 0.2;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 2)) && (distance <= _FirstBand + (_AlphaBandwidth * 3))) {
				ret.a = _AlphaMax - 0.3;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 3)) && (distance <= _FirstBand + (_AlphaBandwidth * 4))) {
				ret.a = _AlphaMax - 0.4;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 4)) && (distance <= _FirstBand + (_AlphaBandwidth * 5))) {
				ret.a = _AlphaMax - 0.5;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 5)) && (distance <= _FirstBand + (_AlphaBandwidth * 6))) {
				ret.a = _AlphaMax - 0.6;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 6)) && (distance <= _FirstBand + (_AlphaBandwidth * 7))) {
				ret.a = _AlphaMax - 0.7;
			}
			else {
				ret.a = 0.95;
			}
		}
		else if (_AlphaBandnumber == 7) {
			if (distance <= _FirstBand) { // first band of shader
				ret.a = _AlphaMax;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_AlphaBandwidth * 1))) {
				ret.a = _AlphaMax - 0.1;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 1)) && (distance <= _FirstBand + (_AlphaBandwidth * 2))) {
				ret.a = _AlphaMax - 0.2;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 2)) && (distance <= _FirstBand + (_AlphaBandwidth * 3))) {
				ret.a = _AlphaMax - 0.3;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 3)) && (distance <= _FirstBand + (_AlphaBandwidth * 4))) {
				ret.a = _AlphaMax - 0.4;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 4)) && (distance <= _FirstBand + (_AlphaBandwidth * 5))) {
				ret.a = _AlphaMax - 0.5;
			}
			else {
				ret.a = 0.95;
			}
		}
		else if (_AlphaBandnumber == 5) {
			if (distance <= _FirstBand) { // first band of shader
				ret.a = _AlphaMax;
			}
			else if ((distance > _FirstBand + _AlphaBandwidth) && (distance <= _FirstBand + (_AlphaBandwidth * 1))) {
				ret.a = _AlphaMax - 0.3;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 1)) && (distance <= _FirstBand + (_AlphaBandwidth * 2))) {
				ret.a = _AlphaMax - 0.6;
			}
			else if ((distance > _FirstBand + (_AlphaBandwidth * 2)) && (distance <= _FirstBand + (_AlphaBandwidth * 3))) {
				ret.a = _AlphaMax - 0.8;
			}
			else {
				ret.a = _AlphaMax - 0.9;
			}
		}
		else if (_AlphaBandnumber == 3) {
			if (distance <= _FirstBand) { // first band of shader
				ret.a = _AlphaMax;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_AlphaBandwidth * 1))) {
				ret.a = _AlphaMax - 0.4;
			}
			else {
				ret.a = 0.2;
			}
		}
		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;	    // Need to return frag here with color code strategy so color isn't changed below
		
		ret.r = 69 / 255.0f; ret.g = 117 / 255.0f; ret.b = 180 / 255.0f;
		ret.a = 1;
		return ret;

	} 
	// Dynamic shader 3: pulsating instead of flickering (alpha from 0.0 - 0.5)
	else if (_Equation == 10) {
		ret.r = 247 / 255.0f; ret.g = 252 / 255.0f; ret.b = 185 / 255.0f;  // specify color for shader
		
		float curTime = _Time.y;
		if (_FrequencyBandnumber == 11) {
			if (distance <= _FirstBand) {
				if (_Time.y % 0.5 >= 0 && _Time.y % 0.5 < 0.25) {			// Time 0 to  			 
					ret.a = ((curTime % 0.5) / 0.5);				// dim up
				}
				else if (_Time.y % 0.5 >= 0.25 && _Time.y % 0.5 < 0.5) {	
					ret.a = 1 - ((curTime % 0.5) / 0.5);			// dim down						
				}
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_FrequencyBandwidth * 1))) {
				if (_Time.y % 0.8 >= 0 && _Time.y % 0.8 < 0.4) {		//
					ret.a = ((curTime % 0.8) / 0.8);
				}
				else if (_Time.y % 0.8 >= 0.4 && _Time.y % 0.8 < 0.8) {
					ret.a = 1 - ((curTime % 0.8) / 0.8);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 1)) && (distance <= _FirstBand + (_FrequencyBandwidth * 2))) {
				if (_Time.y % 1.1 >= 0 && _Time.y % 1.1 < 0.55) {	// 
					ret.a = ((curTime % 1.1) / 1.1);
				}
				else if (_Time.y % 1.1 >= 0.55 && _Time.y % 1.1 < 1.1) {
					ret.a = 1 - ((curTime % 1.1) / 1.1);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 2)) && (distance <= _FirstBand + (_FrequencyBandwidth * 3))) {
				if (_Time.y % 1.3 >= 0 && _Time.y % 1.3 < 0.65) {
					ret.a = ((curTime % 1.3) / 1.3);
				}
				else if (_Time.y % 1.3 >= 0.64 && _Time.y % 1.3 < 1.3) {
					ret.a = 1 - ((curTime % 1.3) / 1.3);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 3)) && (distance <= _FirstBand + (_FrequencyBandwidth * 4))) {
				if (_Time.y % 1.5 >= 0 && _Time.y % 1.5 < 0.75) {
					ret.a = ((curTime % 1.5) / 1.5);
				}
				else if (_Time.y % 1.5 >= 0.75 && _Time.y % 1.5 < 1.5) {
					ret.a = 1 - ((curTime % 1.5) / 1.5);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 4)) && (distance <= _FirstBand + (_FrequencyBandwidth * 5))) {
				if (_Time.y % 1.7 >= 0 && _Time.y % 1.7 < 0.85) {
					ret.a = ((curTime % 1.7) / 1.7);
				}
				else if (_Time.y % 1.7 >= 0.85 && _Time.y % 1.7 < 1.7) {
					ret.a = 1 - ((curTime % 1.7) / 1.7);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 5)) && (distance <= _FirstBand + (_FrequencyBandwidth * 6))) {
				if (_Time.y % 1.9 >= 0 && _Time.y % 1.9 < 0.95) {
					ret.a = ((curTime % 1.9) / 1.9);
				}
				else if (_Time.y % 1.9 >= 0.95 && _Time.y % 1.9 < 1.9) {
					ret.a = 1 - ((curTime % 1.9) / 1.9);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 6)) && (distance <= _FirstBand + (_FrequencyBandwidth * 7))) {
				if (_Time.y % 2.0 >= 0 && _Time.y % 2.0 < 1) {
					ret.a = ((curTime % 2.0) / 2.0);
				}
				else if (_Time.y % 2.0 >= 1 && _Time.y % 2.0 < 2.0) {
					ret.a = 1 - ((curTime % 2.0) / 2.0);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 7)) && (distance <= _FirstBand + (_FrequencyBandwidth * 8))) {
				if (_Time.y % 2.1 >= 0 && _Time.y % 2.1 < 1.05) {
					ret.a = ((curTime % 2.1) / 2.1);
				}
				else if (_Time.y % 2.1 >= 1.05 && _Time.y % 2.1 < 2.1) {
					ret.a = 1 - ((curTime % 2.1) / 2.1);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 8)) && (distance <= _FirstBand + (_FrequencyBandwidth * 9))) {
				if (_Time.y % 2.2 >= 0 && _Time.y % 2.2 < 1.1) {		;
					ret.a = ((curTime % 2.2) / 2.2);
				}
				else if (_Time.y % 2.2 >= 1.1 && _Time.y % 2.2 < 2.2) {
					ret.a = 1 - ((curTime % 2.2) / 2.2);
				}
			}
			else {							
				ret.a = 0.1;
			}
		}
		else if (_FrequencyBandnumber == 9) {
			if (distance <= _FirstBand) {
				if (_Time.y % 0.5 >= 0 && _Time.y % 0.5 < 0.25) {			// Time 0 to  			 
					ret.a = ((curTime % 0.5) / 0.5);				// dim up
				}
				else if (_Time.y % 0.5 >= 0.25 && _Time.y % 0.5 < 0.5) {
					ret.a = 1 - ((curTime % 0.5) / 0.5);			// dim down						
				}
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_FrequencyBandwidth * 1))) {
				if (_Time.y % 0.8 >= 0 && _Time.y % 0.8 < 0.4) {		//
					ret.a = ((curTime % 0.8) / 0.8);
				}
				else if (_Time.y % 0.8 >= 0.4 && _Time.y % 0.8 < 0.8) {
					ret.a = 1 - ((curTime % 0.8) / 0.8);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 1)) && (distance <= _FirstBand + (_FrequencyBandwidth * 2))) {
				if (_Time.y % 1.1 >= 0 && _Time.y % 1.1 < 0.55) {	// 
					ret.a = ((curTime % 1.1) / 1.1);
				}
				else if (_Time.y % 1.1 >= 0.55 && _Time.y % 1.1 < 1.1) {
					ret.a = 1 - ((curTime % 1.1) / 1.1);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 2)) && (distance <= _FirstBand + (_FrequencyBandwidth * 3))) {
				if (_Time.y % 1.3 >= 0 && _Time.y % 1.3 < 0.65) {
					ret.a = ((curTime % 1.3) / 1.3);
				}
				else if (_Time.y % 1.3 >= 0.64 && _Time.y % 1.3 < 1.3) {
					ret.a = 1 - ((curTime % 1.3) / 1.3);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 3)) && (distance <= _FirstBand + (_FrequencyBandwidth * 4))) {
				if (_Time.y % 1.5 >= 0 && _Time.y % 1.5 < 0.75) {
					ret.a = ((curTime % 1.5) / 1.5);
				}
				else if (_Time.y % 1.5 >= 0.75 && _Time.y % 1.5 < 1.5) {
					ret.a = 1 - ((curTime % 1.5) / 1.5);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 4)) && (distance <= _FirstBand + (_FrequencyBandwidth * 5))) {
				if (_Time.y % 1.7 >= 0 && _Time.y % 1.7 < 0.85) {
					ret.a = ((curTime % 1.7) / 1.7);
				}
				else if (_Time.y % 1.7 >= 0.85 && _Time.y % 1.7 < 1.7) {
					ret.a = 1 - ((curTime % 1.7) / 1.7);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 5)) && (distance <= _FirstBand + (_FrequencyBandwidth * 6))) {
				if (_Time.y % 1.9 >= 0 && _Time.y % 1.9 < 0.95) {
					ret.a = ((curTime % 1.9) / 1.9);
				}
				else if (_Time.y % 1.9 >= 0.95 && _Time.y % 1.9 < 1.9) {
					ret.a = 1 - ((curTime % 1.9) / 1.9);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 6)) && (distance <= _FirstBand + (_FrequencyBandwidth * 7))) {
				if (_Time.y % 2.0 >= 0 && _Time.y % 2.0 < 1) {
					ret.a = ((curTime % 2.0) / 2.0);
				}
				else if (_Time.y % 2.0 >= 1 && _Time.y % 2.0 < 2.0) {
					ret.a = 1 - ((curTime % 2.0) / 2.0);
				}
			}
			else {
				ret.a = 0.1;
			}
		}
		else if (_FrequencyBandnumber == 7) {
			if (distance <= _FirstBand) {
				if (_Time.y % 0.5 >= 0 && _Time.y % 0.5 < 0.25) {			// Time 0 to  			 
					ret.a = ((curTime % 0.5) / 0.5);				// dim up
				}
				else if (_Time.y % 0.5 >= 0.25 && _Time.y % 0.5 < 0.5) {
					ret.a = 1 - ((curTime % 0.5) / 0.5);			// dim down						
				}
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_FrequencyBandwidth * 1))) {
				if (_Time.y % 0.8 >= 0 && _Time.y % 0.8 < 0.4) {		//
					ret.a = ((curTime % 0.8) / 0.8);
				}
				else if (_Time.y % 0.8 >= 0.4 && _Time.y % 0.8 < 0.8) {
					ret.a = 1 - ((curTime % 0.8) / 0.8);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 1)) && (distance <= _FirstBand + (_FrequencyBandwidth * 2))) {
				if (_Time.y % 1.1 >= 0 && _Time.y % 1.1 < 0.55) {	// 
					ret.a = ((curTime % 1.1) / 1.1);
				}
				else if (_Time.y % 1.1 >= 0.55 && _Time.y % 1.1 < 1.1) {
					ret.a = 1 - ((curTime % 1.1) / 1.1);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 2)) && (distance <= _FirstBand + (_FrequencyBandwidth * 3))) {
				if (_Time.y % 1.3 >= 0 && _Time.y % 1.3 < 0.65) {
					ret.a = ((curTime % 1.3) / 1.3);
				}
				else if (_Time.y % 1.3 >= 0.64 && _Time.y % 1.3 < 1.3) {
					ret.a = 1 - ((curTime % 1.3) / 1.3);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 3)) && (distance <= _FirstBand + (_FrequencyBandwidth * 4))) {
				if (_Time.y % 1.5 >= 0 && _Time.y % 1.5 < 0.75) {
					ret.a = ((curTime % 1.5) / 1.5);
				}
				else if (_Time.y % 1.5 >= 0.75 && _Time.y % 1.5 < 1.5) {
					ret.a = 1 - ((curTime % 1.5) / 1.5);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 4)) && (distance <= _FirstBand + (_FrequencyBandwidth * 5))) {
				if (_Time.y % 1.7 >= 0 && _Time.y % 1.7 < 0.85) {
					ret.a = ((curTime % 1.7) / 1.7);
				}
				else if (_Time.y % 1.7 >= 0.85 && _Time.y % 1.7 < 1.7) {
					ret.a = 1 - ((curTime % 1.7) / 1.7);
				}
			}
			else {
				ret.a = 0.1;
			}
		}
		else if (_FrequencyBandnumber == 5) {
			if (distance <= _FirstBand) {
				if (_Time.y % 0.5 >= 0 && _Time.y % 0.5 < 0.25) {			// Time 0 to  			 
					ret.a = ((curTime % 0.5) / 0.5);				// dim up
				}
				else if (_Time.y % 0.5 >= 0.25 && _Time.y % 0.5 < 0.5) {
					ret.a = 1 - ((curTime % 0.5) / 0.5);			// dim down						
				}
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_FrequencyBandwidth * 1))) {
				if (_Time.y % 0.8 >= 0 && _Time.y % 0.8 < 0.4) {		//
					ret.a = ((curTime % 0.8) / 0.8);
				}
				else if (_Time.y % 0.8 >= 0.4 && _Time.y % 0.8 < 0.8) {
					ret.a = 1 - ((curTime % 0.8) / 0.8);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 1)) && (distance <= _FirstBand + (_FrequencyBandwidth * 2))) {
				if (_Time.y % 1.1 >= 0 && _Time.y % 1.1 < 0.55) {	// 
					ret.a = ((curTime % 1.1) / 1.1);
				}
				else if (_Time.y % 1.1 >= 0.55 && _Time.y % 1.1 < 1.1) {
					ret.a = 1 - ((curTime % 1.1) / 1.1);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 2)) && (distance <= _FirstBand + (_FrequencyBandwidth * 3))) {
				if (_Time.y % 1.3 >= 0 && _Time.y % 1.3 < 0.65) {
					ret.a = ((curTime % 1.3) / 1.3);
				}
				else if (_Time.y % 1.3 >= 0.64 && _Time.y % 1.3 < 1.3) {
					ret.a = 1 - ((curTime % 1.3) / 1.3);
				}
			}
			else if ((distance > _FirstBand + (_FrequencyBandwidth * 3)) && (distance <= _FirstBand + (_FrequencyBandwidth * 4))) {
				if (_Time.y % 1.5 >= 0 && _Time.y % 1.5 < 0.75) {
					ret.a = ((curTime % 1.5) / 1.5);
				}
				else if (_Time.y % 1.5 >= 0.75 && _Time.y % 1.5 < 1.5) {
					ret.a = 1 - ((curTime % 1.5) / 1.5);
				}
			}
			else {
				ret.a = 0.1;
			}
		}
		else if (_FrequencyBandnumber == 3) {
			if (distance <= _FirstBand) {
				if (_Time.y % 0.5 >= 0 && _Time.y % 0.5 < 0.25) {			// Time 0 to  			 
					ret.a = ((curTime % 0.5) / 0.5);				// dim up
				}
				else if (_Time.y % 0.5 >= 0.25 && _Time.y % 0.5 < 0.5) {
					ret.a = 1 - ((curTime % 0.5) / 0.5);			// dim down						
				}
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_FrequencyBandwidth * 1))) {
				if (_Time.y % 1.0 >= 0 && _Time.y % 1.0 < 0.5) {		//
					ret.a = ((curTime % 1.0) / 1.0);
				}
				else if (_Time.y % 1.0 >= 0.5 && _Time.y % 1.0 < 1.0) {
					ret.a = 1 - ((curTime % 1.0) / 1.0);
				}
			}
			else {
				ret.a = 0.1;
			}
		}



		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;

		return ret;	    // Need to return frag here with color code strategy so color isn't changed below

	}
	// Dynamic shader 3: pulsating; same as before but higher brightness (alpha from 0.5 - 1)
	// NOTE: Unity throws error messages like "Invalid const register num: ", although it doesn not seem to 
	// affect the shaders and deploy works fine, it seems to be related to number of slots used in the compiled shader code
	// click on "Compile and show code" to see the compiled shader
	else if (_Equation == 11) {

		float curTime = _Time.y;

		if (distance <= 1.5) {											// 1 - 1.5 meters	= white
			if (_Time.y % 0.1 >= 0 && _Time.y % 0.1 < 0.05) {			// 
				ret.g = 1;
				ret.a = 0.5 + ((curTime % 0.1 - 0) / 0.1 - 0);  // have value change between zero and 1
			}
			else if (_Time.y % 0.1 >= 0.05 && _Time.y % 0.1 < 0.1) {
				ret.g = 1;
				ret.a = 1.5 - ((curTime % 0.1 - 0) / 0.1 - 0);									// blue
			}
		}
		else if ((distance > 1.5) && (distance <= 2.5)) {			// 2.5 - 2.5 meters
			if (_Time.y % 0.2 >= 0 && _Time.y % 0.2 < 0.1) {		//
				ret.g = 1;
				ret.a = 0.5 + ((curTime % 0.2 - 0) / 0.2 - 0);
			}
			else if (_Time.y % 0.2 >= 0.1 && _Time.y % 0.2 < 0.2) {
				ret.g = 1;
				ret.a = 1.5 - ((curTime % 0.2 - 0) / 0.2 - 0);
			}
		}
		else if ((distance > 2.5) && (distance <= 3.5)) {		// 2.5 - 3.5 meters
			if (_Time.y % 0.3 >= 0 && _Time.y % 0.3 < 0.15) {	// 
				ret.g = 1;
				ret.a = 0.5 + ((curTime % 0.3 - 0) / 0.3 - 0);
			}
			else if (_Time.y % 0.3 >= 0.15 && _Time.y % 0.3 < 0.3) {
				ret.g = 1;
				ret.a = 1.5 - ((curTime % 0.3 - 0) / 0.3 - 0);
			}
		}
		else if ((distance > 3.5) && (distance <= 4.5)) {					// 3.5 - 4.5 m
			if (_Time.y % 0.4 >= 0 && _Time.y % 0.4 < 0.2) {		// 4.5Hz flicker
				ret.g = 1;
				ret.a = 0.5 + ((curTime % 0.4 - 0) / 0.4 - 0);
			}
			else if (_Time.y % 0.4 >= 0.2 && _Time.y % 0.4 < 0.4) {
				ret.g = 1;
				ret.a = 1.5 - ((curTime % 0.4 - 0) / 0.4 - 0);
			}
		}
		else if ((distance > 4.5) && (distance <= 5.5)) {					// 4.5 - 5.5 m
			if (_Time.y % 0.5 >= 0 && _Time.y % 0.5 < 0.25) {		// 4.5Hz flicker
				ret.g = 1;
				ret.a = 0.5 + ((curTime % 0.5 - 0) / 0.5 - 0);
			}
			else if (_Time.y % 0.5 >= 0.25 && _Time.y % 0.5 < 0.5) {
				ret.g = 1;
				ret.a = 1.5 - ((curTime % 0.5 - 0) / 0.5 - 0);
			}
		}
		else {							// 5.5+ meters = dark grey
			ret.g = 1;
			ret.a = 0.1;
		}



		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;

		return ret;	    // Need to return frag here with color code strategy so color isn't changed below

	} 

	///////////////////
	// red to blue shader
	// red to blue in 11 steps
	else if (_Equation == 12) {
		
		if (_ColorBandnumber == 11) {

			if (distance <= _FirstBand) {
				ret.r = 165 / 255.0f;
				ret.g = 0 / 255.0f;
				ret.b = 38 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_ColorBandwidth * 1))) {
				ret.r = 215 / 255.0f;
				ret.g = 48 / 255.0f;
				ret.b = 39 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 1)) && (distance <= _FirstBand + (_ColorBandwidth * 2))) {
				ret.r = 244 / 255.0f;
				ret.g = 109 / 255.0f;
				ret.b = 67 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 2)) && (distance <= _FirstBand + (_ColorBandwidth * 3))) {
				ret.r = 253 / 255.0f;
				ret.g = 174 / 255.0f;
				ret.b = 97 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 3)) && (distance <= _FirstBand + (_ColorBandwidth * 4))) {
				ret.r = 254 / 255.0f;
				ret.g = 224 / 255.0f;
				ret.b = 144 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 4)) && (distance <= _FirstBand + (_ColorBandwidth * 5))) {
				ret.r = 255 / 255.0f;
				ret.g = 255 / 255.0f;
				ret.b = 191 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 5)) && (distance <= _FirstBand + (_ColorBandwidth * 6))) {
				ret.r = 224 / 255.0f;
				ret.g = 243 / 255.0f;
				ret.b = 248 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 6)) && (distance <= _FirstBand + (_ColorBandwidth * 7))) {
				ret.r = 171 / 255.0f;
				ret.g = 217 / 255.0f;
				ret.b = 233 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 7)) && (distance <= _FirstBand + (_ColorBandwidth * 8))) {
				ret.r = 116 / 255.0f;
				ret.g = 173 / 255.0f;
				ret.b = 209 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 8)) && (distance <= _FirstBand + (_ColorBandwidth * 9))) {
				ret.r = 69 / 255.0f;
				ret.g = 117 / 255.0f;
				ret.b = 180 / 255.0f;
				ret.a = 1.0;
			}
			else {
				ret.r = 49 / 255.0f;
				ret.g = 54 / 255.0f;
				ret.b = 149 / 255.0f;
				ret.a = 1.0;
			}
		}
		if (_ColorBandnumber == 10) {

			if (distance <= _FirstBand) {
				ret.r = 165 / 255.0f;
				ret.g = 0 / 255.0f;
				ret.b = 38 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_ColorBandwidth * 1))) {
				ret.r = 244 / 255.0f;
				ret.g = 109 / 255.0f;
				ret.b = 67 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 1)) && (distance <= _FirstBand + (_ColorBandwidth * 2))) {
				ret.r = 253 / 255.0f;
				ret.g = 174 / 255.0f;
				ret.b = 97 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 2)) && (distance <= _FirstBand + (_ColorBandwidth * 3))) {
				ret.r = 254 / 255.0f;
				ret.g = 224 / 255.0f;
				ret.b = 144 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 3)) && (distance <= _FirstBand + (_ColorBandwidth * 4))) {
				ret.r = 255 / 255.0f;
				ret.g = 255 / 255.0f;
				ret.b = 191 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 4)) && (distance <= _FirstBand + (_ColorBandwidth * 5))) {
				ret.r = 224 / 255.0f;
				ret.g = 243 / 255.0f;
				ret.b = 248 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 5)) && (distance <= _FirstBand + (_ColorBandwidth * 6))) {
				ret.r = 171 / 255.0f;
				ret.g = 217 / 255.0f;
				ret.b = 233 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 6)) && (distance <= _FirstBand + (_ColorBandwidth * 7))) {
				ret.r = 116 / 255.0f;
				ret.g = 173 / 255.0f;
				ret.b = 209 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 7)) && (distance <= _FirstBand + (_ColorBandwidth * 8))) {
				ret.r = 69 / 255.0f;
				ret.g = 117 / 255.0f;
				ret.b = 180 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 8)) && (distance <= _FirstBand + (_ColorBandwidth * 9))) {
				ret.r = 49 / 255.0f;
				ret.g = 54 / 255.0f;
				ret.b = 149 / 255.0f;
				ret.a = 1.0;
			}
			else {
				ret.r = 49 / 255.0f;
				ret.g = 54 / 255.0f;
				ret.b = 149 / 255.0f;
				ret.a = 0.5;
			}
		}
		else if (_ColorBandnumber == 9) {

			if (distance <= _FirstBand) {
				ret.r = 215 / 255.0f;
				ret.g = 48 / 255.0f;
				ret.b = 39 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_ColorBandwidth * 1))) {
				ret.r = 244 / 255.0f;
				ret.g = 109 / 255.0f;
				ret.b = 67 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 1)) && (distance <= _FirstBand + (_ColorBandwidth * 2))) {
				ret.r = 253 / 255.0f;
				ret.g = 174 / 255.0f;
				ret.b = 97 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 2)) && (distance <= _FirstBand + (_ColorBandwidth * 3))) {
				ret.r = 254 / 255.0f;
				ret.g = 224 / 255.0f;
				ret.b = 144 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 3)) && (distance <= _FirstBand + (_ColorBandwidth * 4))) {
				ret.r = 255 / 255.0f;
				ret.g = 255 / 255.0f;
				ret.b = 191 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 4)) && (distance <= _FirstBand + (_ColorBandwidth * 5))) {
				ret.r = 224 / 255.0f;
				ret.g = 243 / 255.0f;
				ret.b = 248 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 5)) && (distance <= _FirstBand + (_ColorBandwidth * 6))) {
				ret.r = 171 / 255.0f;
				ret.g = 217 / 255.0f;
				ret.b = 233 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 6)) && (distance <= _FirstBand + (_ColorBandwidth * 7))) {
				ret.r = 116 / 255.0f;
				ret.g = 173 / 255.0f;
				ret.b = 209 / 255.0f;
				ret.a = 1.0;
			}
			else {
				ret.r = 69 / 255.0f;
				ret.g = 117 / 255.0f;
				ret.b = 180 / 255.0f;
				ret.a = 1.0;
			}
		}
		else if (_ColorBandnumber == 7) {

			if (distance <= _FirstBand) {
				ret.r = 165 / 255.0f;
				ret.g = 0 / 255.0f;
				ret.b = 38 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_ColorBandwidth * 1))) {
				ret.r = 215 / 255.0f;
				ret.g = 48 / 255.0f;
				ret.b = 39 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 1)) && (distance <= _FirstBand + (_ColorBandwidth * 2))) {
				ret.r = 244 / 255.0f;
				ret.g = 109 / 255.0f;
				ret.b = 67 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 2)) && (distance <= _FirstBand + (_ColorBandwidth * 3))) {
				ret.r = 253 / 255.0f;
				ret.g = 174 / 255.0f;
				ret.b = 97 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 3)) && (distance <= _FirstBand + (_ColorBandwidth * 4))) {
				ret.r = 254 / 255.0f;
				ret.g = 224 / 255.0f;
				ret.b = 144 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 4)) && (distance <= _FirstBand + (_ColorBandwidth * 5))) {
				ret.r = 255 / 255.0f;
				ret.g = 255 / 255.0f;
				ret.b = 191 / 255.0f;
				ret.a = 1.0;
			}
			else {
				ret.r = 49 / 255.0f;
				ret.g = 54 / 255.0f;
				ret.b = 149 / 255.0f;
				ret.a = 1.0;
			}
		}
		else if (_ColorBandnumber == 5) {
		}
		else if (_ColorBandnumber == 6) {
			if (distance <= _FirstBand) {
				ret.r = 215 / 255.0f;
				ret.g = 48 / 255.0f;
				ret.b = 39 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_ColorBandwidth * 1))) {
				ret.r = (252 / 255.0f);
				ret.g = (141 / 255.0f);
				ret.b = (49 / 255.0f);
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 1)) && (distance <= _FirstBand + (_ColorBandwidth * 2))) {
				ret.r = 254 / 255.0f;
				ret.g = 224 / 255.0f;
				ret.b = 144 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 2)) && (distance <= _FirstBand + (_ColorBandwidth * 3))) {
				ret.r = 224 / 255.0f;
				ret.g = 243 / 255.0f;
				ret.b = 248 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand + (_ColorBandwidth * 3)) && (distance <= _FirstBand + (_ColorBandwidth * 4))) {
				ret.r = 145 / 255.0f;
				ret.g = 191 / 255.0f;
				ret.b = 219 / 255.0f;
				ret.a = 1.0;
			}
			else {
				ret.r = 69 / 255.0f;
				ret.g = 117 / 255.0f;
				ret.b = 180 / 255.0f;
				ret.a = 1.0;
			}
		}
		else if (_ColorBandnumber == 3) {

			if (distance <= _FirstBand) {
				ret.r = 252 / 255.0f;
				ret.g = 141 / 255.0f;
				ret.b = 89 / 255.0f;
				ret.a = 1.0;
			}
			else if ((distance > _FirstBand) && (distance <= _FirstBand + (_ColorBandwidth * 1))) {
				ret.r = (255 / 255.0f);
				ret.g = (255 / 255.0f);
				ret.b = (191 / 255.0f);
				ret.a = 1.0;
			}
			else {
				ret.r = 145 / 255.0f;
				ret.g = 191 / 255.0f;
				ret.b = 219 / 255.0f;
				ret.a = 1.0;
			}
		} 


		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		
		ret.r = 145 / 255.0f;
		ret.g = 191 / 255.0f;
		ret.b = 219 / 255.0f;
		ret.a = 1.0;
		return ret;
	}


	///////////////////
	///////////////////
	else if (_Equation == 13) {
		if (distance <= 1.5) {
			ret.r = 215 / 255.0f;
			ret.g = 25 / 255.0f;
			ret.b = 28 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 1.5) && (distance <= 2.5)) {
			ret.r = 253 / 255.0f;
			ret.g = 174 / 255.0f;
			ret.b = 97 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 2.5) && (distance <= 3.5)) {
			ret.r = 255 / 255.0f;
			ret.g = 255 / 255.0f;
			ret.b = 191 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 3.5) && (distance <= 4.5)) {
			ret.r = 171 / 255.0f;
			ret.g = 217 / 255.0f;
			ret.b = 233 / 255.0f;
			ret.a = 1.0;
		}
		else {
			ret.r = 44 / 255.0f;
			ret.g = 123 / 255.0f;
			ret.b = 182 / 255.0f;
			ret.a = 1.0;
		}

		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;
	}

	///////////////////
	///////////////////
	else if (_Equation == 14) {
		if (distance <= 1.5) {
			ret.r = 255 / 255.0f;
			ret.g = 255 / 255.0f;
			ret.b = 204 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 1.5) && (distance <= 2.5)) {
			ret.r = (199 / 255.0f);
			ret.g = (233 / 255.0f);
			ret.b = (180 / 255.0f);
			ret.a = 1.0;
		}
		else if ((distance > 2.5) && (distance <= 3.5)) {
			ret.r = 127 / 255.0f;
			ret.g = 205 / 255.0f;
			ret.b = 187 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 3.5) && (distance <= 4.5)) {
			ret.r = 65 / 255.0f;
			ret.g = 182 / 255.0f;
			ret.b = 196 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 4.5) && (distance <= 5.5)) {
			ret.r = 44 / 255.0f;
			ret.g = 127 / 255.0f;
			ret.b = 184 / 255.0f;
			ret.a = 1.0;
		}
		else {
			ret.r = 37 / 255.0f;
			ret.g = 52 / 255.0f;
			ret.b = 148 / 255.0f;
			ret.a = 1.0;
		}

		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;
	}

	///////////////////
	///////////////////
	else if (_Equation == 15) {
		if (distance <= 1.5) {
			ret.r = 255 / 255.0f;
			ret.g = 255 / 255.0f;
			ret.b = 204 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 1.5) && (distance <= 2.5)) {
			ret.r = 161 / 255.0f;
			ret.g = 218 / 255.0f;
			ret.b = 180 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 2.5) && (distance <= 3.5)) {
			ret.r = 65 / 255.0f;
			ret.g = 182 / 255.0f;
			ret.b = 196 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 3.5) && (distance <= 4.5)) {
			ret.r = 44 / 255.0f;
			ret.g = 127 / 255.0f;
			ret.b = 184 / 255.0f;
			ret.a = 1.0;
		}
		else {
			ret.r = 37 / 255.0f;
			ret.g = 52 / 255.0f;
			ret.b = 148 / 255.0f;
			ret.a = 1.0;
		}

		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;
	}

	///////////////////
	///////////////////
	else if (_Equation == 16) {
		if (distance <= 1.5) {
			ret.r = 255 / 255.0f;
			ret.g = 255 / 255.0f;
			ret.b = 178 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 1.5) && (distance <= 2.5)) {
			ret.r = 254 / 255.0f;
			ret.g = 217 / 255.0f;
			ret.b = 118 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 2.5) && (distance <= 3.5)) {
			ret.r = 254 / 255.0f;
			ret.g = 178 / 255.0f;
			ret.b = 76 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 3.5) && (distance <= 4.5)) {
			ret.r = 253 / 255.0f;
			ret.g = 141 / 255.0f;
			ret.b = 60 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 4.5) && (distance <= 5.5)) {
			ret.r = 240 / 255.0f;
			ret.g = 59 / 255.0f;
			ret.b = 32 / 255.0f;
			ret.a = 1.0;
		}
		else {
			ret.r = 189 / 255.0f;
			ret.g = 0 / 255.0f;
			ret.b = 38 / 255.0f;
			ret.a = 1.0;
		}

		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;
	}

	///////////////////
	///////////////////
	else if (_Equation == 17) {
		if (distance <= 1.5) {
			ret.r = 255 / 255.0f;
			ret.g = 255 / 255.0f;
			ret.b = 178 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 1.5) && (distance <= 2.5)) {
			ret.r = 254 / 255.0f;
			ret.g = 204 / 255.0f;
			ret.b = 92 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 2.5) && (distance <= 3.5)) {
			ret.r = 253 / 255.0f;
			ret.g = 141 / 255.0f;
			ret.b = 60 / 255.0f;
			ret.a = 1.0;
		}
		else if ((distance > 3.5) && (distance <= 4.5)) {
			ret.r = 240 / 255.0f;
			ret.g = 59 / 255.0f;
			ret.b = 32 / 255.0f;
			ret.a = 1.0;
		}
		else {
			ret.r = 189 / 255.0f;
			ret.g = 0 / 255.0f;
			ret.b = 38 / 255.0f;
			ret.a = 1.0;
		}

		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;
	}
	///////////////////
	// HoloLens asjustment overlay: everything white
	else if (_Equation == 18) {

		ret.r = 1;
		ret.g = 1;
		ret.b = 1;
		ret.a = 1;

		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;	    // Need to return frag here with color code strategy so color isn't changed below

	}	// HoloLens control condition overlay: everything blue with low alpha
	else if (_Equation == 19) {

		ret.r = 69 / 255.0f; ret.g = 117 / 255.0f; ret.b = 180 / 255.0f;
		ret.a = 0.5;

		ret.r *= ret.a;
		ret.g *= ret.a;
		ret.b *= ret.a;
		return ret;	    // Need to return frag here with color code strategy so color isn't changed below

	}
	else if (_Equation == 20) {

		ret.r = 69 / 255.0f; ret.g = 117 / 255.0f; ret.b = 180 / 255.0f;
		if (raycast_distance <= 0.5) {
			ret.a = 1.0;
		}
		else {
			ret.a = 0.0;
		}
		return ret;
	}

	// Set the color depending on input from the user
	if (_Color == 0) {						    // White
		ret.r = depth; ret.g = depth; ret.b = depth;
	}
	else if (_Color == 1) {				    // Blue
		ret.r = depth;
	}
	else if (_Color == 2) {				    // Green
		ret.g = depth;
	}
	else if (_Color == 3) {					// Red
		ret.b = depth;
	}
	else if (_Color == 4) {					// Yellow
		ret.r = depth; ret.g = depth;
	}
	else if (_Color == 5) {					// Orange
		ret.r = depth; ret.g = depth / 0.65;
	}
	else if (_Color == 6) {					// Purple
		ret.r = depth / 0.65; ret.g = depth / 0.13; ret.b = depth / 0.95;
	}
	else {									// Grey
		ret.r = depth / 0.5; ret.g = depth / 0.5; ret.b = depth / 0.5;
	}
	*/