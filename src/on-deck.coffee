wantsOnDeckNotice = (player) ->
  return true # XXX: until we create an option for it

  # player.getFlag("on-deck", "notifyMe")


nextTurnIdx = (combat, turn) -> (turn + 1) % combat.turns.length


handleUpdateCombat = (combat, changed, options, userId) ->
  user = game.user
  {turn: curTurn, turns} = combat

  return if not wantsOnDeckNotice user
  return if     user.isGM
  return if not "turn" in Object.keys changed

  loop
    nextTurn = nextTurnIdx combat, curTurn

    return if nextTurn is curTurn # all turns examined were .defeated

    if (t = turns[nextTurn]).defeated
      if combat.skipDefeated
        continue
      else
        return

    if user.id in t.players.map (p) -> p.id
      actorName = t.actor.name
      message =
        speaker: alias: "On Deck Module"
        content: "Be ready to take your turn as #{actorName}."
        whisper: [user.id]

      await ChatMessage.create message

    return

  undefined

Hooks.on "updateCombat", handleUpdateCombat
