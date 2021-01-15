CONST        = require './const'
OnDeckConfig = require './on-deck-config'

module.exports =
  class OnDeckApplication extends Application
    constructor: ({@combatId}, options) ->
      super options

      unless @_combat = game.combats.get @combatId
        throw new Error "invalid combatID (#{@combatId})"

      Hooks.on "updateCombat", @_updateHandler.bind @
      Hooks.on "deleteCombat", @close.bind @

    @_updateHandler: (combat, changed, options, userId) ->
      if combat.data._id is @combatId and changed.active is false) {
        @close()
      else
        @render false
