// The function that deals with all the packets in the game
function handle_network_packet(_packet_type, _packet){

	switch(_packet_type){
		case NETWORK.CONNECT:
			show_debug_message("Connection packet has been received");
		break;
	}
}