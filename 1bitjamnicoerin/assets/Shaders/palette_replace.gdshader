shader_type canvas_item;

//White
uniform vec4 white_color : source_color;
uniform vec4 white_replace_color : source_color;
uniform float white_color_threshold : hint_range(0.0, 1.0, 0.001);

//Black
uniform vec4 black_color : source_color;
uniform vec4 black_replace_color : source_color;
uniform float black_color_threshold : hint_range(0.0, 1.0, 0.001);


void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex_color = texture(TEXTURE, UV);
	
	float white_distance = length(tex_color.rgba - white_color.rgba);
	float black_distance = length(tex_color.rgba - black_color.rgba);
	
	if(black_distance < white_color_threshold){
		tex_color = white_replace_color;
	}else if(white_distance < black_color_threshold){
		tex_color = black_replace_color;
	}
	
	COLOR = tex_color;
}