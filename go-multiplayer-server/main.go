package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"net"
	"time"
)

const (
	CONNECT = iota
	DATA
	DISCONNECT
)

const (
	ACTION_MOVE = iota
)

type Client struct {
	ID       uint16
	Name     string
	Address  *net.UDPAddr
	LastSeen time.Time
	X        uint16
	Y        uint16
}

var clients = make(map[string]*Client)
var clientCounter uint16 = 0 // Unique client ID counter

func main() {
	// Start UDP server
	Server()
}

// Function to start the UDP server
func Server() {
	address, err := net.ResolveUDPAddr("udp", ":12345")
	if err != nil {
		fmt.Println("Error resolving UDP address:", err)
		return
	}

	conn, err := net.ListenUDP("udp", address)
	if err != nil {
		fmt.Println("Error starting UDP server:", err)
		return
	}
	defer conn.Close()

	fmt.Println("UDP server started on port 12345...")

	buffer := make([]byte, 1024)

	for {
		n, addr, err := conn.ReadFromUDP(buffer)
		if err != nil {
			fmt.Println("Error reading from UDP connection:", err)
			continue
		}

		packetType := int(buffer[0]) // First byte is the packet type
		handlePacket(packetType, addr, conn, buffer[:n])
	}
}

// Handle incoming packets
func handlePacket(packetType int, addr *net.UDPAddr, conn *net.UDPConn, data []byte) {
	switch packetType {
	case CONNECT:
		handleConnect(addr, conn, data[1:])
	case DATA:
		handleDataPacket(addr, conn, data[1:])
	case DISCONNECT:
		handleDisconnect(addr, conn) // Handle client disconnection
	default:
		fmt.Println("Unknown packet type received")
	}
}

func handleConnect(addr *net.UDPAddr, conn *net.UDPConn, data []byte) {
	// Read the player's name from the packet (after the packet type)
	nameLength := binary.LittleEndian.Uint16(data) // First, read the length of the name
	clientName := string(data[2 : 2+nameLength])   // Then read the name itself

	// Check if the client already exists
	clientKey := addr.String()
	if _, exists := clients[clientKey]; exists {
		fmt.Printf("Client %s is already connected\n", clientName)
		return
	}

	// Assign a new unique ID to the client
	clientCounter++
	clientID := clientCounter

	newClient := &Client{
		ID:       clientID,
		Name:     clientName,
		Address:  addr,
		LastSeen: time.Now(),
	}

	clients[clientKey] = newClient
	fmt.Printf("New client connected: ID=%d, Name=%s, Address=%s\n", clientID, clientName, addr.String())

	// Send the list of all connected clients to the new player
	sendClientList(conn, addr, clientID)

	// Notify all existing clients about the new player
	broadcastNewClient(conn, newClient)
}

// Handle client disconnection
func handleDisconnect(addr *net.UDPAddr, conn *net.UDPConn) {
	clientKey := addr.String()

	// Check if the client exists
	if client, exists := clients[clientKey]; exists {
		// Remove the client from the server's client list
		delete(clients, clientKey)
		fmt.Printf("Client %s disconnected, ID: %d\n", client.Name, client.ID)

		// Broadcast the disconnection to all other clients
		broadcastClientDisconnection(conn, client.ID)
	}
}

// Broadcast disconnection to all connected clients
func broadcastClientDisconnection(conn *net.UDPConn, clientID uint16) {
	var buffer bytes.Buffer
	buffer.WriteByte(DISCONNECT) // Packet type: DISCONNECT

	// Write the ID of the client that disconnected
	binary.Write(&buffer, binary.LittleEndian, clientID)

	// Broadcast the disconnection to all clients
	for _, client := range clients {
		_, err := conn.WriteToUDP(buffer.Bytes(), client.Address)
		if err != nil {
			fmt.Println("Error broadcasting client disconnection:", err)
		}
	}
}

// Send the current client list to the newly connected player
func sendClientList(conn *net.UDPConn, addr *net.UDPAddr, newClientID uint16) {
	var buffer bytes.Buffer
	buffer.WriteByte(CONNECT)

	// First, send the new client's own ID so it knows its own identity
	binary.Write(&buffer, binary.LittleEndian, newClientID)

	// Write the number of connected players
	binary.Write(&buffer, binary.LittleEndian, uint16(len(clients)))

	// Send the list of all connected clients (including the new client)
	for _, client := range clients {
		// Write client ID
		binary.Write(&buffer, binary.LittleEndian, client.ID)
		// Write name length
		nameBytes := []byte(client.Name)
		nameLength := uint16(len(nameBytes))
		binary.Write(&buffer, binary.LittleEndian, nameLength)
		// Write the actual name
		buffer.Write(nameBytes)
	}

	// Send the buffer to the new player
	_, err := conn.WriteToUDP(buffer.Bytes(), addr)
	if err != nil {
		fmt.Println("Error sending client list:", err)
	}
}

// Broadcast new client information to all existing players
func broadcastNewClient(conn *net.UDPConn, newClient *Client) {
	var buffer bytes.Buffer
	buffer.WriteByte(CONNECT) // Packet type

	// Include the new client's ID at the start, just like in sendClientList
	binary.Write(&buffer, binary.LittleEndian, newClient.ID)

	// Write number of clients (in this case, only 1 because it's the new player being broadcasted)
	binary.Write(&buffer, binary.LittleEndian, uint16(1))

	// Write the new client's ID
	binary.Write(&buffer, binary.LittleEndian, newClient.ID)

	// Write the name length
	nameBytes := []byte(newClient.Name)
	nameLength := uint16(len(nameBytes))
	binary.Write(&buffer, binary.LittleEndian, nameLength)

	// Write the actual name
	buffer.Write(nameBytes)

	// Broadcast this to all other clients
	for _, client := range clients {
		if client.ID != newClient.ID { // Don't send it to the newly connected client
			_, err := conn.WriteToUDP(buffer.Bytes(), client.Address)
			if err != nil {
				fmt.Println("Error sending new client info:", err)
			}
		}
	}
}
