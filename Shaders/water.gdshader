shader_type spatial;
render_mode depth_draw_opaque;

uniform float transparency : hint_range(0.0,1.0) = 1;
uniform vec3 albedo : source_color;
uniform float metallic : hint_range(0.0, 1.0) = 0;
uniform float roughness : hint_range(0.0, 1.0) = 0.2;
uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;
uniform vec2 wave_direction = vec2(2.0, 0.0);
uniform vec2 wave_direction2 = vec2(0.0, 1.0);
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.025;

// Crest variables
uniform float crest_strength : hint_range(0.0, 100.0, 1) = 10;
uniform float crest_threshold : hint_range(0.3, 0.6, 0.001) = 10;

// Boat wake effect
uniform vec3 wake_origin_pos;
uniform float ripple_strength : hint_range(0.01, 100, 0.01) = 0.1;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.


	vec2 time = (TIME * wave_direction) * time_scale;
	vec2 time2 = (TIME * wave_direction2) * time_scale;

	vec3 normal_blend = mix(texture(texture_normal, UV + time).rgb, texture(texture_normal2, UV + time2).rgb, 0.5);

	// Boat wake
	//vec3 world_pos = vec3(VERTEX);  // In world space
	//float dist = distance(world_pos.xz, wake_origin_pos.xz);
	//float rdius = 5.0;  // How far the ripple should reach in world units
	//float falloff = smoothstep(radius, 0.0, dist);  // 1.0 near boat, 0.0 far away
	//float ripple = sin(dist * 10.0 - TIME * 5.0) * falloff;
	//normal_blend.y += ripple * ripple_strength;
	//normal_blend = normalize(normal_blend); // Re-normalize after changing

	// Adding wave crests where normal maps peak
	float crest = clamp((1.0 - normal_blend.y - crest_threshold) * crest_strength, 0.0, 1.0);

	vec3 final_colour = mix(albedo, vec3(1.0), crest);


	ALBEDO = final_colour;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal_blend;
	ALPHA = transparency;

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
