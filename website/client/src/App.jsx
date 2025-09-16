import { Routes, Route } from 'react-router-dom'
import { SocketProvider } from './contexts/SocketContext'
import { GameProvider } from './contexts/GameContext'
import { StatsProvider } from './contexts/StatsContext'
import { ThemeProvider } from './contexts/ThemeContext'
import HomePage from './pages/HomePage'
import LobbyPage from './pages/LobbyPage'
import GamePage from './pages/GamePage'
import ThemeToggle from './components/ThemeToggle'

function App() {
  return (
    <ThemeProvider>
      <SocketProvider>
        <GameProvider>
          <StatsProvider>
            <div className="min-h-screen bg-background dark:bg-background-dark transition-colors duration-300">
              <ThemeToggle />
              <Routes>
                <Route path="/" element={<HomePage />} />
                <Route path="/lobby/:gameCode" element={<LobbyPage />} />
                <Route path="/game/:gameCode" element={<GamePage />} />
              </Routes>
            </div>
          </StatsProvider>
        </GameProvider>
      </SocketProvider>
    </ThemeProvider>
  )
}

export default App