// Ensure surfaces exist and create them if not
if (!surface_exists(lighting)) {
    lighting = surface_create(RES_W, RES_H);
    tex_lights = surface_get_texture(lighting);
}

if (!surface_exists(blur_surface)) {
    blur_surface = surface_create(RES_W, RES_H);
}

if (!surface_exists(lights_surface)) {
    lights_surface = surface_create(RES_W, RES_H);
}

if (!surface_exists(srf_ping)) {
    srf_ping = surface_create(RES_W, RES_H);
}

if (!surface_exists(srf_pong)) {
    srf_pong = surface_create(RES_W / 4, RES_H / 4);
    bloom_texture = surface_get_texture(srf_pong);
}

// Begin drawing the lighting surface
gpu_set_tex_filter(false);
surface_set_target(lighting);

// Clear the lighting surface to black (base for lights)
draw_clear(c_black);

// Reset shader and blend modes (no shader and normal blend mode)
gpu_set_blendmode(bm_normal);
shader_reset();

// Finish drawing to the lighting surface
surface_reset_target();

// BLOOM PROCESSING STAGE
// ----------------------------------------
// Apply bloom luminance shader to the lighting surface
shader_set(shader_bloom_lum);
shader_set_uniform_f(u_bloom_threshold, bloom_threshold);
shader_set_uniform_f(u_bloom_range, bloom_range);

// Draw the lighting surface to srf_ping with bloom luminance
surface_set_target(srf_ping);
draw_surface(lighting, 0, 0);
surface_reset_target();
shader_reset();

// Apply blur effect based on bloom settings if bloom is enabled
if (global.bloom == 13) {
    gpu_set_tex_filter(true);
}

shader_set(shader_blur);
shader_set_uniform_f(u_blur_size, RES_W, RES_H, blur_steps);

// Scale the image down to 1/4 size for better performance on the blur pass
surface_set_target(srf_pong);
draw_surface_ext(srf_ping, 0, 0, 0.25, 0.25, 0, c_white, 1);
surface_reset_target();
shader_reset();

// BLOOM BLENDING STAGE
// ----------------------------------------
// Blend the bloom effect back into the main scene
shader_set(shader_bloom_blend);
shader_set_uniform_f(u_bloom_intensity, intensity);
shader_set_uniform_f(u_bloom_darken, darken);
shader_set_uniform_f(u_bloom_saturation, saturation);
texture_set_stage(u_bloom_texture, bloom_texture);

surface_set_target(lights_surface);
draw_surface_ext(srf_pong, 0, 0, 4, 4, 0, c_white, 1); // Upscale the blurred texture
surface_reset_target();
shader_reset();

// Reset texture filtering
gpu_set_tex_filter(false);

// DRAW LIGHTS ONTO THE LIGHTING SURFACE
// ----------------------------------------
// Set the target to the lighting surface to apply lights
surface_set_target(lighting);
draw_surface(lights_surface, 0, 0);

// Set blend mode for additive lighting
gpu_set_blendmode(bm_max);

// Draw all light objects (oLight) as circles with a radial gradient
with (oLight) {
    draw_set_alpha(1);
    draw_circle_colour(x - camera_x, y - camera_y, radius, col, c_black, false);
    draw_set_alpha(1);
}

with(oPlayer){
	draw_set_alpha(1);
    draw_circle_colour(x - camera_x, y - camera_y, 200, c_white, c_black, false);
    draw_set_alpha(1);
}

// Reset blend mode and target
gpu_set_blendmode(bm_normal);
surface_reset_target();

// FINAL RENDERING STAGE
// ----------------------------------------
// Apply the main shader to apply the final post-processing effects
shader_set(shader);
shader_set_uniform_f_array(u_col, [color_get_red(_color) / 255, color_get_green(_color) / 255, color_get_blue(_color) / 255]);
texture_set_stage(s_lights, tex_lights);

// Render the final output on the application surface
if surface_exists(application_surface) {
    draw_surface(application_surface, 0, 0);
}

// Reset shader
shader_reset();