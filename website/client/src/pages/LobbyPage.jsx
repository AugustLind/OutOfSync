import React, { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useGame } from '../contexts/GameContext'
import Card from '../components/Card'
import Button from '../components/Button'

const LobbyPage = () => {
  const { gameCode } = useParams()
  const navigate = useNavigate()
  const { game, playerName, startGame, leaveGame } = useGame()

  useEffect(() => {
    // Navigate to game page when game starts
    if (game && game.started) {
      navigate(`/game/${game.code}`)
      return
    }
  }, [game, navigate])

  // Separate effect for handling missing data - only redirect if we're sure there's no data
  useEffect(() => {
    if (!game && !playerName && gameCode) {
      // Only redirect after a shorter wait to improve UX
      const timer = setTimeout(() => {
        if (!game && !playerName) {
          console.log('No game data available, redirecting to home')
          navigate('/')
        }
      }, 2000) // Reduced from 5 seconds to 2 seconds
      
      return () => clearTimeout(timer)
    }
  }, [game, playerName, gameCode, navigate])

  if (!game || !playerName) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background dark:bg-background-dark">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-textSecondary dark:text-textSecondary">Loading...</p>
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
    leaveGame()
    navigate('/')
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-purple-50 to-pink-50 dark:from-gray-900 dark:via-indigo-900 dark:to-purple-900 p-3 sm:p-4 relative overflow-hidden safe-area">
      {/* Animated background */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-gradient-to-br from-indigo-400/20 to-purple-400/20 rounded-full blur-3xl animate-pulse"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-gradient-to-tr from-purple-400/20 to-pink-400/20 rounded-full blur-3xl animate-pulse delay-1000"></div>
      </div>

      <div className="max-w-2xl sm:max-w-4xl mx-auto space-y-6 sm:space-y-8 relative z-10">
        <div className="text-center relative">
          <button
            onClick={handleLeaveGame}
            className="absolute top-0 left-0 p-3 bg-white/20 dark:bg-black/20 backdrop-blur-sm rounded-2xl border border-white/30 dark:border-gray-600/30 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 hover:bg-white/30 dark:hover:bg-black/30 transition-all duration-200 min-w-[44px] min-h-[44px]"
          >
            <svg className="w-5 h-5 sm:w-6 sm:h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          
          <div className="mb-6">
            <h1 className="text-3xl sm:text-4xl font-black bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-4">
              Game Lobby
            </h1>
            
            {/* Enhanced Game Code Display */}
            <div className="inline-flex flex-col sm:flex-row items-center sm:space-x-4 space-y-3 sm:space-y-0 backdrop-blur-md bg-white/20 dark:bg-black/20 border border-white/30 dark:border-gray-600/30 rounded-2xl px-4 sm:px-8 py-4 shadow-xl">
              <div className="flex items-center space-x-2">
                <div className="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
                <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Game Code:</span>
              </div>
              <div className="text-2xl sm:text-3xl font-black tracking-widest text-indigo-600 dark:text-indigo-400 font-mono bg-white/50 dark:bg-gray-800/50 px-4 sm:px-6 py-2 rounded-xl">
                {game.code}
              </div>
              <button 
                onClick={() => navigator.clipboard.writeText(game.code)}
                className="p-3 bg-indigo-500/20 dark:bg-indigo-400/20 hover:bg-indigo-500/30 dark:hover:bg-indigo-400/30 rounded-xl transition-colors duration-200 min-w-[44px] min-h-[44px]"
                title="Copy game code"
              >
                <svg className="w-4 h-4 text-indigo-600 dark:text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                </svg>
              </button>
            </div>
          </div>
        </div>

        {/* Players Section */}
        <div className="backdrop-blur-md bg-white/20 dark:bg-black/20 border border-white/30 dark:border-gray-600/30 rounded-3xl p-4 sm:p-8 shadow-2xl">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6 space-y-4 sm:space-y-0">
            <div className="flex items-center space-x-3 sm:space-x-4">
              <div className="w-12 h-12 sm:w-16 sm:h-16 bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500 rounded-2xl flex items-center justify-center shadow-lg">
                <svg className="w-6 h-6 sm:w-8 sm:h-8 text-white" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3z" />
                </svg>
              </div>
              <div>
                <h2 className="text-xl sm:text-2xl font-bold text-gray-800 dark:text-gray-200">Players in Lobby</h2>
                <p className="text-sm sm:text-base text-gray-600 dark:text-gray-400">{game.players.length} of 8 players joined</p>
              </div>
            </div>
            
            {/* Player Count Indicator */}
            <div className="flex items-center space-x-2">
              <div className="flex space-x-1">
                {Array.from({ length: 8 }).map((_, i) => (
                  <div
                    key={i}
                    className={`w-2 h-2 rounded-full ${
                      i < game.players.length ? 'bg-green-500' : 'bg-gray-300 dark:bg-gray-600'
                    }`}
                  />
                ))}
              </div>
              <span className="text-sm text-gray-500 dark:text-gray-400 ml-2">max 8</span>
            </div>
          </div>

          <div className="grid grid-cols-1 gap-3 sm:gap-4">
            {game.players.map((player, index) => {
              const isCurrentPlayer = player.name === playerName
              const isHostPlayer = player.isHost
              const colors = ['blue', 'green', 'purple', 'pink', 'indigo', 'cyan', 'teal', 'emerald']
              const color = colors[index % colors.length]

              return (
                <div 
                  key={index}
                  className={`relative p-4 rounded-2xl border transition-all duration-300 ${
                    isCurrentPlayer
                      ? 'bg-indigo-100/50 dark:bg-indigo-900/30 border-indigo-300/50 dark:border-indigo-500/50 shadow-lg scale-105'
                      : 'bg-white/30 dark:bg-gray-800/30 border-white/40 dark:border-gray-600/40 hover:bg-white/40 dark:hover:bg-gray-800/40'
                  }`}
                >
                  {/* Player Avatar and Info */}
                  <div className="flex items-center space-x-3">
                    <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${
                      isHostPlayer 
                        ? 'from-amber-400 to-orange-500' 
                        : `from-${color}-400 to-${color}-600`
                    } flex items-center justify-center text-white font-bold text-lg shadow-lg`}>
                      {player.name.charAt(0).toUpperCase()}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center space-x-2 mb-1">
                        <span className={`font-semibold truncate ${isCurrentPlayer ? 'text-indigo-700 dark:text-indigo-300' : 'text-gray-800 dark:text-gray-200'}`}>
                          {player.name}
                        </span>
                        {isCurrentPlayer && (
                          <span className="text-xs bg-indigo-500 dark:bg-indigo-600 text-white px-2 py-1 rounded-full flex-shrink-0">You</span>
                        )}
                      </div>
                      <div className="flex items-center space-x-2">
                        {isHostPlayer && (
                          <span className="text-xs bg-gradient-to-r from-amber-400 to-orange-500 text-white px-2 py-1 rounded-full flex items-center space-x-1">
                            <svg className="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                            </svg>
                            <span>Host</span>
                          </span>
                        )}
                        <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
                        <span className="text-xs text-gray-500 dark:text-gray-400">Online</span>
                      </div>
                    </div>
                  </div>
                </div>
              )
            })}
            
            {/* Empty slots */}
            {Array.from({ length: Math.max(0, 8 - game.players.length) }).slice(0, 3).map((_, index) => (
              <div 
                key={`empty-${index}`}
                className="p-4 rounded-2xl border border-dashed border-gray-300 dark:border-gray-600 bg-gray-50/30 dark:bg-gray-800/30 flex items-center justify-center"
              >
                <div className="text-center">
                  <div className="w-12 h-12 rounded-xl bg-gray-200 dark:bg-gray-700 flex items-center justify-center mb-2">
                    <svg className="w-6 h-6 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                    </svg>
                  </div>
                  <span className="text-sm text-gray-400 dark:text-gray-500">Waiting for player</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Game Controls */}
        <div className="space-y-6">
          {isHost && canStartGame && (
            <div className="text-center">
              <button
                onClick={handleStartGame}
                className="w-full max-w-md mx-auto py-4 px-8 text-xl font-bold text-white rounded-2xl bg-gradient-to-r from-green-500 via-emerald-500 to-teal-500 shadow-2xl hover:shadow-3xl transform hover:scale-105 active:scale-95 transition-all duration-200"
              >
                <div className="flex items-center justify-center space-x-3">
                  <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clipRule="evenodd" />
                  </svg>
                  <span>Start Game ✨</span>
                </div>
              </button>
              <p className="text-sm text-gray-600 dark:text-gray-400 mt-3">All players are ready! Click to begin the celebrity guessing game.</p>
            </div>
          )}

          {isHost && !canStartGame && (
            <div className="backdrop-blur-md bg-amber-500/10 dark:bg-amber-400/20 border border-amber-300/30 dark:border-amber-400/30 rounded-2xl p-6 shadow-lg">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 bg-amber-500/20 dark:bg-amber-400/30 rounded-full flex items-center justify-center">
                  <svg className="w-5 h-5 text-amber-600 dark:text-amber-400" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                  </svg>
                </div>
                <div>
                  <p className="text-amber-700 dark:text-amber-300 font-semibold">Need more players to start</p>
                  <p className="text-amber-600 dark:text-amber-400 text-sm">Invite friends using the game code above</p>
                </div>
              </div>
            </div>
          )}

          {!isHost && (
            <div className="backdrop-blur-md bg-blue-500/10 dark:bg-blue-400/20 border border-blue-300/30 dark:border-blue-400/30 rounded-2xl p-6 shadow-lg">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 bg-blue-500/20 dark:bg-blue-400/30 rounded-full flex items-center justify-center">
                  <div className="w-5 h-5 border-2 border-blue-600/30 dark:border-blue-400/30 border-t-blue-600 dark:border-t-blue-400 rounded-full animate-spin"></div>
                </div>
                <div>
                  <p className="text-blue-700 dark:text-blue-300 font-semibold">Waiting for host</p>
                  <p className="text-blue-600 dark:text-blue-400 text-sm">{game.players.find(p => p.isHost)?.name} will start the game when ready</p>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* How to Play */}
        <div className="backdrop-blur-md bg-white/10 dark:bg-black/10 border border-white/20 dark:border-gray-600/20 rounded-2xl p-6 shadow-lg">
          <div className="flex items-center space-x-3 mb-4">
            <div className="w-10 h-10 bg-gradient-to-br from-cyan-400 to-blue-500 rounded-full flex items-center justify-center">
              <svg className="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z" clipRule="evenodd" />
              </svg>
            </div>
            <h3 className="text-lg font-bold text-gray-800 dark:text-gray-200">How to Play</h3>
          </div>
          <div className="space-y-3">
            <div className="flex items-start space-x-3">
              <div className="w-6 h-6 bg-indigo-500 text-white rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 mt-0.5">1</div>
              <p className="text-sm text-gray-700 dark:text-gray-300">Each player gets a celebrity photo - but one person gets a different celebrity!</p>
            </div>
            <div className="flex items-start space-x-3">
              <div className="w-6 h-6 bg-purple-500 text-white rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 mt-0.5">2</div>
              <p className="text-sm text-gray-700 dark:text-gray-300">Study your image carefully for 10 seconds</p>
            </div>
            <div className="flex items-start space-x-3">
              <div className="w-6 h-6 bg-pink-500 text-white rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 mt-0.5">3</div>
              <p className="text-sm text-gray-700 dark:text-gray-300">Vote for who you think has the different celebrity image</p>
            </div>
            <div className="flex items-start space-x-3">
              <div className="w-6 h-6 bg-green-500 text-white rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 mt-0.5">4</div>
              <p className="text-sm text-gray-700 dark:text-gray-300">The player with the most votes is revealed as the "odd one out"</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default LobbyPage