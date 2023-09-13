//***************************************************************************************
// color.hlsl by Frank Luna (C) 2015 All Rights Reserved.
//
// Transforms and colors geometry.
//***************************************************************************************
 
//use matrix as whole
/*cbuffer cbPerObject : register(b0)
{
	float4x4 gWorld; 
};
*/


//ust root constants to represent gWorld
struct ObjectConstants
{
    float gWorld00;
    float gWorld01;
    float gWorld02;
    float gWorld03;
    float gWorld10;
    float gWorld11;
    float gWorld12;
    float gWorld13;
    float gWorld20;
    float gWorld21;
    float gWorld22;
    float gWorld23;
    float gWorld30;
    float gWorld31;
    float gWorld32;
    float gWorld33;
};

cbuffer gPerObjectConst : register(b0)
{
    ObjectConstants mMatrix;
};


cbuffer cbPass : register(b1)
{
    float4x4 gView;
    float4x4 gInvView;
    float4x4 gProj;
    float4x4 gInvProj;
    float4x4 gViewProj;
    float4x4 gInvViewProj;
    float3 gEyePosW;
    float cbPerObjectPad1;
    float2 gRenderTargetSize;
    float2 gInvRenderTargetSize;
    float gNearZ;
    float gFarZ;
    float gTotalTime;
    float gDeltaTime;
};

struct VertexIn
{
	float3 PosL  : POSITION;
    float4 Color : COLOR;
};

struct VertexOut
{
	float4 PosH  : SV_POSITION;
    float4 Color : COLOR;
};

VertexOut VS(VertexIn vin)
{
	VertexOut vout;
	
	// Transform to homogeneous clip space.
    float4x4 gWorld = float4x4(
        float4(mMatrix.gWorld00, mMatrix.gWorld01, mMatrix.gWorld02, mMatrix.gWorld03),
        float4(mMatrix.gWorld10, mMatrix.gWorld11, mMatrix.gWorld12, mMatrix.gWorld13),
        float4(mMatrix.gWorld20, mMatrix.gWorld21, mMatrix.gWorld22, mMatrix.gWorld23),
        float4(mMatrix.gWorld30, mMatrix.gWorld31, mMatrix.gWorld32, mMatrix.gWorld33)
    );
    float4 posW = mul(float4(vin.PosL, 1.0f), gWorld);
    vout.PosH = mul(posW, gViewProj);
	
	// Just pass vertex color into the pixel shader.
    vout.Color = vin.Color;
    
    return vout;
}

float4 PS(VertexOut pin) : SV_Target
{
    return pin.Color;
}


