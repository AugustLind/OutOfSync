import React, { createContext, useContext, useEffect, useState } from 'react'
import { io } from 'socket.io-client'

const SocketContext = createContext()

export const useSocket = () => {
  const context = useContext(SocketContext)
  if (!context) {
    throw new Error('useSocket must be used within a SocketProvider')
  }
  return context
}

export const SocketProvider = ({ children }) => {
  const [socket, setSocket] = useState(null)
  const [connected, setConnected] = useState(false)

  useEffect(() => {
    const serverUrl = import.meta.env.PROD 
      ? window.location.origin 
      : 'http://localhost:3001'
    
    const newSocket = io(serverUrl, {
      transports: ['websocket', 'polling'],
      timeout: 20000,
      reconnection: true,
      reconnectionDelay: 1000,
      reconnectionAttempts: 5,
      maxReconnectionAttempts: 5
    })
    
    newSocket.on('connect', () => {
      setConnected(true)
      console.log('Connected to server:', newSocket.id)
    })

    newSocket.on('disconnect', (reason) => {
      setConnected(false)
      console.log('Disconnected from server:', reason)
    })

    newSocket.on('connect_error', (error) => {
      console.error('Connection error:', error)
      setConnected(false)
    })

    newSocket.on('reconnect', () => {
      console.log('Reconnected to server')
      setConnected(true)
    })

    setSocket(newSocket)

    return () => {
      newSocket.close()
    }
  }, [])

  return (
    <SocketContext.Provider value={{ socket, connected }}>
      {children}
    </SocketContext.Provider>
  )
}