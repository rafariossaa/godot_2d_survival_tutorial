shader_type canvas_item;

// Uniform are var that could be set outside the shadder
uniform float lerp_percent : hint_range(0.0, 1.0);

void fragment() {
	// Get the texture (pixel values)
	vec4 texture_color = texture(TEXTURE, UV);
	// Create a new color (white=1.0,1.0,1.0) for the output but keeping the alpha (transparency)
	// Mix (col1, col2, percentage)
	vec4 final_color = mix(texture_color, vec4( 1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	
	// Output
	COLOR = final_color;
}
