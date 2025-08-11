import React, { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useGame } from '../contexts/GameContext'
import Card from '../components/Card'
import Button from '../components/Button'

const GamePage = () => {
  const { gameCode } = useParams()
  const navigate = useNavigate()
  const { game, playerName, setPlayerReady, vote, resetGame } = useGame()
  const [showReadyButton, setShowReadyButton] = useState(false)
  const [hasVoted, setHasVoted] = useState(false)
  const [playerReady, setPlayerReadyState] = useState(false)

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

    if (game && game.started) {
      const timer = setTimeout(() => {
        setShowReadyButton(true)
      }, 10000) // Show ready button after 10 seconds

      return () => clearTimeout(timer)
    }
  }, [game, playerName, gameCode, navigate])

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
    resetGame()
    navigate('/')
  }

  const handleGoHome = () => {
    resetGame()
    navigate('/')
  }

  if (game.gameEnded) {
    const isWinner = game.winner === playerName
    return (
      <div className="min-h-screen p-4 flex items-center justify-center">
        <div className="max-w-md w-full space-y-6">
          <Card className="text-center">
            <div className={`w-20 h-20 mx-auto mb-4 rounded-full flex items-center justify-center ${
              isWinner ? 'bg-success' : 'bg-destructive'
            }`}>
              <svg className="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 20 20">
                {isWinner ? (
                  <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                ) : (
                  <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                )}
              </svg>
            </div>
            <h2 className="text-2xl font-bold text-textPrimary mb-2">
              {isWinner ? 'You were voted most out of sync!' : 'Game Over'}
            </h2>
            <p className="text-lg text-textSecondary mb-4">
              Most voted player: <span className="font-bold">{game.winner}</span>
            </p>
            {isOddPlayer && (
              <div className="text-sm text-textSecondary mb-4">
                <p>You had the different image ({playerCelebrity})</p>
                <p>Everyone else had: {isOddPlayer ? game.sameName : game.oddName}</p>
              </div>
            )}
          </Card>
          
          <Button variant="primary" size="large" onClick={handleNewGame}>
            Play Again
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
          </Card>

          <div className="space-y-3">
            {game.players.map((player, index) => {
              const isCurrentPlayer = player.name === playerName
              return (
                <Button
                  key={index}
                  variant={isCurrentPlayer ? 'destructive' : 'primary'}
                  size="large"
                  onClick={() => handleVote(player.name)}
                >
                  {isCurrentPlayer ? `${player.name} (yourself)` : player.name}
                </Button>
              )
            })}
          </div>
        </div>
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

        <Card>
          <div className={`w-full h-64 rounded-ios overflow-hidden mb-4 border-4 ${
            isOddPlayer ? 'border-destructive' : 'border-success'
          }`}>
            <img 
              src={playerImage} 
              alt={playerCelebrity}
              className="w-full h-full object-cover"
              onError={(e) => {
                e.target.src = 'https://via.placeholder.com/300x300?text=Image+Not+Found'
              }}
            />
          </div>
          
          {playerCelebrity && (
            <div className={`text-center p-3 rounded-ios border ${
              isOddPlayer 
                ? 'bg-red-50 border-destructive text-destructive' 
                : 'bg-green-50 border-success text-success'
            }`}>
              <p className="font-semibold">{playerCelebrity}</p>
            </div>
          )}
          
          <div className="text-center mt-4">
            <div className={`inline-block px-4 py-2 rounded-full text-sm font-medium ${
              isOddPlayer 
                ? 'bg-destructive bg-opacity-10 text-destructive' 
                : 'bg-success bg-opacity-10 text-success'
            }`}>
              {isOddPlayer ? 'You are the odd one out' : 'You are in the group'}
            </div>
          </div>
        </Card>

        {playerReady ? (
          <Card className="text-center">
            <div className="w-16 h-16 bg-success bg-opacity-10 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-8 h-8 text-success" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
              </svg>
            </div>
            <h2 className="text-xl font-bold text-textPrimary mb-2">You're Ready!</h2>
            <p className="text-textSecondary">Waiting for other players to get ready...</p>
          </Card>
        ) : showReadyButton ? (
          <Card className="text-center">
            <div className="w-16 h-16 bg-primary bg-opacity-10 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-8 h-8 text-primary" fill="currentColor" viewBox="0 0 20 20">
                <path d="M10 12a2 2 0 100-4 2 2 0 000 4z" />
                <path fillRule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clipRule="evenodd" />
              </svg>
            </div>
            <h2 className="text-xl font-bold text-textPrimary mb-2">Study the Image</h2>
            <p className="text-textSecondary mb-6">Look carefully and prepare to vote</p>
            <Button variant="primary" size="large" onClick={handleReady}>
              Ready to Vote
            </Button>
          </Card>
        ) : (
          <Card className="text-center">
            <div className="w-16 h-16 bg-warning bg-opacity-10 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-8 h-8 text-warning" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clipRule="evenodd" />
              </svg>
            </div>
            <h2 className="text-xl font-bold text-textPrimary mb-2">Studying Image...</h2>
            <p className="text-textSecondary">Look at your image carefully. The voting button will appear soon.</p>
          </Card>
        )}
      </div>
    </div>
  )
}

export default GamePage