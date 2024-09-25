// The function that is responsible for the connection to the server
function connect_to_server(_client_socket, _server_ip,_port){
	if(_client_socket != -1){
		var _result = network_connect_raw_async(_client_socket, _server_ip, _port);
		show_debug_message("Trying to connect to the TCP server");
	} else {
		show_debug_message("Failed to create a TCP socket");
	}
}

// Function to send the UDP handshake after TCP connection
function send_udp_handshake(_client_socket, _server_ip, _port) {
    var _buffer = buffer_create(1024, buffer_grow, 1);
    buffer_seek(_buffer, buffer_seek_start, 0);
    
    // Send the client ID to identify the UDP handshake
	buffer_write(_buffer, buffer_u8, NETWORK.CONNECT);
    buffer_write(_buffer, buffer_u16, global.client_id); // The client ID set during the TCP connection
    
    // Send the handshake packet to the server via UDP
    network_send_udp_raw(_client_socket, _server_ip, _port, _buffer, buffer_tell(_buffer));

    buffer_delete(_buffer);
}