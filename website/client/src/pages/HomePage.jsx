import React, { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useGame } from '../contexts/GameContext'
import { useSocket } from '../contexts/SocketContext'
import { useStats } from '../contexts/StatsContext'
import Card from '../components/Card'
import Button from '../components/Button'
import Input from '../components/Input'

const HomePage = () => {
  const [playerName, setPlayerName] = useState('')
  const [gameCode, setGameCode] = useState('')
  const [showJoinForm, setShowJoinForm] = useState(false)
  const [creating, setCreating] = useState(false)
  const [joining, setJoining] = useState(false)
  const navigate = useNavigate()
  const { game, createGame, joinGame, error, clearError } = useGame()
  const { connected } = useSocket()
  const { stats } = useStats()
  const [showStats, setShowStats] = useState(false)

  // Navigate to lobby when game is created or joined
  useEffect(() => {
    if (game && game.code && !error) {
      // Add small delay to ensure state is properly set
      const timer = setTimeout(() => {
        navigate(`/lobby/${game.code}`)
      }, 100)
      return () => clearTimeout(timer)
    }
  }, [game, navigate, error])

  const handleCreateGame = (e) => {
    e.preventDefault()
    if (!playerName.trim() || !connected || creating) return
    
    clearError()
    setCreating(true)
    createGame(playerName.trim())
  }

  const handleJoinGame = (e) => {
    e.preventDefault()
    if (!playerName.trim() || !gameCode.trim() || !connected || joining) return
    
    clearError()
    setJoining(true)
    joinGame(gameCode.trim().toUpperCase(), playerName.trim())
  }

  // Reset loading states when navigation happens
  useEffect(() => {
    if (game) {
      setCreating(false)
      setJoining(false)
    }
  }, [game])

  // Reset loading states on error
  useEffect(() => {
    if (error) {
      setCreating(false)
      setJoining(false)
    }
  }, [error])

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 flex items-center justify-center p-4 relative overflow-hidden safe-area">
      {/* Animated background elements */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-gradient-to-br from-blue-400/20 to-purple-400/20 rounded-full blur-3xl animate-pulse"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-gradient-to-tr from-indigo-400/20 to-pink-400/20 rounded-full blur-3xl animate-pulse delay-1000"></div>
      </div>
      
      <div className="w-full max-w-sm sm:max-w-lg space-y-6 relative z-10">
        <div className="text-center">
          <div className="w-24 h-24 sm:w-32 sm:h-32 mx-auto mb-6 bg-gradient-to-br from-blue-500 via-purple-500 to-pink-500 rounded-3xl flex items-center justify-center shadow-2xl relative">
            <div className="absolute inset-0 bg-gradient-to-br from-blue-600 via-purple-600 to-pink-600 rounded-3xl blur-sm opacity-50 scale-110"></div>
            <div className="relative">
              <svg className="w-12 h-12 sm:w-16 sm:h-16 text-white" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
          </div>
          <h1 className="text-4xl sm:text-5xl font-black bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-3">
            Out of Sync
          </h1>
          <p className="text-lg sm:text-xl text-gray-600 font-medium px-2">Find the celebrity that stands out from the crowd</p>
          <p className="text-sm text-gray-500 mt-2 px-4">A multiplayer guessing game with real celebrity photos</p>
        </div>

        {error && (
          <div className="backdrop-blur-md bg-red-500/10 border border-red-300/30 rounded-2xl p-4 shadow-lg">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-red-500/20 rounded-full flex items-center justify-center">
                <svg className="w-4 h-4 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                </svg>
              </div>
              <span className="text-red-700 font-medium">{error}</span>
            </div>
          </div>
        )}

        {!connected && (
          <div className="backdrop-blur-md bg-amber-500/10 border border-amber-300/30 rounded-2xl p-4 shadow-lg">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-amber-500/20 rounded-full flex items-center justify-center animate-pulse">
                <svg className="w-4 h-4 text-amber-600" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                </svg>
              </div>
              <span className="text-amber-700 font-medium">Connecting to server...</span>
            </div>
          </div>
        )}

        <div className="backdrop-blur-md bg-white/20 border border-white/30 rounded-3xl p-6 sm:p-8 shadow-2xl">
          <form onSubmit={showJoinForm ? handleJoinGame : handleCreateGame} className="space-y-6">
            <div className="space-y-4">
              <div className="relative">
                <label className="block text-sm font-semibold text-gray-700 mb-2">Your Name</label>
                <input
                  type="text"
                  value={playerName}
                  onChange={(e) => setPlayerName(e.target.value)}
                  placeholder="Enter your display name"
                  required
                  className="w-full px-4 py-4 sm:px-6 text-base sm:text-lg font-medium rounded-2xl border-0 bg-white/40 backdrop-blur-sm shadow-lg placeholder-gray-500 focus:outline-none focus:ring-4 focus:ring-blue-500/30 transition-all duration-200"
                />
              </div>

              {showJoinForm && (
                <div className="relative">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Game Code</label>
                  <input
                    type="text"
                    value={gameCode}
                    onChange={(e) => setGameCode(e.target.value.toUpperCase())}
                    placeholder="Enter 4-character code"
                    maxLength={4}
                    required
                    className="w-full px-4 py-4 sm:px-6 text-xl sm:text-2xl font-bold tracking-widest text-center rounded-2xl border-0 bg-white/40 backdrop-blur-sm shadow-lg placeholder-gray-500 focus:outline-none focus:ring-4 focus:ring-purple-500/30 transition-all duration-200 uppercase"
                  />
                </div>
              )}
            </div>

            <div className="space-y-4">
              <button
                type="submit"
                disabled={!connected || !playerName.trim() || (showJoinForm && !gameCode.trim()) || creating || joining}
                className="w-full py-4 px-6 text-lg sm:text-xl font-bold text-white rounded-2xl bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 shadow-2xl hover:shadow-3xl transform hover:scale-105 active:scale-95 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none min-h-[44px]"
              >
                {showJoinForm ? (
                  joining ? (
                    <div className="flex items-center justify-center space-x-2">
                      <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                      <span>Joining Game...</span>
                    </div>
                  ) : 'Join Game 🎮'
                ) : (
                  creating ? (
                    <div className="flex items-center justify-center space-x-2">
                      <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                      <span>Creating Game...</span>
                    </div>
                  ) : 'Create New Game ✨'
                )}
              </button>

              <button
                type="button"
                onClick={() => setShowJoinForm(!showJoinForm)}
                className="w-full py-3 px-6 text-base sm:text-lg font-semibold text-gray-700 rounded-2xl bg-white/30 backdrop-blur-sm border border-white/40 shadow-lg hover:bg-white/40 hover:scale-105 active:scale-95 transition-all duration-200 min-h-[44px]"
              >
                {showJoinForm ? '← Create New Game Instead' : 'Join Existing Game →'}
              </button>
            </div>
          </form>
        </div>

        {/* Stats & Feature highlights */}
        <div className="grid grid-cols-1 gap-3 sm:gap-4">
          <div className="backdrop-blur-md bg-white/10 border border-white/20 rounded-2xl p-6 shadow-lg">
            <div className="flex items-center space-x-3 mb-3">
              <div className="w-10 h-10 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full flex items-center justify-center shadow-lg">
                <svg className="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h3 className="font-bold text-gray-800">Real-time Multiplayer</h3>
            </div>
            <p className="text-sm text-gray-600">Play with friends instantly - no downloads required</p>
          </div>
          
          <div className="backdrop-blur-md bg-white/10 border border-white/20 rounded-2xl p-6 shadow-lg">
            <div className="flex items-center space-x-3 mb-3">
              <div className="w-10 h-10 bg-gradient-to-br from-purple-400 to-pink-500 rounded-full flex items-center justify-center shadow-lg">
                <svg className="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-8 3 6 2-4 3 6z" />
                </svg>
              </div>
              <h3 className="font-bold text-gray-800">Real Celebrity Photos</h3>
            </div>
            <p className="text-sm text-gray-600">Guess which player has the different celebrity image</p>
          </div>
          
          <div className="backdrop-blur-md bg-white/10 border border-white/20 rounded-2xl p-6 shadow-lg cursor-pointer hover:bg-white/20 transition-all duration-200" onClick={() => setShowStats(!showStats)}>
            <div className="flex items-center space-x-3 mb-3">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-400 to-indigo-500 rounded-full flex items-center justify-center shadow-lg">
                <svg className="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M2 11a1 1 0 011-1h2a1 1 0 011 1v5a1 1 0 01-1 1H3a1 1 0 01-1-1v-5zM8 7a1 1 0 011-1h2a1 1 0 011 1v9a1 1 0 01-1 1H9a1 1 0 01-1-1V7zM14 4a1 1 0 011-1h2a1 1 0 011 1v12a1 1 0 01-1 1h-2a1 1 0 01-1-1V4z" />
                </svg>
              </div>
              <h3 className="font-bold text-gray-800">Your Stats</h3>
            </div>
            <div className="flex justify-between text-sm">
              <span className="text-gray-600">Games: {stats.gamesPlayed}</span>
              <span className="text-gray-600">Win Rate: {stats.winRate}%</span>
            </div>
          </div>
        </div>

        {/* Expandable Stats Panel */}
        {showStats && (
          <div className="backdrop-blur-md bg-white/15 border border-white/30 rounded-3xl p-8 shadow-2xl">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-2xl font-bold text-gray-800">Player Statistics</h3>
              <button 
                onClick={() => setShowStats(false)}
                className="p-2 bg-white/20 hover:bg-white/30 rounded-full transition-colors duration-200"
              >
                <svg className="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
              <div className="bg-white/20 rounded-2xl p-4 text-center">
                <div className="text-2xl font-bold text-gray-800">{stats.gamesPlayed}</div>
                <div className="text-sm text-gray-600">Games Played</div>
              </div>
              <div className="bg-white/20 rounded-2xl p-4 text-center">
                <div className="text-2xl font-bold text-green-600">{stats.winRate}%</div>
                <div className="text-sm text-gray-600">Win Rate</div>
              </div>
              <div className="bg-white/20 rounded-2xl p-4 text-center">
                <div className="text-2xl font-bold text-blue-600">{stats.accuracyRate}%</div>
                <div className="text-sm text-gray-600">Accuracy</div>
              </div>
              <div className="bg-white/20 rounded-2xl p-4 text-center">
                <div className="text-2xl font-bold text-purple-600">{stats.bestWinStreak}</div>
                <div className="text-sm text-gray-600">Best Streak</div>
              </div>
            </div>
            
            {stats.achievements.length > 0 && (
              <div>
                <h4 className="text-lg font-semibold text-gray-800 mb-3">Achievements</h4>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                  {stats.achievements.slice(0, 4).map((achievement) => (
                    <div key={achievement.id} className="flex items-center space-x-3 bg-white/20 rounded-xl p-3">
                      <div className="w-8 h-8 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-full flex items-center justify-center">
                        <svg className="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                          <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                        </svg>
                      </div>
                      <div>
                        <div className="font-semibold text-gray-800 text-sm">{achievement.name}</div>
                        <div className="text-xs text-gray-600">{achievement.description}</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}

export default HomePage