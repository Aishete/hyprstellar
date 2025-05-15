float warp = 0.25; // simulate curvature of CRT monitor
float scan = 0.50; // simulate darkness between scanlines
float curvature = 0.5; // Static curvature control

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // squared distance from center
    vec2 uv = fragCoord / iResolution.xy;
    vec2 dc = abs(0.5 - uv);
    dc *= dc;

    // warp the fragment coordinates (reduced warping)
    uv.x -= 0.5;
    uv.x *= 1.0 + (dc.y * (0.2 * warp * curvature));
    uv.x += 0.5;
    uv.y -= 0.5;
    uv.y *= 1.0 + (dc.x * (0.3 * warp * curvature));
    uv.y += 0.5;

    // sample inside boundaries, otherwise set to black
    if (uv.y > 1.0 || uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0)
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else
    {
        // determine if we are drawing in a scanline
        float apply = abs(sin(fragCoord.y) * 0.5 * scan);

        // sample the texture and adjust color balance
        vec3 color = texture(iChannel0, uv).rgb;

        // Sharper color correction for clarity
        color.r *= 1.4; // Increase red contrast
        color.g *= 1.3; // Increase green contrast
        color.b *= 1.5; // Increase blue contrast

        // Reduce color bleeding
        float bleed = 0.01;
        color.r += color.g * bleed;
        color.b += color.g * bleed;

        // mix the sampled color with black based on scanline intensity
        fragColor = vec4(mix(color, vec3(0.0), apply), 1.0);
    }
}
