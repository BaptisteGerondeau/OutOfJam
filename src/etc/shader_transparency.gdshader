shader_type spatial;

render_mode blend_mul, depth_prepass_alpha;

uniform sampler2D mask;

void fragment() {
	if (FRONT_FACING)
	{
		ALPHA = texture(mask, UV).r;
	}
}
