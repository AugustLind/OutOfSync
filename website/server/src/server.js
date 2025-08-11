const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const Game = require('./models/Game');
const { getCelebrityPair } = require('./data/celebrityPairs');

require('dotenv').config();

const app = express();
const server = http.createServer(app);

const allowedOrigins = [
  'http://localhost:5173',
  'http://localhost:3000',
  process.env.FRONTEND_URL
].filter(Boolean);

const io = socketIo(server, {
  cors: {
    origin: allowedOrigins,
    methods: ["GET", "POST"],
    credentials: true
  }
});

const PORT = process.env.PORT || 3001;

app.use(cors({
  origin: allowedOrigins,
  credentials: true
}));
app.use(express.json());

// Serve static files from React build
const clientBuildPath = path.join(__dirname, '../../client/dist');
app.use(express.static(clientBuildPath));

// Serve React app for all non-API routes
app.get('*', (req, res) => {
  res.sendFile(path.join(clientBuildPath, 'index.html'));
});

const games = new Map();
const playerSockets = new Map();

io.on('connection', (socket) => {
  console.log('Player connected:', socket.id);

  socket.on('create-game', ({ playerName }) => {
    const gameCode = generateGameCode();
    const game = new Game(gameCode, playerName);
    games.set(gameCode, game);
    playerSockets.set(socket.id, { gameCode, playerName, isHost: true });
    
    socket.join(gameCode);
    socket.emit('game-created', { gameCode, game: game.toJSON() });
    console.log(`Game ${gameCode} created by ${playerName}`);
  });

  socket.on('join-game', ({ gameCode, playerName }) => {
    const game = games.get(gameCode);
    if (!game) {
      socket.emit('error', { message: 'Game not found' });
      return;
    }
    
    // Check if player is reconnecting to an existing game
    const existingPlayer = game.players.find(p => p.name === playerName);
    
    if (existingPlayer) {
      // Player is reconnecting - allow them back in
      playerSockets.set(socket.id, { gameCode, playerName, isHost: existingPlayer.isHost });
      socket.join(gameCode);
      socket.emit('game-joined', { game: game.toJSON() });
      console.log(`${playerName} reconnected to game ${gameCode}`);
      return;
    }
    
    if (game.started) {
      socket.emit('error', { message: 'Game already started' });
      return;
    }

    if (game.players.some(p => p.name === playerName)) {
      socket.emit('error', { message: 'Player name already taken' });
      return;
    }

    game.addPlayer(playerName);
    playerSockets.set(socket.id, { gameCode, playerName, isHost: false });
    
    socket.join(gameCode);
    socket.emit('game-joined', { game: game.toJSON() });
    io.to(gameCode).emit('player-joined', { playerName, game: game.toJSON() });
    
    console.log(`${playerName} joined game ${gameCode}`);
  });

  socket.on('start-game', async () => {
    const playerInfo = playerSockets.get(socket.id);
    if (!playerInfo || !playerInfo.isHost) return;

    const game = games.get(playerInfo.gameCode);
    if (!game || game.started || game.players.length < 2) return;

    const celebrityPair = getCelebrityPair();
    await game.startGame(celebrityPair);
    
    io.to(playerInfo.gameCode).emit('game-started', { game: game.toJSON() });
    console.log(`Game ${playerInfo.gameCode} started`);
  });

  socket.on('player-ready', () => {
    const playerInfo = playerSockets.get(socket.id);
    if (!playerInfo) return;

    const game = games.get(playerInfo.gameCode);
    if (!game || !game.started) return;

    game.setPlayerReady(playerInfo.playerName);
    io.to(playerInfo.gameCode).emit('player-ready-update', { 
      playerName: playerInfo.playerName,
      readyPlayers: game.readyPlayers,
      votingStarted: game.votingStarted
    });

    if (game.votingStarted) {
      io.to(playerInfo.gameCode).emit('voting-started');
    }
  });

  socket.on('vote', ({ votee }) => {
    const playerInfo = playerSockets.get(socket.id);
    if (!playerInfo) return;

    const game = games.get(playerInfo.gameCode);
    if (!game || !game.votingStarted) return;

    const result = game.vote(playerInfo.playerName, votee);
    
    if (!result.success) {
      socket.emit('error', { message: 'Invalid vote' });
      return;
    }
    
    io.to(playerInfo.gameCode).emit('vote-cast', { 
      voter: playerInfo.playerName, 
      votee,
      votes: game.votes.size,
      totalPlayers: game.players.length
    });

    if (result.gameEnded) {
      io.to(playerInfo.gameCode).emit('game-ended', { 
        winner: result.winner,
        votes: Array.from(game.votes.entries())
      });
      console.log(`Game ${playerInfo.gameCode} ended. Winner: ${result.winner}`);
    }
  });

  socket.on('disconnect', () => {
    const playerInfo = playerSockets.get(socket.id);
    if (playerInfo) {
      const game = games.get(playerInfo.gameCode);
      if (game) {
        // Don't immediately remove player, give them time to reconnect
        setTimeout(() => {
          // Check if player reconnected
          const stillDisconnected = !Array.from(playerSockets.values())
            .some(p => p.playerName === playerInfo.playerName && p.gameCode === playerInfo.gameCode);
          
          if (stillDisconnected) {
            game.removePlayer(playerInfo.playerName);
            socket.to(playerInfo.gameCode).emit('player-left', { 
              playerName: playerInfo.playerName,
              game: game.toJSON()
            });
            
            // Only delete game if it's been empty for a longer period (30 minutes)
            // to prevent accidental deletion during temporary disconnections
            if (game.players.length === 0) {
              setTimeout(() => {
                const gameStillExists = games.get(playerInfo.gameCode);
                if (gameStillExists && gameStillExists.players.length === 0) {
                  games.delete(playerInfo.gameCode);
                  console.log(`Game ${playerInfo.gameCode} deleted - no players left for extended period`);
                }
              }, 30 * 60 * 1000); // Wait 30 minutes before deleting empty game
            }
          }
        }, 5000); // Wait 5 seconds before removing player
      }
      playerSockets.delete(socket.id);
    }
    console.log('Player disconnected:', socket.id);
  });
});

function generateGameCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let code;
  do {
    code = Array.from({ length: 4 }, () => chars[Math.floor(Math.random() * chars.length)]).join('');
  } while (games.has(code));
  return code;
}

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});