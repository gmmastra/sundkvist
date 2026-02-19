shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec2 resolution = vec2(320.0, 180.0);

uniform float scan_line_amount : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec2 uv = SCREEN_UV;
    
    vec2 delta = uv - 0.5;
    
    float scanline = sin(uv.y * resolution.y * PI) * 0.5 + 0.5;
    scanline = mix(1.0, scanline, scan_line_amount * 0.5); // Réduit l'impact
    
    
    vec3 color = texture(SCREEN_TEXTURE, uv).rgb * scanline;

    COLOR.rgb = color;
    COLOR.a = 1.0;
}