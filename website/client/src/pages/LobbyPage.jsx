import React, { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useGame } from '../contexts/GameContext'
import Card from '../components/Card'
import Button from '../components/Button'

const LobbyPage = () => {
  const { gameCode } = useParams()
  const navigate = useNavigate()
  const { game, playerName, startGame } = useGame()

  useEffect(() => {
    if (!game || !playerName) {
      navigate('/')
      return
    }

    if (game.started) {
      navigate(`/game/${game.code}`)
    }
  }, [game, playerName, navigate])

  if (!game || !playerName) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-textSecondary">Loading...</p>
        </div>
      </div>
    )
  }

  const isHost = game.players.find(p => p.name === playerName)?.isHost || false
  const canStartGame = isHost && game.players.length >= 2

  const handleStartGame = () => {
    startGame()
  }

  const handleLeaveGame = () => {
    navigate('/')
  }

  return (
    <div className="min-h-screen p-4">
      <div className="max-w-2xl mx-auto space-y-6">
        <div className="text-center">
          <button
            onClick={handleLeaveGame}
            className="absolute top-4 left-4 p-2 text-textSecondary hover:text-textPrimary"
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          <h1 className="text-3xl font-bold text-textPrimary">Game Lobby</h1>
          <p className="text-lg text-textSecondary mt-2">Code: <span className="font-mono font-bold text-primary">{game.code}</span></p>
        </div>

        <Card>
          <div className="flex items-center space-x-4 mb-4">
            <div className="w-12 h-12 bg-gradient-to-br from-primary to-secondary rounded-full flex items-center justify-center">
              <svg className="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3z" />
              </svg>
            </div>
            <div>
              <h2 className="text-xl font-semibold text-textPrimary">Players in Lobby</h2>
              <p className="text-textSecondary">{game.players.length} player{game.players.length !== 1 ? 's' : ''}</p>
            </div>
          </div>

          <div className="space-y-3">
            {game.players.map((player, index) => {
              const isCurrentPlayer = player.name === playerName
              const isHostPlayer = player.isHost

              return (
                <div 
                  key={index}
                  className="flex items-center space-x-3 p-3 bg-background rounded-ios"
                >
                  <div className={`w-10 h-10 rounded-full flex items-center justify-center text-white font-bold ${
                    isCurrentPlayer ? 'bg-primary' : 'bg-gray-400'
                  }`}>
                    {player.name[0].toUpperCase()}
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center space-x-2">
                      <span className={`font-medium ${isCurrentPlayer ? 'font-bold' : ''}`}>
                        {player.name}
                      </span>
                      {isCurrentPlayer && (
                        <span className="px-2 py-1 bg-primary text-white text-xs rounded-full">
                          You
                        </span>
                      )}
                      {isHostPlayer && (
                        <span className="px-2 py-1 bg-warning text-white text-xs rounded-full">
                          Host
                        </span>
                      )}
                    </div>
                  </div>
                </div>
              )
            })}
          </div>
        </Card>

        {isHost && canStartGame && (
          <div className="space-y-3">
            <Button
              variant="primary"
              size="large"
              onClick={handleStartGame}
            >
              Start Game
            </Button>
          </div>
        )}

        {isHost && !canStartGame && (
          <Card className="bg-yellow-50 border border-yellow-200">
            <div className="flex items-center space-x-2">
              <svg className="w-5 h-5 text-warning" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              </svg>
              <span className="text-warning">Need at least 2 players to start</span>
            </div>
          </Card>
        )}

        {!isHost && (
          <Card className="bg-blue-50 border border-blue-200">
            <div className="flex items-center space-x-2">
              <svg className="w-5 h-5 text-primary" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clipRule="evenodd" />
              </svg>
              <span className="text-primary">Waiting for host to start the game...</span>
            </div>
          </Card>
        )}

        <Card>
          <h3 className="font-semibold text-textPrimary mb-2">How to Play</h3>
          <ul className="text-sm text-textSecondary space-y-1">
            <li>• Everyone gets an image except one person gets a different image</li>
            <li>• Study your image carefully when the game starts</li>
            <li>• Vote for who you think has the different image</li>
            <li>• The person with the most votes is the "odd one out"</li>
          </ul>
        </Card>
      </div>
    </div>
  )
}

export default LobbyPage