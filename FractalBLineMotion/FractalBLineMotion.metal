//
//  FractalBLineMotion.metal
//  FractalBLineMotion
//
//  Created by Astemir Eleev on 7/11/23.
//

#include <metal_stdlib>
using namespace metal;

namespace FractalBLineMotion {
    
    /* The hashing function works by performing a dot product of the input vector with a fixed vector (constants). The sine of this result is then computed, scaled by a large constant, and the fractional part of this value is returned, which provides a pseudo-random number in the range [0, 1).
     */
    inline float hash(float2 _v){
        return fract(sin(dot(_v, float2(89.44, 19.36))) * 753.5453123);
    }
    
    /*
     The function calculates the noise by:

     - Splitting the input coordinates into their integer and fractional parts.
     - Applying a fade curve to the fractional parts.
     - Generating hash values for the cell corners surrounding the point.
     - Interpolating these hash values using the fade curve, resulting in smooth transitions between noise values.
     */
    float noise(float2 x) {
        float2 p = floor(x);
        float2 f = fract(x);
        
        f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
        float n = p.x + p.y * 157.0;

        return mix(
            mix(hash(n + 0.0), hash(n + 1.0), f.x),
            mix(hash(n + 157.0), hash(n + 158.0), f.x),
            f.y
        );
    }

    /*
     The Fractal Brownian motion function:

     - Initializes a result value v to 0.
     - Adds noise values at different frequency scales (octaves), each scaled by the corresponding amplitude from the amp vector.
     - Combines these scaled noise values to produce the final fbm value.
     - By summing up noise values with varying frequencies and amplitudes, fbm creates natural-looking patterns, which are commonly used in rendering terrains, clouds, and other procedural textures.
     */
    float fbm(float2 position, float3 amp) {
        float v = 0.0;
        v += noise(position * amp.x) * 0.250;
        v += noise(position * amp.y) * 1.525;
        v += noise(position * amp.z) * 0.125;
        return v;
    }

    /*
     Generates a visual pattern of animated colored lines using procedural noise and fractional Brownian motion (fbm). The function combines multiple iterations of line drawing, influenced by noise, to create a complex and dynamic final color pattern.
     
     The function operates in two main loops, each iterating a specified number of times to generate and combine multiple sets of colored lines. These lines are influenced by noise and fbm to produce a dynamic and aesthetic pattern.
     */
    float3 draw(
        float2 uv,
        float3 offset,
        float3 colorV,
        float3 colorSets[4],
        float time,
        int iterations,
        float amplitude,
        float2 thicknessRange
    ) {
        float3 finalColor = float3(0.0);
        
        for(int i = 0; i < iterations; i++) {
            float findex = float(i);
            float amp = amplitude + findex;
            
            float period = 2.0 + (findex + M_PI_2_F);
            float thickness = mix(thicknessRange.x, thicknessRange.y, noise(uv * 2.0));
            
            float t = abs(1. / (sin(uv.y + fbm(uv + time * period, offset)) * amp) * thickness);
            finalColor +=  t * colorSets[i];
        }
        
        for(int i = 0; i < iterations; i++) {
            float findex = float(i);
            float amp = amplitude / 2 + (findex * M_PI_F);
            
            float period = M_PI_F + (findex + M_PI_2_F);
            float thickness = mix(0.15, 0.25, noise(uv * (M_PI_F * 3)));
            
            float t = abs(1. / (sin(uv.y + fbm(uv + time * period, offset)) * amp) * thickness);
            finalColor +=  t * colorSets[i] * colorV;
        }
        return finalColor;
    }
    
   
    [[ stitchable ]] half4 main(
        float2 position,
        half4 color,
        float4 bounds,
        float time,
        float spread,
        float iterations_,
        device const float *iChannel,
        int count
    ) {
        float2 uv = (position / bounds.z) * 1. - 2.;
        uv *= 1.0 + 0.25;
        uv.y = 1. - uv.y;
        
        float3 lineColorG = float3(0.3, 0.45, 1.3);
        float3 lineColorB = float3(0.2, 1.5, 0.1);
        
        float3 finalColor = float3(color.rgb);
                
        float3 colorSet[4] = {
            float3(iChannel[0], iChannel[1], iChannel[2]),
            float3(iChannel[3], iChannel[4], iChannel[5]),
            float3(iChannel[6], iChannel[7], iChannel[8]),
            float3(iChannel[9], iChannel[10], iChannel[11])
        };
        
        // Interpolated value between (0.025) and (0.25) based on t, used to modulate the overall intensity of r
        float t = sin(time) * 0.25 + 0.5;
        float amplitude = 50.;
        int iterations = iterations_;
        float2 thicknessRange = float2(0.4, 0.2);
        
        // Generates green channel contribution with different offset and time modulation
        float3 r = draw(
            uv,
            float3(5.0 * spread / 2., 2.5 * spread, 1.0),
            lineColorG,
            colorSet,
            time * 0.03,
            iterations,
            amplitude,
            thicknessRange
        );
        
        // Generates blue channel contribution with a different set of parameters and applies sinusoidal modulation
        float3 b = draw(
            uv,
            float3(0.25 * spread * 2., 1.5 * spread, 0.5),
            lineColorB,
            colorSet,
            time * 0.03,
            iterations,
            amplitude,
            thicknessRange
        );
        
        // Combines the contributions from the red, green, and blue channels
        // The blue channel is additionally modulated by a sine function of time to create varying intensity over time
        finalColor = r + b * sin(t * 0.2);
        return half4(finalColor.r, finalColor.g, finalColor.b, 1.0);
    }
}


