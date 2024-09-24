// Server data
server_ip = "127.0.0.1";
server_port = 12345;

// The client that the player uses
client = network_create_socket(network_socket_udp);

// The map that holds all the instances currently connected to this client
instances = ds_map_create();
global.client_id = -1;

// Specifies the type of packet being sent
enum NETWORK{
	CONNECT,
	DATA,
	DISCONNECT,
}

// Specifies the action of the DATA packet being sent
enum ACTION{
	MOVE,
}

var _player_name = string(irandom(10000));

connect_to_server(client,server_ip,server_port, _player_name);

// COPY THE GAME STRING TO RUN A SEPARATE COPY OF IT
clipboard_set_text( parameter_string( 0 ) + " -game \"" + parameter_string( 2 ) + "\"" );