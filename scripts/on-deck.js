// Generated by CoffeeScript 2.5.1
(function() {
  var LOG, handleUpdateCombat, nextTurnIdx, wantsOnDeckNotice,
    indexOf = [].indexOf;

  wantsOnDeckNotice = function(player) {
    return true; // XXX: until we create an option for it
  };

  
  // player.getFlag("on-deck", "notifyMe")
  nextTurnIdx = function(combat, turn) {
    turn++;
    if (turn >= combat.turns.length) {
      turn = 0;
    }
    return turn;
  };

  LOG = function(...args) {
    return console.log("ON-DECK: ", ...args);
  };

  handleUpdateCombat = async function(combat, changed, options, userId) {
    var actorName, curTurn, message, nextTurn, ref, t, turns, user, userInPlayers;
    user = game.user;
    ({
      turn: curTurn,
      turns
    } = combat);
    LOG({arguments});
    if (!wantsOnDeckNotice(user)) {
      return;
    }
    if (user.isGM) {
      return;
    }
    if (indexOf.call(changed, "turn") < 0) {
      LOG({changed}, "has no turn?");
      return;
    }
    while (true) {
      nextTurn = nextTurnIdx(curTurn);
      if (nextTurn === curTurn) {
        LOG("all turns defeated");
        return;
      }
      // all turns examined were .defeated
      if ((t = turns[nextTurn]).defeated) {
        if (combat.skipDefeated) {
          LOG("ignoring defeated");
          continue;
        } else {
          LOG("skipping defeated");
          return;
        }
      }
      userInPlayers = (ref = user.id, indexOf.call(t.players.map(function(p) {
        return p.id;
      }), ref) >= 0);
      LOG({userInPlayers});
      if (userInPlayers) {
        actorName = t.actor.name;
        message = {
          speaker: {
            alias: "On Deck Module"
          },
          content: `Be ready to take your turn as ${actorName}.`,
          whisper: [user._id]
        };
        LOG({actorName, message});
        await ChatMessage.create(message);
        LOG("done?");
      }
      return;
    }
    return void 0;
  };

  Hooks.on("updateCombat", handleUpdateCombat);

  game.OnDeck = {handleUpdateCombat, nextTurnIdx};

}).call(this);
