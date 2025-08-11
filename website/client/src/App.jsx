import { Routes, Route } from 'react-router-dom'
import { SocketProvider } from './contexts/SocketContext'
import { GameProvider } from './contexts/GameContext'
import HomePage from './pages/HomePage'
import LobbyPage from './pages/LobbyPage'
import GamePage from './pages/GamePage'

function App() {
  return (
    <SocketProvider>
      <GameProvider>
        <div className="min-h-screen bg-background">
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/lobby/:gameCode" element={<LobbyPage />} />
            <Route path="/game/:gameCode" element={<GamePage />} />
          </Routes>
        </div>
      </GameProvider>
    </SocketProvider>
  )
}

export default App