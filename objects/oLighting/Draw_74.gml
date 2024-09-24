if(surface_exists(lighting)){
	//Do nothing
} else {
	lighting = surface_create(RES_W,RES_H);
	tex_lights = surface_get_texture(lighting);
}
if(surface_exists(blur_surface)){
	//Do nothing
} else {
	blur_surface = surface_create(RES_W,RES_H);
}

if(surface_exists(lights_surface)){
	//Do nothing
} else {
	lights_surface = surface_create(RES_W,RES_H);
}

gpu_set_tex_filter(false);
surface_set_target(lighting);

//if(val <1){
draw_clear(c_black);
//}

gpu_set_blendmode(bm_normal);

//with(obj_particle){
//	draw_set_alpha(0.3);
//	draw_surface_stretched(lightsurface,0,0,camera_w,camera_h);
//	draw_set_alpha(1);
//}
gpu_set_blendmode(bm_normal);

shader_reset();


surface_reset_target();


if(!surface_exists(srf_ping)){
	srf_ping = surface_create(RES_W,RES_H);
}

if(!surface_exists(srf_pong)){
	srf_pong = surface_create(RES_W/4,RES_H/4);
		bloom_texture = surface_get_texture(srf_pong);
}

shader_set(shader_bloom_lum);
	shader_set_uniform_f(u_bloom_threshold,bloom_threshold);
	shader_set_uniform_f(u_bloom_range,bloom_range);
	
	surface_set_target(srf_ping);
		draw_surface(lighting,0,0);
	surface_reset_target();
shader_reset();

if(global.bloom = 13){
gpu_set_tex_filter(true);
}
shader_set(shader_blur);
shader_set_uniform_f(u_blur_size,RES_W,RES_H,blur_steps);
surface_set_target(srf_pong);
draw_surface_ext(srf_ping,0,0,0.25,0.25,0,c_white,1);
surface_reset_target();
shader_reset();

shader_set(shader_bloom_blend);
	shader_set_uniform_f(u_bloom_intensity,intensity);
	shader_set_uniform_f(u_bloom_darken,darken);
	shader_set_uniform_f(u_bloom_saturation,saturation);
	texture_set_stage(u_bloom_texture,bloom_texture);
	surface_set_target(lights_surface);
	 draw_surface_ext(srf_pong,0,0,4,4,0,c_white,1);
	surface_reset_target();
shader_reset();

gpu_set_tex_filter(false);
surface_set_target(lighting);

draw_surface(lights_surface,0,0);

gpu_set_blendmode(bm_max);
with(oLight) {
	draw_set_alpha(1);
	draw_circle_colour(x-camera_x,y-camera_y,radius,col,c_black,false);
	draw_set_alpha(1);
}
gpu_set_blendmode(bm_normal);

surface_reset_target();

shader_set(shader);
shader_set_uniform_f_array(u_col, [color_get_red(_color)/255,color_get_green(_color)/255,color_get_blue(_color)/255]);
texture_set_stage(s_lights, tex_lights);
if surface_exists(application_surface)
	draw_surface(application_surface, 0, 0);
shader_reset();
