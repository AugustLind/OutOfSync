import React, { createContext, useContext, useReducer, useEffect } from 'react'

const StatsContext = createContext()

export const useStats = () => {
  const context = useContext(StatsContext)
  if (!context) {
    throw new Error('useStats must be used within a StatsProvider')
  }
  return context
}

const statsReducer = (state, action) => {
  switch (action.type) {
    case 'LOAD_STATS':
      return { ...state, ...action.payload }
    case 'GAME_COMPLETED':
      const { winner, oddPlayerName, playerName, wasCorrect, totalPlayers } = action.payload
      return {
        ...state,
        gamesPlayed: state.gamesPlayed + 1,
        gamesWon: state.gamesWon + (winner === playerName ? 1 : 0),
        correctGuesses: state.correctGuesses + (wasCorrect ? 1 : 0),
        timesOddPlayer: state.timesOddPlayer + (oddPlayerName === playerName ? 1 : 0),
        timesOddPlayerCaught: state.timesOddPlayerCaught + (oddPlayerName === playerName && winner === playerName ? 1 : 0),
        winStreak: winner === playerName ? state.winStreak + 1 : 0,
        bestWinStreak: winner === playerName ? Math.max(state.bestWinStreak, state.winStreak + 1) : state.bestWinStreak,
        averagePlayersPerGame: Math.round(((state.averagePlayersPerGame * (state.gamesPlayed - 1)) + totalPlayers) / state.gamesPlayed)
      }
    case 'RESET_STATS':
      return initialStats
    default:
      return state
  }
}

const initialStats = {
  gamesPlayed: 0,
  gamesWon: 0,
  correctGuesses: 0,
  timesOddPlayer: 0,
  timesOddPlayerCaught: 0,
  winStreak: 0,
  bestWinStreak: 0,
  averagePlayersPerGame: 0,
  firstPlayed: null,
  favoriteGameMode: 'celebrity'
}

export const StatsProvider = ({ children }) => {
  const [stats, dispatch] = useReducer(statsReducer, initialStats)

  // Load stats from localStorage on mount
  useEffect(() => {
    const savedStats = localStorage.getItem('outOfSyncStats')
    if (savedStats) {
      try {
        const parsedStats = JSON.parse(savedStats)
        dispatch({ type: 'LOAD_STATS', payload: parsedStats })
      } catch (error) {
        console.error('Error loading stats:', error)
      }
    } else {
      // First time playing
      const firstPlayStats = { ...initialStats, firstPlayed: new Date().toISOString() }
      dispatch({ type: 'LOAD_STATS', payload: firstPlayStats })
    }
  }, [])

  // Save stats to localStorage whenever they change
  useEffect(() => {
    localStorage.setItem('outOfSyncStats', JSON.stringify(stats))
  }, [stats])

  const recordGameResult = (gameResult) => {
    dispatch({ type: 'GAME_COMPLETED', payload: gameResult })
  }

  const resetStats = () => {
    dispatch({ type: 'RESET_STATS' })
  }

  const getAchievements = () => {
    const achievements = []
    
    if (stats.gamesPlayed >= 1) achievements.push({ id: 'first_game', name: 'First Game', description: 'Played your first game' })
    if (stats.gamesPlayed >= 10) achievements.push({ id: 'veteran', name: 'Veteran Player', description: 'Played 10 games' })
    if (stats.gamesWon >= 5) achievements.push({ id: 'winner', name: 'Serial Winner', description: 'Won 5 games' })
    if (stats.bestWinStreak >= 3) achievements.push({ id: 'streak', name: 'On Fire', description: 'Won 3 games in a row' })
    if (stats.correctGuesses >= 10) achievements.push({ id: 'detective', name: 'Celebrity Detective', description: 'Made 10 correct guesses' })
    if (stats.timesOddPlayerCaught >= 3) achievements.push({ id: 'sneaky', name: 'Master of Disguise', description: 'Got caught as the odd player 3 times' })
    if (stats.gamesPlayed >= 50) achievements.push({ id: 'legend', name: 'Hall of Fame', description: 'Played 50 games' })
    
    return achievements
  }

  const getStats = () => {
    const winRate = stats.gamesPlayed > 0 ? Math.round((stats.gamesWon / stats.gamesPlayed) * 100) : 0
    const accuracyRate = stats.gamesPlayed > 0 ? Math.round((stats.correctGuesses / stats.gamesPlayed) * 100) : 0
    const oddPlayerSuccessRate = stats.timesOddPlayer > 0 ? Math.round(((stats.timesOddPlayer - stats.timesOddPlayerCaught) / stats.timesOddPlayer) * 100) : 0
    
    return {
      ...stats,
      winRate,
      accuracyRate,
      oddPlayerSuccessRate,
      achievements: getAchievements()
    }
  }

  return (
    <StatsContext.Provider value={{
      stats: getStats(),
      recordGameResult,
      resetStats
    }}>
      {children}
    </StatsContext.Provider>
  )
}