package main

import (
	"fmt"
	"net"
	"time"
)

// Define constants for packet types
const (
	CONNECT = iota
	DATA
)

// Client data structure
type Client struct {
	Address  *net.UDPAddr
	LastSeen time.Time
}

var clients = make(map[string]*Client)

func main() {
	// Start UDP server
	Server()
}

// Function to start the UDP server
func Server() {
	// Listen to incoming UDP packets on a specific IP and port
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

	// Create a buffer to read incoming packets
	buffer := make([]byte, 1024)

	// Handle incoming packets
	for {
		// Read the UDP packet sent to the server
		n, addr, err := conn.ReadFromUDP(buffer)
		if err != nil {
			fmt.Println("Error reading from UDP connection:", err)
			continue
		}

		// Handle incoming data
		packetType := int(buffer[0]) // First byte is the packet type
		handlePacket(packetType, addr, conn, buffer[:n])
	}
}

// Function to handle different packet types
func handlePacket(packetType int, addr *net.UDPAddr, conn *net.UDPConn, data []byte) {
	switch packetType {
	case CONNECT:
		handleConnect(addr, conn)
	case DATA:
		handleData(addr, data[1:])
	default:
		fmt.Println("Unknown packet type received")
	}
}

// Function to handle a CONNECT packet
func handleConnect(addr *net.UDPAddr, conn *net.UDPConn) {
	fmt.Printf("New connection from: %s\n", addr.String())

	// Register the client if not already
	if _, exists := clients[addr.String()]; !exists {
		clients[addr.String()] = &Client{Address: addr, LastSeen: time.Now()}
	}

	// Respond to the client with an acknowledgment
	response := []byte{CONNECT}
	_, err := conn.WriteToUDP(response, addr)
	if err != nil {
		fmt.Println("Error sending response to client:", err)
	}
}

// Function to handle a DATA packet (custom logic here)
func handleData(addr *net.UDPAddr, data []byte) {
	fmt.Printf("Data received from %s: %s\n", addr.String(), string(data))

	// Update last seen time for this client
	if client, exists := clients[addr.String()]; exists {
		client.LastSeen = time.Now()
	}
}
