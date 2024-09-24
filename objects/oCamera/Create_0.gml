globalvar camera_x, camera_y, camera_w, camera_h;
#macro RES_W 1920
#macro RES_H 1080
#macro CAM_SMOOTH 0.1

obj_follow = self;

view_enabled = true;
view_visible[0] = true;

camera = camera_create_view(obj_follow.x-(RES_W/4),obj_follow.y-(RES_H/4),RES_W,RES_H);

view_set_camera(0, camera);

window_set_size(1280, 720);

var _display_width = display_get_width();
var _display_height = display_get_height();
window_set_position(_display_width/2 - 1280/2, _display_height/2 - 720/2);

surface_resize(application_surface, RES_W, RES_H);

display_set_gui_size(RES_W, RES_H);

shakePower = 5;
shakeValue = 0;

instance_create_depth(x,y,0,oLighting);
