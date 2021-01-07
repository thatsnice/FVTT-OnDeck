notifyPlayer = (player, actorName) ->
  message =
    speaker: alias: "On Deck Module"
    content: "Be ready to take your turn as #{actorName}."
    whisper: [player._id]

  await ChatMessage.create message


maybeNotifyPlayer = (turn) ->
  actorName = turn.actor.name

  (player) ->
    if wantsOnDeckNotice player
      notifyPlayer player, actorName


nextTurn = (combat, turn) ->
  turn = turn + 1

  if turn >= combat.turns.length
    turn = 0

  turn


handleUpdateCombat = ( combat
                       changed
                       options
                       userId  ) ->

  return if game.user.isGM or
            not combat.turns?.length or
            "round" not in changed or
            "turn" not in changed

  {turn, turns} = combat

  while turn isnt nextTurn = nextTurn turn
    notifier = maybeNotifyPlayer {players, defeated} = turns[nextTurn]

    if not defeated
      players.forEach notifier
      return t

  return null


