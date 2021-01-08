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
    var actorName, curTurn, message, nextTurn, ref, t, turns, user;
    user = game.user;
    ({
      turn: curTurn,
      turns
    } = combat);
    LOG({arguments});
    if (!wantsOnDeckNotice(user)) {
      return;
    }
    LOG({
      wantsOnDeckNotice: true
    });
    //return unless turns?.length > 1
    if (user.isGM) {
      return;
    }
    LOG({
      userIsGM: false
    });
    if (indexOf.call(changed, "round") < 0 && indexOf.call(changed, "turn") < 0) {
      return;
    }
    LOG({
      noTurnChange: false
    });
    while (true) {
      nextTurn = nextTurnIdx(curTurn);
      if (nextTurn === curTurn) {
        LOG("all turns defeated");
        return;
      }
      // all turns examined were .defeated
      if ((t = turns[nextTurn]).defeated) {
        if (combat.skipDefeated) {
          continue;
        } else {
          return;
        }
      }
      if (ref = user._id, indexOf.call(t.players.map(function(p) {
        return p._id;
      }), ref) >= 0) {
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
