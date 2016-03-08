jQuery ->

  $('form#add-item-form').on 'submit', ->
    $('#snipe_ebay_item_input').val("")

  $('#check_all_items').on 'change', ->
    $('input[type=checkbox]').prop('checked', $(this).prop('checked'))

  updateTimes = ->
    $('.timeago').each ->
      time = Math.max((Date.parse($(this).attr('datetime')) - Date.now())/1000, 0) + 1
      this.textContent = countdown(
        Date.parse($(this).attr('datetime')),
        null,
        (
          if time < 60
            countdown.SECONDS
          else if time < 120
            countdown.MINUTES|countdown.SECONDS
          else if time < 3600
            countdown.MINUTES
          else if time < 86400
            countdown.HOURS|countdown.MINUTES
          else
            countdown.DAYS
        )
      ).toString().replace(" and ", " ").replace("minutes", "mins")

    setTimeout(updateTimes, 1000)

  updateTimes()
