shader_type canvas_item;

uniform sampler2D r_noise : repeat_enable;
uniform sampler2D g_noise : repeat_enable;
uniform sampler2D b_noise : repeat_enable;
uniform float speed = 0.02;

void fragment() {
	vec4 color = COLOR;
	color.r *= texture(r_noise, (UV / 2.0) + TIME * speed).r + sin(TIME);
	color.g *= texture(g_noise, (UV / 1.5) + TIME * speed).r + sin(TIME + 5.0);
	color.b *= texture(b_noise, (UV / 3.0) + TIME * speed).r + sin(TIME + 15.0);
	COLOR = color;
}
