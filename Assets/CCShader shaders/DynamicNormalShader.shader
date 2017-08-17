Shader "Unlit/DynamicNormalShader"
{
	 // no Properties block this time!
	 SubShader
	{
		  Pass
		  { 
		    CGPROGRAM
			     #pragma vertex vert
			     #pragma fragment frag
			     #include "UnityCG.cginc"

			     struct v2f 
			     {
				      half3 worldNormal : TEXCOORD0;
				      float4 pos : SV_POSITION;
			     };

			     v2f vert(float4 vertex : POSITION, float3 normal : NORMAL)
			     {
				      v2f o;
				      o.pos = mul(UNITY_MATRIX_MVP, vertex);
				      o.worldNormal = UnityObjectToWorldNormal(normal);
				      return o;
			     }

			     fixed4 frag(v2f i) : SV_Target
			     {
				      fixed4 c = 0;

				      float tempX = (0.5 * i.worldNormal.x) + 0.5;
				      float tempY = (0.5 * i.worldNormal.y) + 0.5;
				      float tempZ = (0.5 * i.worldNormal.z) + 0.5;

				      if (_Time.y % 3 >= 0 && _Time.y % 3 < 1){
				      	  // don't remap
					      i.worldNormal.x = tempX;
					      i.worldNormal.y = tempY;
					      i.worldNormal.z = tempZ;

				      } else if (_Time.y % 3 >= 1 && _Time.y % 3< 2){
					      // remap x->y, y->z, z->x
					      i.worldNormal.x = tempY;
					      i.worldNormal.y = tempZ;
					      i.worldNormal.z = tempX;
				      } else if (_Time.y % 3 >= 2){
					      // remap x->z, y->x, z->y
					      float dummy = i.worldNormal.z;
					      i.worldNormal.x = tempZ;
					      i.worldNormal.y = tempX;
					      i.worldNormal.z = tempY;
				      }
				     
				      c.rgb = i.worldNormal * 1.0;
				      return c;
			     }
		    ENDCG
		  }
	 }
}