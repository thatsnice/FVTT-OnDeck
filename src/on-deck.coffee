wantsOnDeckNotice = (player) ->
  return true # XXX: until we create an option for it

  # player.getFlag("on-deck", "notifyMe")


nextTurnIdx = (combat, turn) ->
  turn++

  if turn >= combat.turns.length
    turn = 0

  turn

LOG = (args...) ->
  console.log "ON-DECK: ", args...

handleUpdateCombat = ( combat
                       changed
                       options
                       userId  ) ->

  user = game.user
  {turn: curTurn, turns} = combat

  LOG { arguments }

  return unless wantsOnDeckNotice user

  return if user.isGM

  return unless "turn" in changed

  loop
    nextTurn = nextTurnIdx curTurn

    if nextTurn is curTurn
      LOG "all turns defeated"
      # all turns examined were .defeated
      return

    if (t = turns[nextTurn]).defeated
      if combat.skipDefeated
        LOG "ignoring defeated"
        continue
      else
        LOG "skipping defeated"
        return

    userInPlayers = user.id in t.players.map (p) -> p.id
    LOG {userInPlayers}

    if userInPlayers
      actorName = t.actor.name
      message =
        speaker: alias: "On Deck Module"
        content: "Be ready to take your turn as #{actorName}."
        whisper: [user._id]

      LOG {actorName, message}

      await ChatMessage.create message

      LOG "done?"

    return

  undefined

Hooks.on "updateCombat", handleUpdateCombat

game.OnDeck = {
  handleUpdateCombat
  nextTurnIdx
}

