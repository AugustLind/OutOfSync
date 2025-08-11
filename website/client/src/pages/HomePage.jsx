import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useGame } from '../contexts/GameContext'
import { useSocket } from '../contexts/SocketContext'
import Card from '../components/Card'
import Button from '../components/Button'
import Input from '../components/Input'

const HomePage = () => {
  const [playerName, setPlayerName] = useState('')
  const [gameCode, setGameCode] = useState('')
  const [showJoinForm, setShowJoinForm] = useState(false)
  const navigate = useNavigate()
  const { createGame, joinGame, error, clearError } = useGame()
  const { connected } = useSocket()

  const handleCreateGame = (e) => {
    e.preventDefault()
    if (!playerName.trim()) return
    
    clearError()
    createGame(playerName.trim())
    
    setTimeout(() => {
      navigate('/lobby/new')
    }, 100)
  }

  const handleJoinGame = (e) => {
    e.preventDefault()
    if (!playerName.trim() || !gameCode.trim()) return
    
    clearError()
    joinGame(gameCode.trim().toUpperCase(), playerName.trim())
    
    setTimeout(() => {
      navigate(`/lobby/${gameCode.trim().toUpperCase()}`)
    }, 100)
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <div className="w-full max-w-md space-y-8">
        <div className="text-center">
          <div className="w-24 h-24 mx-auto mb-6 bg-gradient-to-br from-primary to-secondary rounded-3xl flex items-center justify-center shadow-lg">
            <svg className="w-12 h-12 text-white" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <h1 className="text-4xl font-bold text-textPrimary mb-2">Out of Sync</h1>
          <p className="text-textSecondary">Find out who stands out from the crowd</p>
        </div>

        {error && (
          <Card className="bg-red-50 border border-red-200">
            <div className="flex items-center space-x-2">
              <svg className="w-5 h-5 text-destructive" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              </svg>
              <span className="text-destructive">{error}</span>
            </div>
          </Card>
        )}

        {!connected && (
          <Card className="bg-yellow-50 border border-yellow-200">
            <div className="flex items-center space-x-2">
              <svg className="w-5 h-5 text-warning" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              </svg>
              <span className="text-warning">Connecting to server...</span>
            </div>
          </Card>
        )}

        <Card>
          <form onSubmit={showJoinForm ? handleJoinGame : handleCreateGame} className="space-y-6">
            <Input
              label="Your name"
              placeholder="Enter your name"
              value={playerName}
              onChange={(e) => setPlayerName(e.target.value)}
              required
            />

            {showJoinForm && (
              <Input
                label="Game code"
                placeholder="Enter 4-character code"
                value={gameCode}
                onChange={(e) => setGameCode(e.target.value.toUpperCase())}
                maxLength={4}
                required
              />
            )}

            <div className="space-y-3">
              <Button
                type="submit"
                variant="primary"
                size="large"
                disabled={!connected || !playerName.trim() || (showJoinForm && !gameCode.trim())}
              >
                {showJoinForm ? 'Join Game' : 'Create New Game'}
              </Button>

              <Button
                type="button"
                variant="secondary"
                size="large"
                onClick={() => setShowJoinForm(!showJoinForm)}
              >
                {showJoinForm ? 'Create New Game Instead' : 'Join Existing Game'}
              </Button>
            </div>
          </form>
        </Card>

        <Card>
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-success bg-opacity-10 rounded-full flex items-center justify-center">
              <svg className="w-5 h-5 text-success" fill="currentColor" viewBox="0 0 20 20">
                <path d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z" />
              </svg>
            </div>
            <div>
              <p className="font-medium text-textPrimary">Real-time multiplayer</p>
              <p className="text-sm text-textSecondary">Play with friends instantly</p>
            </div>
          </div>
        </Card>
      </div>
    </div>
  )
}

export default HomePage