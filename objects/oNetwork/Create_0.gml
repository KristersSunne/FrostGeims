// Server data
server_ip = "127.0.0.1";
server_port = 12345;

// The client that the player uses
client = network_create_socket(network_socket_udp);

// The map that holds all the instances currently connected to this client
instances = ds_map_create();

enum NETWORK{
	CONNECT,
	DATA,
}

connect_to_server(client,server_ip,server_port);