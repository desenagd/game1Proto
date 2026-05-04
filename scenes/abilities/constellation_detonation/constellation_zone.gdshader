shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 p0;
uniform vec2 p1;
uniform vec2 p2;
uniform vec2 p3;

bool point_in_polygon( vec2 point ){
	vec2 polygon[4] = {p0, p1, p2, p3};
	bool inside = false;
	int j = 3;
	
	for (int i = 0; i < 4; i++) {
        if ((polygon[i].y > point.y) != (polygon[j].y > point.y) &&
            point.x < (polygon[j].x - polygon[i].x) * 
            (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x) {
            inside = !inside;
        }
        j = i;
    }
	return inside;
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 screen_pos = SCREEN_UV * vec2(textureSize(SCREEN_TEXTURE, 0));
	if (!point_in_polygon(screen_pos)) {
        discard;
    }
    COLOR = texture(TEXTURE, UV);
    COLOR.a *= 0.5;;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
