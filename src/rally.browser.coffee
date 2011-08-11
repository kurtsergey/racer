require 'es5-shim'
Model = require './Model'

# Patch Socket.io-client to publish the close event and disconnet immediately
io.Socket::onClose = ->
  @open = false
  @publish 'close'
  @onDisconnect()


isReady = false

rally = module.exports =

  model: model = new Model

  init: (options) ->
    model._adapter._data = options.data
    model._adapter.ver = options.base
    model._clientId = options.clientId
    model._storeSubs = options.storeSubs
    model._startId = options.startId
    model._txnCount = options.txnCount
    model._onTxnNum options.txnNum
    model._setSocket io.connect options.ioUri,
      'reconnection delay': 50
      'max reconnection attempts': 20
    isReady = true
    rally.onready()
    return rally
  
  onready: ->
  ready: (onready) -> ->
    return onready() if isReady
    @onready = onready

