// Main step event
if(global.client_id == player_id){
    // Crouch toggle
    if (keyboard_check_pressed(vk_control)) {
        isCrouching = !isCrouching; 
    }

    // Main inputs
    var _input_left = keyboard_check(ord("A"));
    var _input_right = keyboard_check(ord("D"));
    var _input_up = keyboard_check(ord("W"));
    var _input_down = keyboard_check(ord("S"));

    var _hsp = _input_right - _input_left;
    var _vsp = _input_down - _input_up;

    var _targetSpeed;

    if (_hsp != 0 && _vsp != 0) {
        _hsp *= 0.707107;
        _vsp *= 0.707107;
    }

    // Camera distance based on crouch
    if (isCrouching) {
        oCamera._follow_Distance = 5;
    } else {
        oCamera._follow_Distance = 10;
    }

    // Smooth speed transition between crouching and walking
    if (isCrouching) {
        _targetSpeed = cSpeed;
    } else {
        _targetSpeed = wSpeed;
    }
    
    // Gradually adjust pSpeed
    pSpeed = lerp(pSpeed, _targetSpeed, speedIncrement);
    
    // Horizontal collision handling
    if (place_meeting(x + _hsp * pSpeed, y, oWall)) {
        // Move the player as close as possible to the wall without going inside
        while (!place_meeting(x + sign(_hsp), y, oWall)) {
            x += sign(_hsp); // Move 1 pixel at a time
        }
        _hsp = 0;  // Stop horizontal movement after resolving collision
    } else {
        // No collision, move freely
        x += _hsp * pSpeed;
    }

    // Vertical collision handling
    if (place_meeting(x, y + _vsp * pSpeed, oWall)) {
        // Move the player as close as possible to the wall without going inside
        while (!place_meeting(x, y + sign(_vsp), oWall)) {
            y += sign(_vsp); // Move 1 pixel at a time
        }
        _vsp = 0;  // Stop vertical movement after resolving collision
    } else {
        // No collision, move freely
        y += _vsp * pSpeed;
    }

    // Send movement packet if the player is moving
    if (_hsp != 0 || _vsp != 0) {
        send_movement_packet();
    }
}



