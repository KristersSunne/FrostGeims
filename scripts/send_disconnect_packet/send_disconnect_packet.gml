// Simple disconnection packet to notify all other players of a disconnection
function send_disconnect_packet() {
    var _buff = buffer_create(16, buffer_grow, 1);
    buffer_seek(_buff, buffer_seek_start, 0);

    // Packet type: DISCONNECT
    buffer_write(_buff, buffer_u8, NETWORK.DISCONNECT);
    buffer_write(_buff, buffer_u16, global.client_id); // Player ID

    // Send the disconnect packet to the server
    network_send_raw(oNetwork.tcp_client, _buff, buffer_tell(_buff));

    // Clean up the buffer after sending
    buffer_delete(_buff);
}
