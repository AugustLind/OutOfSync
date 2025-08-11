class Game {
  constructor(code, hostName) {
    this.code = code;
    this.hostName = hostName;
    this.players = [{ name: hostName, isHost: true }];
    this.started = false;
    this.oddPlayerIndex = null;
    this.sameImage = null;
    this.oddImage = null;
    this.sameName = null;
    this.oddName = null;
    this.description = null;
    this.readyPlayers = new Set();
    this.votingStarted = false;
    this.votes = new Map();
    this.gameEnded = false;
    this.winner = null;
  }

  addPlayer(playerName) {
    if (this.started || this.players.some(p => p.name === playerName)) {
      return false;
    }
    this.players.push({ name: playerName, isHost: false });
    return true;
  }

  removePlayer(playerName) {
    const index = this.players.findIndex(p => p.name === playerName);
    if (index !== -1) {
      this.players.splice(index, 1);
      this.readyPlayers.delete(playerName);
      this.votes.delete(playerName);
      
      if (playerName === this.hostName && this.players.length > 0) {
        this.hostName = this.players[0].name;
        this.players[0].isHost = true;
      }
    }
  }

  async startGame(celebrityPair) {
    if (this.started || this.players.length < 2) return false;
    
    this.oddPlayerIndex = Math.floor(Math.random() * this.players.length);
    this.sameImage = celebrityPair.sameImage;
    this.oddImage = celebrityPair.oddImage;
    this.sameName = celebrityPair.sameName;
    this.oddName = celebrityPair.oddName;
    this.description = celebrityPair.description;
    this.started = true;
    this.readyPlayers.clear();
    this.votes.clear();
    this.votingStarted = false;
    this.gameEnded = false;
    this.winner = null;
    
    return true;
  }

  setPlayerReady(playerName) {
    this.readyPlayers.add(playerName);
    if (this.readyPlayers.size === this.players.length) {
      this.votingStarted = true;
    }
  }

  vote(voter, votee) {
    if (!this.votingStarted || this.gameEnded) return { success: false };
    
    // Don't allow voting for players not in the game
    if (!this.players.some(p => p.name === votee)) {
      return { success: false };
    }
    
    this.votes.set(voter, votee);
    
    if (this.votes.size === this.players.length) {
      const voteCounts = new Map();
      for (const votee of this.votes.values()) {
        voteCounts.set(votee, (voteCounts.get(votee) || 0) + 1);
      }
      
      let maxVotes = 0;
      let winner = null;
      for (const [player, votes] of voteCounts.entries()) {
        if (votes > maxVotes) {
          maxVotes = votes;
          winner = player;
        }
      }
      
      this.winner = winner;
      this.gameEnded = true;
      
      return { success: true, gameEnded: true, winner };
    }
    
    return { success: true, gameEnded: false };
  }

  getPlayerImage(playerName) {
    const playerIndex = this.players.findIndex(p => p.name === playerName);
    return playerIndex === this.oddPlayerIndex ? this.oddImage : this.sameImage;
  }

  getPlayerName(playerName) {
    const playerIndex = this.players.findIndex(p => p.name === playerName);
    return playerIndex === this.oddPlayerIndex ? this.oddName : this.sameName;
  }

  isOddPlayer(playerName) {
    const playerIndex = this.players.findIndex(p => p.name === playerName);
    return playerIndex === this.oddPlayerIndex;
  }

  toJSON() {
    return {
      code: this.code,
      hostName: this.hostName,
      players: this.players,
      started: this.started,
      oddPlayerIndex: this.oddPlayerIndex,
      sameImage: this.sameImage,
      oddImage: this.oddImage,
      sameName: this.sameName,
      oddName: this.oddName,
      description: this.description,
      readyPlayers: Array.from(this.readyPlayers),
      votingStarted: this.votingStarted,
      votes: Array.from(this.votes.entries()),
      gameEnded: this.gameEnded,
      winner: this.winner
    };
  }
}

module.exports = Game;