wantsOnDeckNotice = (player) ->
  return true # XXX: until we create an option for it

  # player.getFlag("on-deck", "notifyMe")


nextTurnIdx = (combat, turn) ->
  turn++

  if turn >= combat.turns.length
    turn = 0

  turn


handleUpdateCombat = ( combat
                       changed
                       options
                       userId  ) ->

  user = game.user
  {turn: curTurn, turns} = combat


  return unless wantsOnDeckNotice user
  return unless turns?.length > 1
  return if user.isGM
  return if "round" not in changed and "turn" not in changed


  loop
    nextTurn = nextTurnIdx curTurn

    if nextTurn is curTurn
      # all turns examined were .defeated
      return

    if (t = turns[nextTurn]).defeated
      if combat.skipDefeated
        continue
      else
        return

    if user._id in t.players.map (p) -> p._id
      actorName = t.actor.name
      message =
        speaker: alias: "On Deck Module"
        content: "Be ready to take your turn as #{actorName}."
        whisper: [user._id]

      await ChatMessage.create message

    return

  undefined
