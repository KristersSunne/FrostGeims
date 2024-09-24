// The function that is responsible for the connection to the server
/* Works as a registering packet for the server due to the UDP never
establishing a real connection but instead just registering the client 
in the go server for data management*/
function connect_to_server(_client_socket, _server_ip,_port, _player_name){
	var _buffer = buffer_create(1024,buffer_grow,1);
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, NETWORK.CONNECT);
	buffer_write(_buffer, buffer_u16, string_length(_player_name));
	buffer_write(_buffer, buffer_string, _player_name);
	
	network_send_udp_raw(_client_socket, _server_ip, _port, _buffer, buffer_tell(_buffer));
	
	buffer_delete(_buffer);
}