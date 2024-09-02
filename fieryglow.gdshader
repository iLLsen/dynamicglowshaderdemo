shader_type canvas_item; 
render_mode blend_add;

uniform float fireball_scale_y = 1.0;
uniform float glow_scale_y = 1.0;
uniform float glow_strength = 1.0;
uniform float glow_intensity = 0.0; // Default value for glow_intensity
uniform sampler2D noise : repeat_enable, filter_nearest_mipmap_anisotropic;
uniform sampler2D noise2 : repeat_enable, filter_nearest_mipmap_anisotropic;
uniform sampler2D colo_curve; 
uniform int pixel_size : hint_range(1, 100) = 1;

// Parameters for position and size
uniform vec2 glow_position = vec2(0.5, 0.5);
uniform vec2 glow_size = vec2(0.2, 0.2);

// Parameters for pulsating effect
uniform bool pulsate = false;
uniform float pulsation_speed = 1.0;
uniform float glow_intensity_start = 0.75;
uniform float glow_intensity_stop = 1.0;

vec4 f1(vec2 uv, float time){
	vec4 nv2 = texture(noise, uv + vec2(time, 0.0));
	vec4 n2v2 = texture(noise2, uv + vec2(time*.8, 0.0));
	nv2.r = max(0., nv2.r + uv.x - 1.0);
	n2v2.r = max(0., n2v2.r + uv.x - 1.0); 
	return nv2 * n2v2;
}
	
void fragment()
{ 	
	vec2 mUV = (UV - glow_position) / glow_size;
	vec2 uv = (mUV - 0.5) * 2.0 * vec2(1.0, fireball_scale_y); 
	float time = TIME;
    vec2 cuv = mUV - vec2(0.5); 
	float d2c = length(cuv);
	vec4 color = COLOR;
	// 
	color *= (f1(uv, time) + f1(uv + vec2(0.1, 0.0), time + 11.514) + f1(uv + vec2(0.05, 0.0), time + 14.14));
	
	color.r -= 1.0;
	color.r = -pow(color.r, 2.0) + 1.0;
	//
	color.rgb = texture(colo_curve, vec2(color.r, 0.0)).rgb;
	float randmoo = texture(noise2, mUV + vec2(time, -time)).r;
	randmoo = mix(randmoo, 0.0, mUV.x);
    color.r *= smoothstep(0.5, 0.48 - (0.2 - min(mUV.x, 1.0) * 0.2), d2c + randmoo * 0.4);
    COLOR = color;
	COLOR.rgb = mix(COLOR.rgb, vec3(0.0), smoothstep(0.00001, 0.0, color.r));
	// light
	vec2 glowUV = (UV - glow_position) / glow_size;
	float d2c_l = length(glowUV * vec2(1.0, glow_scale_y) - vec2(0.58, 0.5 * glow_scale_y));
	
	// Oscillating glow_intensity if pulsate is true, otherwise use the default glow_intensity
	float glow_intensity_value = pulsate ? mix(glow_intensity_start, glow_intensity_stop, 0.5 + 0.5 * sin(time * pulsation_speed * 3.14159 * 2.0)) : glow_intensity;
	
	float l = -log(d2c_l + glow_intensity_value) * glow_strength;
	float randmoo2 = texture(noise2, vec2(time, -time)).r;
	
	COLOR += texture(colo_curve, vec2(1.0 - d2c_l - 0.1 * randmoo2, 0.0)) * l;
	//COLOR += vec4(0.8, 0.8, 0.6, 1.0) * l;
	//
	color.r *= smoothstep(0.5, 0.1, length(UV - vec2(0.5)));
	
	vec2 pos = UV / TEXTURE_PIXEL_SIZE;
	vec2 square = vec2(float(pixel_size), float(pixel_size));
	vec2 top_left = floor(pos / square) * square;
	vec4 total = vec4(0.0, 0.0, 0.0, 0.0);
	for (int x = int(top_left.x); x < int(top_left.x) + pixel_size; x++){
		for (int y = int(top_left.y); y < int(top_left.y) + pixel_size; y++){
			total += texture(TEXTURE, vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE);
		}
	}
	COLOR -= total / float(pixel_size * pixel_size);
}
