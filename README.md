# Zesterer's OpenMW Shaders

Play Morrowind with PBR shaders like it's 2022, not 2002.

## Screenshots

![Early morning in the grasslands east of Vivec](https://i.imgur.com/09AvjA6.png)

*Note that these screenshots have color saturation set relatively high, but this is not hard-coded into the shaders. See
[the configuration section](#configuration) for more information.*

<details>
    <summary>More screenshots</summary>
    <img src="https://i.imgur.com/CGpw7mC.png" alt="Dusk from the cantons of Vivec">
    <img src="https://i.imgur.com/eZNMSha.png" alt="A night with the guars outside Vivec">
    <img src="https://i.imgur.com/01WujVO.png" alt="A mid-afternoon view of Vivec, looking south">
    <img src="https://i.imgur.com/6v5QQf9.png" alt="Vivec's waistworks">
    <img src="https://i.imgur.com/cJ94PHK.png" alt="Midnight in Balmora">
    <img src="https://i.imgur.com/Ypxz3oj.png" alt="Dawn breaks in Balmora">
    <img src="https://i.imgur.com/WeZGIGe.png" alt="Light attenuation in water">
</details>

## Features

- **Efficient**: in my (very unscientific) tests, only a ~12% framerate hit compared to vanilla OpenMW shaders
- **PBR (Physically-Based Rendering) lighting**: surfaces reflect light consistently and realistically
- **Improved sun light colours**: dawn and dusk are red, midday is yellow, night is blue
- **Better ambient illumination**: ambient light is omnidirectional scattered light from the sky, not direct sunlight
- **Brighter point lights**: lights in the scene emit more light, illuminating the world in a more immersive manner
- **Underwater light attenuation**: objects under the water shift towards blue with depth, adding realism
- **Leaves sway in the wind**: unfortunately, Morrowind has no realiable way to mark leaves so detection is imperfect
- **Sub-surface scattering**: thin objects like grass and leaves allow bright direct light to scatter through them
- **Procedural detail for distant land**: terrain in the distance maintains sharp details
- **Wave shader**: Dynamic waves, froth, and backwash on beaches
- **Easy to configure**: if you prefer realism over bright colours, you can [tweak the shaders](#configuration) accordingly!

## Installation

*Ensure that you have the [latest development build](https://openmw.org/downloads/) of OpenMW. If you find that the mod
does not work with the latest development build, please open an issue!*

1. [Download the shader pack](https://github.com/zesterer/openmw-shaders/archive/refs/heads/main.zip).

2. Locate your [`resources/`](https://modding-openmw.com/tips/custom-shaders/#installing) directory.

3. Copy the extracted contents of the shader pack into `resources/` (make sure to back up anything that was in there
before doing this, should something go wrong).

4. Start OpenMW and have fun!

See the [OpenMW Modding Guide](https://modding-openmw.com/tips/custom-shaders/#installing) for more detailed information
about installing custom shader packs.

## Configuration

There are various presets and parameters that can be changed via
[`shaders/config.glsl`](https://github.com/zesterer/openmw-shaders/blob/main/shaders/config.glsl).

## Recommendations

- This mod works well with my [Volumetric Clouds & Mist Mod](https://github.com/zesterer/openmw-volumetric-clouds).
- Use high-resolution textures, normal maps, etc. where possible
- Enable [per-pixel lighting](https://openmw.readthedocs.io/en/stable/reference/modding/settings/shaders.html#force-per-pixel-lighting)
- Disable [light clamping](https://openmw.readthedocs.io/en/stable/reference/modding/settings/shaders.html#clamp-lighting)

## Getting Help & Feedback

Got a question or a suggestion? Feel free to [open a discussion topic](https://github.com/zesterer/openmw-shaders/discussions/new).
