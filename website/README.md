# Out of Sync - Website Version

A multiplayer web-based version of the "odd one out" game where players try to identify who has the different image.

## How to Play

1. One player creates a game and shares the game code
2. Other players join using the game code
3. When the game starts, everyone gets an image except one person gets a different image
4. Players study their images and vote for who they think has the different image
5. The player with the most votes is declared the winner!

## Features

- Real-time multiplayer using WebSockets
- Modern iOS-inspired UI with Tailwind CSS
- Celebrity image pairs for interesting gameplay
- Responsive design for all devices
- Instant game creation and joining

## Tech Stack

- **Frontend**: React 18 + Vite
- **Backend**: Node.js + Express
- **Real-time**: Socket.io
- **Styling**: Tailwind CSS
- **Routing**: React Router

## Development Setup

### Prerequisites
- Node.js 16+ and npm

### Installation

1. Clone the repository and navigate to the website directory:
   ```bash
   cd website
   ```

2. Install dependencies for all packages:
   ```bash
   npm run install:all
   ```

3. Start the development servers:
   ```bash
   npm run dev
   ```

   This will start:
   - Backend server on http://localhost:3001
   - Frontend development server on http://localhost:5173

### Individual Commands

- **Server development**: `npm run server:dev`
- **Client development**: `npm run client:dev`
- **Build for production**: `npm run build`
- **Start production server**: `npm start`

## Project Structure

```
website/
├── package.json          # Root package with dev scripts
├── server/               # Backend Node.js server
│   ├── src/
│   │   ├── server.js     # Main server file
│   │   ├── models/       # Game models
│   │   └── data/         # Celebrity pairs data
│   └── package.json
├── client/               # React frontend
│   ├── src/
│   │   ├── components/   # Reusable UI components
│   │   ├── pages/        # Page components
│   │   ├── contexts/     # React contexts for state
│   │   └── App.jsx       # Main app component
│   └── package.json
└── README.md
```

## Game Flow

1. **Home Page**: Enter name, create or join game
2. **Lobby**: Wait for players, host starts game
3. **Game**: View image, wait for voting phase
4. **Voting**: Vote for the odd player
5. **Results**: See who won and play again

## API Events (Socket.io)

### Client to Server
- `create-game` - Create a new game
- `join-game` - Join existing game
- `start-game` - Start the game (host only)
- `player-ready` - Mark player as ready to vote
- `vote` - Cast vote for odd player

### Server to Client
- `game-created` - Game creation confirmation
- `game-joined` - Successfully joined game
- `player-joined/left` - Player status updates
- `game-started` - Game has begun
- `voting-started` - Voting phase started
- `game-ended` - Game finished with results

## Deployment

1. Build the client:
   ```bash
   cd client && npm run build
   ```

2. Start the production server:
   ```bash
   cd server && npm start
   ```

The server will serve the built React app from the client/dist directory.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally
5. Submit a pull request