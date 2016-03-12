MessageBus.start(); # call once at startup

# how often do you want the callback to fire in ms
# MessageBus.callbackInterval = 500;
MessageBus.alwaysLongPoll = true;
MessageBus.subscribe "/items", (data) ->
  console.log(data)
  row = $(".ebay_item-#{data.id}")
  for k,v of data.values
    row.find(".#{k}").text(v)
