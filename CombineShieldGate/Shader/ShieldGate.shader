// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AlyxShieldGate"
{
	Properties
	{
		[HDR][Header(________________________________________________________________________________________________________________)][Space(5)][Header(Alyx Shield Gate Shader)][Header(________________________________________________________________________________________________________________)][Space(10)]_Color("Color", Color) = (1,1,1,1)
		_Opacity("Opacity", Range( 0 , 1)) = 1
		[Space(5)][Header(Textures)][Space(5)]_ShieldMask("Shield Mask", 2D) = "white" {}
		_ShieldWave1("Shield Wave 1", 2D) = "white" {}
		[HDR][Space(15)][Header(Wave Settings)][Space(5)]_WaveColor("Wave Color", Color) = (1,1,1,1)
		_WaveTiling("Wave Tiling", Float) = 1
		_WaveSpeed("Wave Speed", Float) = 1
		[Space(15)][Header(Perlin Settings)][Space(5)]_PerlinGradientTiling("Perlin Gradient Tiling", Float) = 1
		_PerlinTiling("Perlin Tiling", Float) = 1
		_PerlinSpeed("Perlin Speed", Vector) = (0.03,-0.03,0,0)
		[Space(15)][Header(Touch Settings)][Space(5)]_TouchSensitivity("Touch Sensitivity", Float) = 1.25
		[HDR]_TouchColor("Touch Color", Color) = (0.240566,0.985278,1,1)
		[Space(15)][Header(Blink Settings)][Space(5)]_BlinkStrength("Blink Strength", Range( 0 , 1)) = 0.5
		_BlinkSpeed("Blink Speed", Float) = 4
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _Color;
		uniform sampler2D _ShieldMask;
		uniform float4 _ShieldMask_ST;
		uniform sampler2D _ShieldWave1;
		uniform float _WaveSpeed;
		uniform float2 _PerlinSpeed;
		uniform float _PerlinTiling;
		uniform float _PerlinGradientTiling;
		uniform float _WaveTiling;
		uniform float4 _WaveColor;
		uniform float4 _TouchColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _TouchSensitivity;
		uniform float _Opacity;
		uniform float _BlinkStrength;
		uniform float _BlinkSpeed;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_ShieldMask = i.uv_texcoord * _ShieldMask_ST.xy + _ShieldMask_ST.zw;
			float4 tex2DNode1 = tex2D( _ShieldMask, uv_ShieldMask );
			float2 temp_cast_0 = (_WaveSpeed).xx;
			float2 temp_cast_1 = (_PerlinTiling).xx;
			float2 uv_TexCoord74 = i.uv_texcoord * temp_cast_1;
			float2 panner76 = ( 1.0 * _Time.y * _PerlinSpeed + uv_TexCoord74);
			float2 temp_cast_2 = (( ( tex2DNode1.g + ( tex2D( _ShieldMask, panner76 ).b * _PerlinGradientTiling ) ) * _WaveTiling )).xx;
			float2 panner6 = ( 1.0 * _Time.y * temp_cast_0 + temp_cast_2);
			float4 ShieldEmiss43 = ( ( _Color * tex2DNode1.r ) + ( tex2D( _ShieldWave1, panner6 ) * _WaveColor ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth36 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth36 = abs( ( screenDepth36 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float saferPower37 = max( distanceDepth36 , 0.0001 );
			float temp_output_39_0 = ( 1.0 - ( pow( saferPower37 , 0.1 ) * _TouchSensitivity ) );
			float Opacity30 = tex2DNode1.r;
			o.Emission = ( ShieldEmiss43 + max( ( _TouchColor * 10.0 * temp_output_39_0 * ShieldEmiss43 * Opacity30 ) , float4( 0,0,0,0 ) ) ).rgb;
			float mulTime26 = _Time.y * _BlinkSpeed;
			float lerpResult29 = lerp( ( 1.0 - _BlinkStrength ) , 1.0 , ( ( sin( mulTime26 ) * 0.5 ) + 0.5 ));
			o.Alpha = saturate( ( ( saturate( temp_output_39_0 ) + ShieldEmiss43 + Opacity30 ) * _Opacity * lerpResult29 ) ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
0;554;1407;485;1387.13;-13.25516;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;77;-4353.042,448.058;Inherit;False;Property;_PerlinTiling;Perlin Tiling;8;0;Create;True;0;0;0;False;0;False;1;1.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;74;-4214.7,428.8135;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;78;-4185.96,543.3716;Inherit;False;Property;_PerlinSpeed;Perlin Speed;9;0;Create;True;0;0;0;False;0;False;0.03,-0.03;-0.05,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;76;-3995.202,470.387;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-3722.393,627.1906;Inherit;False;Property;_PerlinGradientTiling;Perlin Gradient Tiling;7;0;Create;True;0;0;0;False;3;Space(15);Header(Perlin Settings);Space(5);False;1;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;-3800.854,440.2924;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-3525.207,266.1892;Inherit;True;Property;_ShieldMask;Shield Mask;2;0;Create;True;0;0;0;False;3;Space(5);Header(Textures);Space(5);False;-1;696596801f3d44e42bfedeb25f362b22;696596801f3d44e42bfedeb25f362b22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-3367.879,461.4096;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-3205.539,386.7293;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-3209.173,481.8502;Inherit;False;Property;_WaveTiling;Wave Tiling;5;0;Create;True;0;0;0;False;0;False;1;5.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2956.58,597.6088;Inherit;False;Property;_WaveSpeed;Wave Speed;6;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2989.784,385.1111;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;-2743.598,384.3845;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1020.248,673.9944;Inherit;False;Property;_BlinkSpeed;Blink Speed;13;0;Create;True;0;0;0;False;0;False;4;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-2543.893,353.8734;Inherit;True;Property;_ShieldWave1;Shield Wave 1;3;0;Create;True;0;0;0;False;0;False;-1;None;3aef9b655250046488eecba34f1edfe4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-2472.496,123.7817;Inherit;False;Property;_Color;Color;0;1;[HDR];Create;True;0;0;0;False;5;Header(________________________________________________________________________________________________________________);Space(5);Header(Alyx Shield Gate Shader);Header(________________________________________________________________________________________________________________);Space(10);False;1,1,1,1;0,1.529412,1.976471,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-2456.103,537.5266;Inherit;False;Property;_WaveColor;Wave Color;4;1;[HDR];Create;True;0;0;0;False;3;Space(15);Header(Wave Settings);Space(5);False;1,1,1,1;0.1770492,0.3304918,0.36,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;36;-1206.03,312.8774;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-873.2275,678.631;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2216.087,359.6651;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2216.779,269.7282;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1005.33,408.6078;Inherit;False;Property;_TouchSensitivity;Touch Sensitivity;10;0;Create;True;0;0;0;False;3;Space(15);Header(Touch Settings);Space(5);False;1.25;1.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;37;-968.5103,312.5289;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-2030.954,307.3577;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;28;-714.5333,677.8121;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-807.3309,313.2046;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-3199.556,257.0912;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-1907.95,308.3039;Inherit;False;ShieldEmiss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-759.3354,604.5789;Inherit;False;Property;_BlinkStrength;Blink Strength;12;0;Create;True;0;0;0;False;3;Space(15);Header(Blink Settings);Space(5);False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-663.9709,335.9335;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-595.4571,677.3575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;41;-447.2176,375.8894;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-682.3633,468.0804;Inherit;False;30;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-695.9582,398.7825;Inherit;False;43;ShieldEmiss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-662.5259,237.5037;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-466.1114,677.8123;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;95;-494.2481,609.9944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-723.9785,76.83821;Inherit;False;Property;_TouchColor;Touch Color;11;1;[HDR];Create;True;0;0;0;False;0;False;0.240566,0.985278,1,1;0.7372549,2.964706,2.996078,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;29;-347.071,609.7129;Inherit;False;3;0;FLOAT;0.5;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-246.011,382.7849;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-466.145,535.4938;Inherit;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;0;False;0;False;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-446.1859,212.2899;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-382.7363,142.166;Inherit;False;43;ShieldEmiss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;47;-324.5192,213.7617;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-77.73379,383.4273;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;90;46.22657,384.1289;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-194.3583,166.7239;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;240.0194,108.1557;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AlyxShieldGate;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;74;0;77;0
WireConnection;76;0;74;0
WireConnection;76;2;78;0
WireConnection;73;1;76;0
WireConnection;50;0;73;3
WireConnection;50;1;51;0
WireConnection;71;0;1;2
WireConnection;71;1;50;0
WireConnection;7;0;71;0
WireConnection;7;1;8;0
WireConnection;6;0;7;0
WireConnection;6;2;20;0
WireConnection;2;1;6;0
WireConnection;26;0;96;0
WireConnection;18;0;2;0
WireConnection;18;1;16;0
WireConnection;9;0;4;0
WireConnection;9;1;1;1
WireConnection;37;0;36;0
WireConnection;10;0;9;0
WireConnection;10;1;18;0
WireConnection;28;0;26;0
WireConnection;38;0;37;0
WireConnection;38;1;42;0
WireConnection;30;0;1;1
WireConnection;43;0;10;0
WireConnection;39;0;38;0
WireConnection;25;0;28;0
WireConnection;41;0;39;0
WireConnection;23;0;25;0
WireConnection;95;0;94;0
WireConnection;29;0;95;0
WireConnection;29;2;23;0
WireConnection;33;0;41;0
WireConnection;33;1;91;0
WireConnection;33;2;31;0
WireConnection;40;0;48;0
WireConnection;40;1;97;0
WireConnection;40;2;39;0
WireConnection;40;3;91;0
WireConnection;40;4;31;0
WireConnection;47;0;40;0
WireConnection;63;0;33;0
WireConnection;63;1;62;0
WireConnection;63;2;29;0
WireConnection;90;0;63;0
WireConnection;46;0;44;0
WireConnection;46;1;47;0
WireConnection;0;2;46;0
WireConnection;0;9;90;0
ASEEND*/
//CHKSM=AEB363796FA6EEBEA345E36D61FC3516C7649E44