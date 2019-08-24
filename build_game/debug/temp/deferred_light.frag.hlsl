TextureCube<float4> shadowMapPoint[4];
SamplerComparisonState _shadowMapPoint_sampler[4];
uniform float2 lightProj;
uniform float4 shirr[7];
Texture2D<float4> gbuffer0;
SamplerState _gbuffer0_sampler;
Texture2D<float4> gbuffer1;
SamplerState _gbuffer1_sampler;
Texture2D<float4> gbufferD;
SamplerState _gbufferD_sampler;
uniform float3 eye;
uniform float3 eyeLook;
uniform float2 cameraProj;
uniform float3 backgroundCol;
uniform float envmapStrength;
Texture2D<float4> ssaotex;
SamplerState _ssaotex_sampler;
uniform float2 cameraPlane;
Texture2D<float4> clustersData;
SamplerState _clustersData_sampler;
uniform float4 lightsArray[32];
uniform float4 casData[20];

static float2 texCoord;
static float3 viewRay;
static float4 fragColor;

struct SPIRV_Cross_Input
{
    float2 texCoord : TEXCOORD0;
    float3 viewRay : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

float2 octahedronWrap(float2 v)
{
    return (1.0f.xx - abs(v.yx)) * float2((v.x >= 0.0f) ? 1.0f : (-1.0f), (v.y >= 0.0f) ? 1.0f : (-1.0f));
}

void unpackFloatInt16(float val, out float f, inout uint i)
{
    i = uint(int((val / 0.06250095367431640625f) + 1.525902189314365386962890625e-05f));
    f = clamp((((-0.06250095367431640625f) * float(i)) + val) / 0.06248569488525390625f, 0.0f, 1.0f);
}

float2 unpackFloat2(float f)
{
    return float2(floor(f) / 255.0f, frac(f));
}

float3 surfaceAlbedo(float3 baseColor, float metalness)
{
    return lerp(baseColor, 0.0f.xxx, metalness.xxx);
}

float3 surfaceF0(float3 baseColor, float metalness)
{
    return lerp(0.039999999105930328369140625f.xxx, baseColor, metalness.xxx);
}

float3 getPos(float3 eye_1, float3 eyeLook_1, float3 viewRay_1, float depth, float2 cameraProj_1)
{
    float linearDepth = cameraProj_1.y / (((depth * 0.5f) + 0.5f) - cameraProj_1.x);
    float viewZDist = dot(eyeLook_1, viewRay_1);
    float3 wposition = eye_1 + (viewRay_1 * (linearDepth / viewZDist));
    return wposition;
}

float3 shIrradiance(float3 nor)
{
    float3 cl00 = float3(shirr[0].x, shirr[0].y, shirr[0].z);
    float3 cl1m1 = float3(shirr[0].w, shirr[1].x, shirr[1].y);
    float3 cl10 = float3(shirr[1].z, shirr[1].w, shirr[2].x);
    float3 cl11 = float3(shirr[2].y, shirr[2].z, shirr[2].w);
    float3 cl2m2 = float3(shirr[3].x, shirr[3].y, shirr[3].z);
    float3 cl2m1 = float3(shirr[3].w, shirr[4].x, shirr[4].y);
    float3 cl20 = float3(shirr[4].z, shirr[4].w, shirr[5].x);
    float3 cl21 = float3(shirr[5].y, shirr[5].z, shirr[5].w);
    float3 cl22 = float3(shirr[6].x, shirr[6].y, shirr[6].z);
    return ((((((((((cl22 * 0.429042994976043701171875f) * ((nor.y * nor.y) - ((-nor.z) * (-nor.z)))) + (((cl20 * 0.743125021457672119140625f) * nor.x) * nor.x)) + (cl00 * 0.88622701168060302734375f)) - (cl20 * 0.2477079927921295166015625f)) + (((cl2m2 * 0.85808598995208740234375f) * nor.y) * (-nor.z))) + (((cl21 * 0.85808598995208740234375f) * nor.y) * nor.x)) + (((cl2m1 * 0.85808598995208740234375f) * (-nor.z)) * nor.x)) + ((cl11 * 1.02332794666290283203125f) * nor.y)) + ((cl1m1 * 1.02332794666290283203125f) * (-nor.z))) + ((cl10 * 1.02332794666290283203125f) * nor.x);
}

float linearize(float depth, float2 cameraProj_1)
{
    return cameraProj_1.y / (depth - cameraProj_1.x);
}

int getClusterI(float2 tc, float viewz, float2 cameraPlane_1)
{
    int sliceZ = 0;
    float cnear = 3.0f + cameraPlane_1.x;
    if (viewz >= cnear)
    {
        float z = log((viewz - cnear) + 1.0f) / log((cameraPlane_1.y - cnear) + 1.0f);
        sliceZ = int(z * 15.0f) + 1;
    }
    return (int(tc.x * 16.0f) + int(float(int(tc.y * 16.0f)) * 16.0f)) + int((float(sliceZ) * 16.0f) * 16.0f);
}

float3 lambertDiffuseBRDF(float3 albedo, float nl)
{
    return albedo * max(0.0f, nl);
}

float d_ggx(float nh, float a)
{
    float a2 = a * a;
    float denom = pow(((nh * nh) * (a2 - 1.0f)) + 1.0f, 2.0f);
    return (a2 * 0.3183098733425140380859375f) / denom;
}

float v_smithschlick(float nl, float nv, float a)
{
    return 1.0f / (((nl * (1.0f - a)) + a) * ((nv * (1.0f - a)) + a));
}

float3 f_schlick(float3 f0, float vh)
{
    return f0 + ((1.0f.xxx - f0) * exp2((((-5.554729938507080078125f) * vh) - 6.9831600189208984375f) * vh));
}

float3 specularBRDF(float3 f0, float roughness, float nl, float nh, float nv, float vh)
{
    float a = roughness * roughness;
    return (f_schlick(f0, vh) * (d_ggx(nh, a) * clamp(v_smithschlick(nl, nv, a), 0.0f, 1.0f))) / 4.0f.xxx;
}

float attenuate(float dist)
{
    return 1.0f / (dist * dist);
}

float lpToDepth(inout float3 lp, float2 lightProj_1)
{
    lp = abs(lp);
    float zcomp = max(lp.x, max(lp.y, lp.z));
    zcomp = lightProj_1.x - (lightProj_1.y / zcomp);
    return (zcomp * 0.5f) + 0.5f;
}

float PCFCube(TextureCube<float4> shadowMapCube, SamplerComparisonState _shadowMapCube_sampler, float3 lp, inout float3 ml, float bias, float2 lightProj_1, float3 n)
{
    float3 param = lp;
    float _291 = lpToDepth(param, lightProj_1);
    float compare = _291 - (bias * 1.5f);
    ml += ((n * bias) * 20.0f);
    ml.y = -ml.y;
    float4 _312 = float4(ml, compare);
    float result = shadowMapCube.SampleCmp(_shadowMapCube_sampler, _312.xyz, _312.w);
    float4 _324 = float4(ml + 0.001000000047497451305389404296875f.xxx, compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _324.xyz, _324.w);
    float4 _338 = float4(ml + float3(-0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _338.xyz, _338.w);
    float4 _351 = float4(ml + float3(0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _351.xyz, _351.w);
    float4 _364 = float4(ml + float3(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _364.xyz, _364.w);
    float4 _377 = float4(ml + float3(-0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _377.xyz, _377.w);
    float4 _390 = float4(ml + float3(0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _390.xyz, _390.w);
    float4 _403 = float4(ml + float3(-0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _403.xyz, _403.w);
    float4 _416 = float4(ml + (-0.001000000047497451305389404296875f).xxx, compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _416.xyz, _416.w);
    return result / 9.0f;
}

float3 sampleLight(float3 p, float3 n, float3 v, float dotNV, float3 lp, float3 lightCol, float3 albedo, float rough, float spec, float3 f0, int index, float bias)
{
    float3 ld = lp - p;
    float3 l = normalize(ld);
    float3 h = normalize(v + l);
    float dotNH = dot(n, h);
    float dotVH = dot(v, h);
    float dotNL = dot(n, l);
    float3 direct = lambertDiffuseBRDF(albedo, dotNL) + (specularBRDF(f0, rough, dotNL, dotNH, dotNV, dotVH) * spec);
    direct *= attenuate(distance(p, lp));
    direct *= lightCol;
    if (index == 0)
    {
        float3 param = -l;
        float _477 = PCFCube(shadowMapPoint[0], _shadowMapPoint_sampler[0], ld, param, bias, lightProj, n);
        direct *= _477;
    }
    else
    {
        if (index == 1)
        {
            float3 param_1 = -l;
            float _493 = PCFCube(shadowMapPoint[1], _shadowMapPoint_sampler[1], ld, param_1, bias, lightProj, n);
            direct *= _493;
        }
        else
        {
            if (index == 2)
            {
                float3 param_2 = -l;
                float _509 = PCFCube(shadowMapPoint[2], _shadowMapPoint_sampler[2], ld, param_2, bias, lightProj, n);
                direct *= _509;
            }
            else
            {
                if (index == 3)
                {
                    float3 param_3 = -l;
                    float _525 = PCFCube(shadowMapPoint[3], _shadowMapPoint_sampler[3], ld, param_3, bias, lightProj, n);
                    direct *= _525;
                }
            }
        }
    }
    return direct;
}

void frag_main()
{
    float4 g0 = gbuffer0.SampleLevel(_gbuffer0_sampler, texCoord, 0.0f);
    float3 n;
    n.z = (1.0f - abs(g0.x)) - abs(g0.y);
    float2 _758;
    if (n.z >= 0.0f)
    {
        _758 = g0.xy;
    }
    else
    {
        _758 = octahedronWrap(g0.xy);
    }
    n = float3(_758.x, _758.y, n.z);
    n = normalize(n);
    float roughness = g0.z;
    float param;
    uint param_1;
    unpackFloatInt16(g0.w, param, param_1);
    float metallic = param;
    uint matid = param_1;
    float4 g1 = gbuffer1.SampleLevel(_gbuffer1_sampler, texCoord, 0.0f);
    float2 occspec = unpackFloat2(g1.w);
    float3 albedo = surfaceAlbedo(g1.xyz, metallic);
    float3 f0 = surfaceF0(g1.xyz, metallic);
    float depth = (gbufferD.SampleLevel(_gbufferD_sampler, texCoord, 0.0f).x * 2.0f) - 1.0f;
    float3 p = getPos(eye, eyeLook, normalize(viewRay), depth, cameraProj);
    float3 v = normalize(eye - p);
    float dotNV = max(dot(n, v), 0.0f);
    float3 envl = shIrradiance(n);
    envl *= albedo;
    envl += (backgroundCol * surfaceF0(g1.xyz, metallic));
    envl *= (envmapStrength * occspec.x);
    fragColor = float4(envl.x, envl.y, envl.z, fragColor.w);
    float3 _869 = fragColor.xyz * ssaotex.SampleLevel(_ssaotex_sampler, texCoord, 0.0f).x;
    fragColor = float4(_869.x, _869.y, _869.z, fragColor.w);
    if (g0.w == 1.0f)
    {
        float3 _881 = fragColor.xyz + g1.xyz;
        fragColor = float4(_881.x, _881.y, _881.z, fragColor.w);
        albedo = 0.0f.xxx;
    }
    float2 param_2 = cameraProj;
    float viewz = linearize((depth * 0.5f) + 0.5f, param_2);
    float2 param_3 = texCoord;
    float param_4 = viewz;
    float2 param_5 = cameraPlane;
    int clusterI = getClusterI(param_3, param_4, param_5);
    int numLights = int(clustersData.Load(int3(int2(clusterI, 0), 0)).x * 255.0f);
    viewz += (clustersData.SampleLevel(_clustersData_sampler, 0.0f.xx, 0.0f).x * 9.999999717180685365747194737196e-10f);
    for (int i = 0; i < min(numLights, 4); i++)
    {
        int li = int(clustersData.Load(int3(int2(clusterI, i + 1), 0)).x * 255.0f);
        int param_6 = li;
        float param_7 = lightsArray[li * 2].w;
        float3 _975 = fragColor.xyz + sampleLight(p, n, v, dotNV, (lightsArray[li * 2]).xyz, (lightsArray[(li * 2) + 1]).xyz, albedo, roughness, occspec.y, f0, param_6, param_7);
        fragColor = float4(_975.x, _975.y, _975.z, fragColor.w);
    }
    fragColor.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texCoord = stage_input.texCoord;
    viewRay = stage_input.viewRay;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
