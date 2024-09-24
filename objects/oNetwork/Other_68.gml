// Networking event that takes in all the packets for the game

switch(async_load[? "type"]){
	case network_type_data:
		
		var _packet = async_load[? "buffer"];
		
		var _packet_type = buffer_read(_packet, buffer_u8);
		
		handle_network_packet(_packet_type, _packet);
	break;
}