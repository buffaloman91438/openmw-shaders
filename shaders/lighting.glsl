#include "lighting_util.glsl"

float getFresnelSpecular(vec3 viewDir, vec3 viewNormal, vec3 lightDir) {
    return (0.0
        + max(dot(viewDir, reflect(lightDir, viewNormal)), 0)
    ) * 1.75;
}

float getFresnelDiffuse(vec3 viewDir, vec3 viewNormal, vec3 lightDir) {
    return (0.0
        + max(dot(-viewDir, viewNormal), 0)
    ) * 1.75;
}

void perLightSun(out vec3 diffuseOut, out vec3 ambientOut, vec3 viewPos, vec3 viewNormal, float roughness, bool isBack)
{
    vec3 lightDir = normalize(lcalcPosition(0));
    viewNormal = normalize(viewNormal);

    float lambert;
    // Leaves
    if (roughness > 0.5) {
        //if (dot(viewPos, viewNormal) > 0) {
        //    viewNormal *= -1;
        //}
        //lambert = (dot(viewNormal.xyz, lightDir) + 1) * 0.5;
        lambert = (dot(normalize(viewPos.xyz), -lightDir) + 1) * 0.5;
    } else {
        lambert = dot(viewNormal.xyz, lightDir);
    }

    float fresnelSpecular = 1;
    float fresnelDiffuse = 1;

#ifndef GROUNDCOVER
    lambert = max(lambert, 0.0);
    fresnelSpecular = getFresnelSpecular(normalize(viewPos), viewNormal, lightDir);
    fresnelDiffuse = getFresnelDiffuse(normalize(viewPos), viewNormal, lightDir);
#else
    float eyeCosine = dot(normalize(viewPos), viewNormal.xyz);
    if (lambert < 0.0)
    {
        lambert = -lambert;
        eyeCosine = -eyeCosine;
    }
    lambert *= clamp(-8.0 * (1.0 - 0.3) * eyeCosine + 1.0, 0.3, 1.0);
#endif

    const vec3 diffuse_tone = vec3(2.2, 2.0, 1.6);
    const vec3 ambient_tone = vec3(0.4, 0.6, 0.8);

    diffuseOut = lcalcDiffuse(0).xyz * diffuse_tone * lambert * mix(fresnelSpecular, 1, max(0.65, roughness));
    ambientOut = gl_LightModel.ambient.xyz * ambient_tone * mix(fresnelDiffuse, 1, max(0.0, roughness));
}

void perLightPoint(out vec3 ambientOut, out vec3 diffuseOut, int lightIndex, vec3 viewPos, vec3 viewNormal, float roughness)
{
    vec3 lightPos = lcalcPosition(lightIndex) - viewPos;
    float lightDistance = length(lightPos);

// cull non-FFP point lighting by radius, light is guaranteed to not fall outside this bound with our cutoff
#if !@lightingMethodFFP
    float radius = lcalcRadius(lightIndex);

    if (lightDistance > radius * 2.0)
    {
        ambientOut = vec3(0.0);
        diffuseOut = vec3(0.0);
        return;
    }
#endif

    lightPos = normalize(lightPos);

    float illumination = lcalcIllumination(lightIndex, lightDistance);
    ambientOut = lcalcAmbient(lightIndex) * illumination;
    float lambert = dot(viewNormal.xyz, lightPos) * illumination;
    float fresnelSpecular = 1;
    float fresnelDiffuse = 1;

#ifndef GROUNDCOVER
    lambert = max(lambert, 0.0);
    fresnelSpecular = getFresnelSpecular(normalize(viewPos), viewNormal, lightPos);
#else
    float eyeCosine = dot(normalize(viewPos), viewNormal.xyz);
    if (lambert < 0.0)
    {
        lambert = -lambert;
        eyeCosine = -eyeCosine;
    }
    lambert *= clamp(-8.0 * (1.0 - 0.3) * eyeCosine + 1.0, 0.3, 1.0);
#endif

    diffuseOut = lcalcDiffuse(lightIndex) * lambert * mix(fresnelSpecular, 1, max(0.5, roughness));
}

#if PER_PIXEL_LIGHTING
void doLighting(vec3 viewPos, vec3 viewNormal, float shadowing, out vec3 diffuseLight, out vec3 ambientLight, float roughness, bool isBack)
#else
void doLighting(vec3 viewPos, vec3 viewNormal, out vec3 diffuseLight, out vec3 ambientLight, out vec3 shadowDiffuse)
#endif
{
    vec3 ambientOut, diffuseOut;

#if !PER_PIXEL_LIGHTING
    float roughness = 1;
    bool isBack = false;
#endif

    perLightSun(diffuseOut, ambientOut, viewPos, viewNormal, roughness, isBack);

#if PER_PIXEL_LIGHTING
    diffuseLight = diffuseOut * shadowing;
    ambientLight = ambientOut;
#else
    shadowDiffuse = diffuseOut;
    diffuseLight = vec3(0.0);
#endif

    for (int i = @startLight; i < @endLight; ++i)
    {
#if @lightingMethodUBO
        perLightPoint(ambientOut, diffuseOut, PointLightIndex[i], viewPos, viewNormal, roughness);
#else
        perLightPoint(ambientOut, diffuseOut, i, viewPos, viewNormal, roughness);
#endif
        ambientLight += ambientOut;
        diffuseLight += diffuseOut;
    }
}

vec3 getSpecular(vec3 viewNormal, vec3 viewDirection, float shininess, vec3 matSpec)
{
    vec3 lightDir = normalize(lcalcPosition(0));
    float NdotL = dot(viewNormal, lightDir);
    if (NdotL <= 0.0)
        return vec3(0.0);
    vec3 halfVec = normalize(lightDir - viewDirection);
    float NdotH = dot(viewNormal, halfVec);
    return pow(max(NdotH, 0.0), max(1e-4, shininess)) * lcalcSpecular(0).xyz * matSpec;
}
