lighting = -1;
depth = -300;
_color = make_color_rgb(0,0,10);//

global.bloom = 13;

shader			= shLighting;
u_col			= shader_get_uniform(shader, "col");
s_lights		= shader_get_sampler_index(shader, "lights");
tex_lights		= -1;

blur_surface = -1;
lights_surface = -1;

shader_bloom_lum = shBloom;
u_bloom_threshold = shader_get_uniform(shader_bloom_lum,"bloom_threshold");
u_bloom_range = shader_get_uniform(shader_bloom_lum,"bloom_range");

shader_blur = shBlur;
u_blur_size = shader_get_uniform(shader_blur,"size");

shader_bloom_blend = shBloomBlend;
u_bloom_intensity = shader_get_uniform(shader_bloom_blend,"bloom_intensity");
u_bloom_darken = shader_get_uniform(shader_bloom_blend,"bloom_darken");
u_bloom_saturation = shader_get_uniform(shader_bloom_blend,"bloom_saturation");
u_bloom_texture = shader_get_sampler_index(shader_bloom_blend,"bloom_texture");

bloom_texture = -1;

srf_ping = -1;
srf_pong = -1;

bloom_threshold = 0.0;//1
bloom_range = 0;
blur_steps = global.bloom;
intensity = 4;
darken = 1;
saturation = 1;