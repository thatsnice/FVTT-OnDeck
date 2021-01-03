
OnDeckSymbol = Symbol 'OnDeck'

actorTurn = (combat, actor) ->
  combat.turns
    .find (t) ->
      t.actor.data._id is actor.data._id

errorActorNotInCombat = (combat, actor) ->
  new Error "Actor #{predecessor.name} (#{predecessor.data._id}) is not in combat #{combat.data._id}"

getPredecessor = (combat, actor) ->
  if combat.turns.length
    pred = combat.turns[..-1][0]

    for t in combat.turns
      t.actor.data._id is actorId
        return pred

addUpdateAlert = (combat, actor, predecessor) ->
  unless alertTurn = actorTurn combat, predecessor
    throw errorActorNotInCombat combat, predecessor

  actorId     = actor.data._id
  actorName   = actor.name
  combatId    = combat.data._id
  round       = combat.data.round
  alertTurnId = alertTurn._id

  data =
    name          : "OnDeck"
    combatId      : combatId
    createRound   : round
    turnId        : alertTurnId
    repeating     :
      frequency   : 1
      expire      : null
    message       : "You're on deck. Be ready for your turn."
    recipientIds  : [ actorId ]

  id = await TurnAlert.create data
  alert = TurnAlert.getAlertById id

  #alert[OnDeckSymbol] =


nextTurnIdx = (combat, turnIdx) ->
  for turn, idx in combat.turns when idx > turnIdx
    if not turn.defeated
      return idx

  for turn, idx in combat.turns
    if idx >= turnIdx
      return undefined

    if not turn.defeated
      return idx

  undefined

prevTurnIdx = (combat, turnIdx) ->
  prevIdx = undefined

  for turn, idx in combat.turns when not turn.defeated
    if idx is turnIdx
      if prevIdx isnt undefined
        return prevIdx

    prevIdx = idx

  prevIdx

isOnDeckFor = (actor) ->
  (alert) -> name.match /^OnDeck$/ and actor.data._id in alert.recipientIds

Hooks.on "updateCombatant", (combat, actor) ->
  combatId = combat.data._id
  turnIdx  = combat.turns.findIdx (t) -> t.actor.data._id is actor.data._id
  turn     = combat.turns[turnIdx]
  nextTurn = combat.turns[nextTurnIdx combat, turnIdx]

  if existingAlert = TurnAlert.getAlerts(combatId).find isOnDeckFor actor
    if turn.defeated or nextTurn is turn
      TurnAlert.delete combatId, existingAlert.id
    else
      TurnAlert.update
        id:           existingAlert.id
        recipientIds: [ nextTurn.actor.data._id ]

  else 
    if nextTurn is turn
      return

    TurnAlert.create makeAlert combat, actor, turn, nextTurn
  

  prevTurn = combat.turns[prevTurnIdx combat, turnIdx]



