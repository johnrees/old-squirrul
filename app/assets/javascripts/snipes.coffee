jQuery ->
  $('.ends_at').each ->
    this.textContent = moment(this.textContent).fromNow();
