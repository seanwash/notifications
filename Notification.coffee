class Notification
  constructor: (opts={}) ->

    @options =
      autoclose: opts.autoclose ? false
      type: opts.type ? 'success'
      message: opts.message ? 'This is the default notification message. You should change this.'
      notifier: opts.notifier ? null

    @createElement()
    @setupCloseButton()
    @setupNotifierScroll() if @options.notifier

    @show()


  createElement: =>
    $('body').prepend """
      <div class="notification #{@options.type}">
        <p>#{@options.message}</p>
      </div>
    """

    @notificationEl = $('.notification')


  setupCloseButton: =>
    @notificationEl.prepend """
      <button class="trigger-close">
        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="16" height="16" viewBox="0 0 16 16" data-tags="x,cancel,close"><g fill="#ffffff" transform="scale(0.015625 0.015625)"><path d="M960 780.736l-268.992-268.736 268.992-268.736-179.264-179.264-268.736 268.864-268.864-268.864-179.136 179.264 268.736 268.736-268.736 268.736 179.136 179.264 268.864-268.864 268.736 268.864z"/></g></svg>
      </button>
    """

    @notificationEl.on 'click', '.trigger-close', (e) =>
      e.preventDefault()
      @hide()


  setupNotifierScroll: =>
    notifierEl = $(@options.notifier)
    notifierTop = notifierEl[0].offsetTop

    @notificationEl.find('p').wrapInner '<a href="#"></a>'

    @notificationEl.on 'click', 'a', (e) ->
      e.preventDefault()
      $('html, body').animate { scrollTop: notifierTop }, 400


  show: =>
    @notificationEl.addClass 'animated fadeInDown'

    if @options.autoclose
      setTimeout =>
        @hide()
      , 5000


  hide: =>
    @notificationEl.addClass 'animated fadeOutUp'

    @notificationEl.one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', (e) =>
      @destroy()


  destroy: =>
    @notificationEl.off().remove()
    $('#flash').off().remove()


window.App.Base.Notification = Notification
