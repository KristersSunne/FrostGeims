// Main step event
if(global.client_id == player_id){
	
    //Crouch toggle
	if (keyboard_check_pressed(vk_control)) {
        isCrouching = !isCrouching; 
    }
	
	//Main inputs
    var _input_left = keyboard_check(ord("A"));
    var _input_right = keyboard_check(ord("D"));
    var _input_up = keyboard_check(ord("W"));
    var _input_down = keyboard_check(ord("S"));

    var _hsp = _input_right - _input_left;
    var _vsp = _input_down - _input_up;
    
	var _targetSpeed;
	
    if (_hsp != 0 && _vsp != 0) {_hsp *= 0.707107; _vsp *= 0.707107;}
	
	//Idk camera goes brrr if crouch
	if (isCrouching){oCamera._follow_Distance = 5} else {oCamera._follow_Distance = 10;}
    
    if (isCrouching) {_targetSpeed = cSpeed;} else {_targetSpeed = wSpeed;}
	
	pSpeed = lerp(pSpeed, _targetSpeed, speedIncrement);

	x += _hsp*pSpeed;
	y += _vsp*pSpeed;
    
    if (_hsp != 0 || _vsp != 0) {
        send_movement_packet();
    }
}


