// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function connect_to_server(_client_socket, _server_ip,_port){
	var _buffer = buffer_create(1024,buffer_grow,1);
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, NETWORK.CONNECT);
	
	network_send_udp_raw(_client_socket, _server_ip, _port, _buffer, buffer_tell(_buffer));
	
	buffer_delete(_buffer);
}