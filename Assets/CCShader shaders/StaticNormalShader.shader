Shader "Unlit/StaticNormalShader"
{
	 // No properties necessary
	 SubShader
	{
		  Pass
		  { 
		    CGPROGRAM
			     #pragma vertex vert
			     #pragma fragment frag
			     #include "UnityCG.cginc"  // Need for UnityObjectToWorldNormal helper function

				 // Vertex to fragment structure - defines what information is passed from
				 // the vertex to fragment program
			     struct v2f 
			     {
				      half3 worldNormal : TEXCOORD0;
				      float4 pos : SV_POSITION;
			     };

				 // Vertex function - compute the position and output input normal and return it
			     v2f vert(float4 vertex : POSITION, float3 normal : NORMAL)
			     {
				      v2f o;
				      o.pos = mul(UNITY_MATRIX_MVP, vertex);
				      o.worldNormal = UnityObjectToWorldNormal(normal);
				      return o;
			     }

				 // Fragment function - outputs the calculated color based on the normals
			     fixed4 frag(v2f i) : SV_Target
			     {
				      fixed4 c = 0;

				      // Remap worldNormal values from -1.0 -> 1.0 scale to 0.0 -> 1.0 scale
					  c.rgb = i.worldNormal * 0.5 + 0.5;
				      return c;
			     }
		    ENDCG
		  }
	 }
}