import React, { useState, useEffect, useRef } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useGame } from '../contexts/GameContext'
import Card from '../components/Card'
import Button from '../components/Button'

const GamePage = () => {
  const { gameCode } = useParams()
  const navigate = useNavigate()
  const { game, playerName, setPlayerReady, vote, resetGame, votesCount } = useGame()
  const [showReadyButton, setShowReadyButton] = useState(false)
  const [hasVoted, setHasVoted] = useState(false)
  const [playerReady, setPlayerReadyState] = useState(false)
  const [imageLoaded, setImageLoaded] = useState(false)
  const [showPersonName, setShowPersonName] = useState(true)

  const gameStartedRef = useRef(false)

  useEffect(() => {
    // Only redirect if we definitely don't have game data after waiting
    if (!game && !playerName) {
      const timer = setTimeout(() => {
        if (!game && !playerName) {
          navigate('/')
        }
      }, 2000)
      return () => clearTimeout(timer)
    }

    if (game && !game.started) {
      navigate(`/lobby/${gameCode}`)
      return
    }

    // Only reset states when the game FIRST starts, not on every game update
    if (game && game.started && !gameStartedRef.current) {
      gameStartedRef.current = true
      
      // Reset all local states when game starts
      setHasVoted(false)
      setPlayerReadyState(false)
      setImageLoaded(false)
      setShowPersonName(true)
      setShowReadyButton(false)
      
      const readyButtonTimer = setTimeout(() => {
        setShowReadyButton(true)
      }, 10000) // Show ready button after 10 seconds

      // Hide person name after 10 seconds
      const nameTimer = setTimeout(() => {
        setShowPersonName(false)
      }, 10000) // Hide name after 10 seconds

      return () => {
        clearTimeout(readyButtonTimer)
        clearTimeout(nameTimer)
      }
    }
  }, [game, playerName, gameCode, navigate])

  // Reset the ref when game ends
  useEffect(() => {
    if (game && game.gameEnded) {
      gameStartedRef.current = false
    }
  }, [game?.gameEnded])

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

  const playerIndex = game.players.findIndex(p => p.name === playerName)
  const isOddPlayer = playerIndex === game.oddPlayerIndex
  const playerImage = isOddPlayer ? game.oddImage : game.sameImage
  const playerCelebrity = isOddPlayer ? game.oddName : game.sameName

  const handleReady = () => {
    setPlayerReady()
    setPlayerReadyState(true)
    setShowReadyButton(false)
  }

  const handleVote = (voteePlayer) => {
    vote(voteePlayer)
    setHasVoted(true)
  }

  const handleNewGame = () => {
    // Instead of going home, navigate to lobby to start a new game with same players
    navigate(`/lobby/${gameCode}`)
    // Reset the game state
    resetGame()
  }

  const handleGoHome = () => {
    resetGame()
    navigate('/')
  }

  if (game.gameEnded) {
    const isWinner = game.winner === playerName
    const actualOddPlayer = game.players[game.oddPlayerIndex]
    const wasOddPlayerCorrectlyVoted = actualOddPlayer && actualOddPlayer.name === game.winner
    
    // Determine if this player is on the losing side
    const isPlayerOnLosingSide = !wasOddPlayerCorrectlyVoted
    
    // Determine result color: green if correct guess, red if wrong
    const resultColor = wasOddPlayerCorrectlyVoted ? 'success' : 'destructive'
    const bgColor = isPlayerOnLosingSide ? 'bg-red-500' : 'bg-green-50'
    
    return (
      <div className={`min-h-screen p-4 flex items-center justify-center ${bgColor}`}>
        <div className="max-w-md w-full space-y-6">
          <Card className={`text-center ${isPlayerOnLosingSide ? 'bg-white/90 backdrop-blur-sm' : ''}`}>
            <div className={`w-20 h-20 mx-auto mb-4 rounded-full flex items-center justify-center bg-${resultColor}`}>
              <svg className="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 20 20">
                {wasOddPlayerCorrectlyVoted ? (
                  <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                ) : (
                  <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                )}
              </svg>
            </div>
            
            <h2 className={`text-2xl font-bold mb-4 ${wasOddPlayerCorrectlyVoted ? 'text-green-700' : 'text-red-700'}`}>
              {wasOddPlayerCorrectlyVoted ? 'Correct Guess!' : 'Wrong Guess!'}
            </h2>
            
            <div className="space-y-3 mb-6">
              <div className="p-3 bg-blue-50 rounded-lg">
                <p className="text-sm text-blue-600 font-medium">Most Voted Player:</p>
                <p className="text-lg font-bold text-blue-800">{game.winner}</p>
              </div>
              
              <div className="p-3 bg-yellow-50 rounded-lg">
                <p className="text-sm text-yellow-600 font-medium">Actual Odd One Out:</p>
                <p className="text-lg font-bold text-yellow-800">
                  {actualOddPlayer ? actualOddPlayer.name : 'Unknown'}
                </p>
                <p className="text-sm text-yellow-600 mt-1">
                  Had image: {game.oddName}
                </p>
              </div>
              
              <div className="p-3 bg-gray-50 rounded-lg">
                <p className="text-sm text-gray-600 font-medium">Everyone Else Had:</p>
                <p className="text-lg font-bold text-gray-800">{game.sameName}</p>
              </div>
            </div>
            
            {isWinner && (
              <div className={`p-3 rounded-lg mb-4 ${isOddPlayer ? 'bg-purple-50' : 'bg-orange-50'}`}>
                <p className={`text-sm font-medium ${isOddPlayer ? 'text-purple-600' : 'text-orange-600'}`}>
                  {isOddPlayer ? 'You were the odd one out and got caught!' : 'You got the most votes but weren\'t the odd one out!'}
                </p>
              </div>
            )}
          </Card>
          
          <Button variant="primary" size="large" onClick={handleNewGame}>
            New Game
          </Button>
        </div>
      </div>
    )
  }

  if (game.votingStarted) {
    if (hasVoted) {
      return (
        <div className="min-h-screen p-4 flex items-center justify-center">
          <Card className="text-center max-w-md">
            <div className="w-16 h-16 bg-primary bg-opacity-10 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-8 h-8 text-primary" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
              </svg>
            </div>
            <h2 className="text-xl font-bold text-textPrimary mb-2">Vote Cast!</h2>
            <p className="text-textSecondary">Waiting for other players to vote...</p>
          </Card>
        </div>
      )
    }

    return (
      <div className="min-h-screen p-4">
        <div className="max-w-2xl mx-auto space-y-6">
          <button
            onClick={handleGoHome}
            className="absolute top-4 left-4 p-2 text-textSecondary hover:text-textPrimary"
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
            </svg>
          </button>

          <Card className="text-center">
            <div className="w-12 h-12 bg-warning bg-opacity-10 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-6 h-6 text-warning" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
                <path fillRule="evenodd" d="M4 5a2 2 0 012-2v1a1 1 0 002 0V3a2 2 0 012 0v1a1 1 0 002 0V3a2 2 0 012 2v6h-2V8a1 1 0 10-2 0v3H6V8a1 1 0 10-2 0v3H2V5z" clipRule="evenodd" />
              </svg>
            </div>
            <h2 className="text-xl font-bold text-textPrimary mb-2">Vote for a Player</h2>
            <p className="text-textSecondary">Who do you think has the different image?</p>
            <div className="mt-3">
              <div className="flex items-center justify-between text-sm text-textSecondary mb-2">
                <span>{votesCount || 0} of {game.players.length} players have voted</span>
                <span>{Math.round(((votesCount || 0) / game.players.length) * 100)}%</span>
              </div>
              {/* Progress bar */}
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div 
                  className="bg-primary h-2 rounded-full transition-all duration-300" 
                  style={{ width: `${((votesCount || 0) / game.players.length) * 100}%` }}
                ></div>
              </div>
            </div>
          </Card>

          <div className="space-y-3">
            {game.players.map((player, index) => {
              const isCurrentPlayer = player.name === playerName
              
              // Don't render button for current player at all
              if (isCurrentPlayer) {
                return null
              }
              
              return (
                <div 
                  key={index}
                  className="transform transition-all duration-200 hover:scale-[1.02] hover:shadow-lg"
                >
                  <Button
                    variant="primary"
                    size="large"
                    onClick={() => handleVote(player.name)}
                  >
                    {player.name}
                  </Button>
                </div>
              )
            })}
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 p-4 relative overflow-hidden">
      {/* Cinematic background effects */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-purple-500/10 rounded-full blur-3xl animate-pulse"></div>
        <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-blue-500/10 rounded-full blur-3xl animate-pulse delay-1000"></div>
        <div className="absolute inset-0 bg-gradient-to-b from-transparent via-purple-900/5 to-transparent"></div>
      </div>

      <div className="max-w-4xl mx-auto space-y-8 relative z-10">
        <button
          onClick={handleGoHome}
          className="absolute top-0 left-0 p-3 bg-black/20 backdrop-blur-sm rounded-2xl border border-white/10 text-white/60 hover:text-white hover:bg-black/30 transition-all duration-200"
        >
          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
          </svg>
        </button>

        {/* Main Game Content */}
        <div className="text-center">
          <div className="relative max-w-md mx-auto min-h-[500px] flex flex-col justify-center">
            
            {/* Celebrity Display - Only show during study phase */}
            {showPersonName ? (
              <div className="transition-all duration-700">
                {/* Cinematic frame for the celebrity image */}
                <div className="relative overflow-hidden">
                  <div className="relative">
                    {/* Spotlight effect */}
                    <div className="absolute inset-0 bg-gradient-radial from-transparent via-transparent to-black/60 z-10 pointer-events-none"></div>
                    
                    {/* Image container with cinematic styling */}
                    <div className={`relative w-full aspect-[3/4] rounded-3xl overflow-hidden shadow-2xl border-4 ${
                      isOddPlayer 
                        ? 'border-red-400 shadow-red-500/50' 
                        : 'border-emerald-400 shadow-emerald-500/50'
                    }`}>
                      <img 
                        src={playerImage} 
                        alt={playerCelebrity}
                        className={`w-full h-full object-cover transition-all duration-700 ${
                          imageLoaded ? 'opacity-100 scale-100' : 'opacity-0 scale-110'
                        }`}
                        onLoad={() => setImageLoaded(true)}
                        onError={(e) => {
                          console.log('Image failed to load:', playerImage);
                          e.target.src = 'https://picsum.photos/300/400?random=' + Math.random();
                          setImageLoaded(true);
                        }}
                      />
                      
                      {/* Loading state */}
                      {!imageLoaded && (
                        <div className="absolute inset-0 bg-gradient-to-br from-slate-800 to-slate-900 flex items-center justify-center">
                          <div className="text-center">
                            <div className="w-12 h-12 border-4 border-white/20 border-t-white rounded-full animate-spin mx-auto mb-4"></div>
                            <span className="text-white/60 font-medium">Loading celebrity...</span>
                          </div>
                        </div>
                      )}
                      
                      {/* Film grain overlay */}
                      <div className="absolute inset-0 opacity-20 mix-blend-overlay bg-repeat bg-[length:200px_200px] pointer-events-none" 
                           style={{backgroundImage: "url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDIwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxjaXJjbGUgY3g9IjUwIiBjeT0iNTAiIHI9IjEiIGZpbGw9ImJsYWNrIiBvcGFjaXR5PSIwLjMiLz4KPGNpcmNsZSBjeD0iMTUwIiBjeT0iNzUiIHI9IjEiIGZpbGw9ImJsYWNrIiBvcGFjaXR5PSIwLjIiLz4KPGNpcmNsZSBjeD0iNzUiIGN5PSIxMjUiIHI9IjEiIGZpbGw9ImJsYWNrIiBvcGFjaXR5PSIwLjE1Ii8+CjxjaXJjbGUgY3g9IjEyNSIgY3k9IjE1MCIgcj0iMSIgZmlsbD0iYmxhY2siIG9wYWNpdHk9IjAuMjUiLz4KPC9zdmc+')"}}></div>
                    </div>
                    
                    {/* Glowing border effect */}
                    <div className={`absolute inset-0 rounded-3xl border-2 ${
                      isOddPlayer 
                        ? 'border-red-400/50 shadow-[0_0_30px_rgba(239,68,68,0.3)]' 
                        : 'border-emerald-400/50 shadow-[0_0_30px_rgba(52,211,153,0.3)]'
                    } animate-pulse`}></div>
                  </div>
                </div>
                
                {/* Celebrity name display */}
                <div className="mt-6">
                  <div className={`inline-flex items-center space-x-3 px-6 py-4 rounded-2xl backdrop-blur-md border shadow-lg ${
                    isOddPlayer 
                      ? 'bg-red-500/10 border-red-400/30 text-red-100' 
                      : 'bg-emerald-500/10 border-emerald-400/30 text-emerald-100'
                  }`}>
                    <div className={`w-3 h-3 rounded-full ${
                      isOddPlayer ? 'bg-red-400' : 'bg-emerald-400'
                    } animate-pulse`}></div>
                    <span className="text-sm font-semibold uppercase tracking-wider opacity-75">Your Celebrity</span>
                  </div>
                  
                  <h2 className="text-3xl font-black text-white mt-3 mb-2 tracking-tight">
                    {playerCelebrity || 'Loading...'}
                  </h2>
                  
                  <div className={`inline-flex items-center px-4 py-2 rounded-xl text-sm font-bold ${
                    isOddPlayer 
                      ? 'bg-red-500/20 text-red-300 border border-red-400/30' 
                      : 'bg-emerald-500/20 text-emerald-300 border border-emerald-400/30'
                  }`}>
                    {isOddPlayer ? (
                      <>
                        <svg className="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                        </svg>
                        You have the different celebrity
                      </>
                    ) : (
                      <>
                        <svg className="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                        </svg>
                        You're in the main group
                      </>
                    )}
                  </div>
                </div>
                
                {/* Countdown timer */}
                <div className="mt-4">
                  <div className="w-32 h-1 bg-white/20 rounded-full mx-auto overflow-hidden">
                    <div className="h-full bg-gradient-to-r from-blue-400 to-purple-400 rounded-full animate-[shrink_10s_linear_forwards]"></div>
                  </div>
                  <p className="text-white/60 text-sm mt-2 font-medium">Study carefully...</p>
                </div>
              </div>
            ) : (
              /* Vote Button Section - Shows when image disappears */
              showReadyButton && !playerReady && (
                <div className="flex flex-col items-center justify-center h-full transition-all duration-700 animate-in slide-in-from-bottom-5">
                  <div className="backdrop-blur-md bg-white/10 border border-white/20 rounded-3xl p-8 shadow-2xl">
                    <div className="w-24 h-24 bg-gradient-to-br from-blue-500 via-purple-500 to-pink-500 rounded-full flex items-center justify-center mx-auto mb-6 shadow-2xl animate-pulse">
                      <svg className="w-12 h-12 text-white" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                      </svg>
                    </div>
                    
                    <h2 className="text-4xl font-black text-white mb-4 tracking-tight">Ready to Vote!</h2>
                    <p className="text-white/70 mb-8 text-lg">You've studied the celebrity. Now decide who has the different image.</p>
                    
                    <button 
                      onClick={handleReady}
                      className="w-full py-6 px-12 text-2xl font-bold text-white rounded-2xl bg-gradient-to-r from-green-500 via-emerald-500 to-teal-500 shadow-2xl hover:shadow-3xl transform hover:scale-105 active:scale-95 transition-all duration-200"
                    >
                      <div className="flex items-center justify-center space-x-4">
                        <svg className="w-8 h-8" fill="currentColor" viewBox="0 0 20 20">
                          <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <span>START VOTING ✨</span>
                      </div>
                    </button>
                  </div>
                </div>
              )
            )}
            
            {/* Player Ready State */}
            {playerReady && (
              <div className="flex flex-col items-center justify-center h-full">
                <div className="backdrop-blur-md bg-white/10 border border-white/20 rounded-3xl p-8 shadow-2xl text-center">
                  <div className="w-20 h-20 bg-green-500/20 rounded-full flex items-center justify-center mx-auto mb-6">
                    <svg className="w-10 h-10 text-green-400" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <h2 className="text-2xl font-bold text-white mb-2">You're Ready!</h2>
                  <p className="text-white/60">Waiting for other players to get ready...</p>
                </div>
              </div>
            )}
          </div>
        </div>

      </div>
    </div>
  )
}

export default GamePage