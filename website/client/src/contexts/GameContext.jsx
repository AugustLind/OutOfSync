import React, { createContext, useContext, useReducer, useEffect } from 'react'
import { useSocket } from './SocketContext'

const GameContext = createContext()

export const useGame = () => {
  const context = useContext(GameContext)
  if (!context) {
    throw new Error('useGame must be used within a GameProvider')
  }
  return context
}

const gameReducer = (state, action) => {
  switch (action.type) {
    case 'SET_PLAYER_NAME':
      return { ...state, playerName: action.payload }
    case 'GAME_CREATED':
    case 'GAME_JOINED':
    case 'GAME_UPDATED':
      return { ...state, game: action.payload, error: null }
    case 'GAME_STARTED':
      return { ...state, game: { ...state.game, ...action.payload } }
    case 'PLAYER_JOINED':
      return { 
        ...state, 
        game: { ...state.game, players: action.payload.players }
      }
    case 'PLAYER_LEFT':
      return { 
        ...state, 
        game: { ...state.game, players: action.payload.players }
      }
    case 'PLAYER_READY_UPDATE':
      return {
        ...state,
        game: {
          ...state.game,
          readyPlayers: action.payload.readyPlayers,
          votingStarted: action.payload.votingStarted
        }
      }
    case 'VOTING_STARTED':
      return { ...state, game: { ...state.game, votingStarted: true } }
    case 'VOTE_CAST':
      return { ...state, votesCount: action.payload.votes }
    case 'GAME_ENDED':
      return { 
        ...state, 
        game: { 
          ...state.game, 
          gameEnded: true, 
          winner: action.payload.winner,
          finalVotes: action.payload.votes
        }
      }
    case 'SET_ERROR':
      return { ...state, error: action.payload }
    case 'CLEAR_ERROR':
      return { ...state, error: null }
    case 'RESET_GAME':
      return { 
        ...state, 
        game: null, 
        error: null, 
        votesCount: 0 
      }
    default:
      return state
  }
}

const initialState = {
  playerName: '',
  game: null,
  error: null,
  votesCount: 0
}

export const GameProvider = ({ children }) => {
  const [state, dispatch] = useReducer(gameReducer, initialState)
  const { socket } = useSocket()

  useEffect(() => {
    if (!socket) return

    const handleGameCreated = (data) => {
      dispatch({ type: 'GAME_CREATED', payload: data.game })
    }

    const handleGameJoined = (data) => {
      dispatch({ type: 'GAME_JOINED', payload: data.game })
    }

    const handlePlayerJoined = (data) => {
      dispatch({ type: 'PLAYER_JOINED', payload: data })
    }

    const handlePlayerLeft = (data) => {
      dispatch({ type: 'PLAYER_LEFT', payload: data })
    }

    const handleGameStarted = (data) => {
      dispatch({ type: 'GAME_STARTED', payload: data.game })
    }

    const handlePlayerReadyUpdate = (data) => {
      dispatch({ type: 'PLAYER_READY_UPDATE', payload: data })
    }

    const handleVotingStarted = () => {
      dispatch({ type: 'VOTING_STARTED' })
    }

    const handleVoteCast = (data) => {
      dispatch({ type: 'VOTE_CAST', payload: data })
    }

    const handleGameEnded = (data) => {
      dispatch({ type: 'GAME_ENDED', payload: data })
    }

    const handleError = (data) => {
      dispatch({ type: 'SET_ERROR', payload: data.message })
    }

    socket.on('game-created', handleGameCreated)
    socket.on('game-joined', handleGameJoined)
    socket.on('player-joined', handlePlayerJoined)
    socket.on('player-left', handlePlayerLeft)
    socket.on('game-started', handleGameStarted)
    socket.on('player-ready-update', handlePlayerReadyUpdate)
    socket.on('voting-started', handleVotingStarted)
    socket.on('vote-cast', handleVoteCast)
    socket.on('game-ended', handleGameEnded)
    socket.on('error', handleError)

    return () => {
      socket.off('game-created', handleGameCreated)
      socket.off('game-joined', handleGameJoined)
      socket.off('player-joined', handlePlayerJoined)
      socket.off('player-left', handlePlayerLeft)
      socket.off('game-started', handleGameStarted)
      socket.off('player-ready-update', handlePlayerReadyUpdate)
      socket.off('voting-started', handleVotingStarted)
      socket.off('vote-cast', handleVoteCast)
      socket.off('game-ended', handleGameEnded)
      socket.off('error', handleError)
    }
  }, [socket])

  const createGame = (playerName) => {
    dispatch({ type: 'SET_PLAYER_NAME', payload: playerName })
    socket?.emit('create-game', { playerName })
  }

  const joinGame = (gameCode, playerName) => {
    dispatch({ type: 'SET_PLAYER_NAME', payload: playerName })
    socket?.emit('join-game', { gameCode, playerName })
  }

  const startGame = () => {
    socket?.emit('start-game')
  }

  const setPlayerReady = () => {
    socket?.emit('player-ready')
  }

  const vote = (votee) => {
    socket?.emit('vote', { votee })
  }

  const resetGame = () => {
    dispatch({ type: 'RESET_GAME' })
  }

  const clearError = () => {
    dispatch({ type: 'CLEAR_ERROR' })
  }

  return (
    <GameContext.Provider value={{
      ...state,
      createGame,
      joinGame,
      startGame,
      setPlayerReady,
      vote,
      resetGame,
      clearError
    }}>
      {children}
    </GameContext.Provider>
  )
}