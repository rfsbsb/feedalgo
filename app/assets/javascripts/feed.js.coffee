$ ->
  $(".item a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    href = e.target.href
    history.pushState({}, '', href);
    return
  # Resizing the two main components on window resizing
  $(window).resize ->
    newheight = $(window).innerHeight() - $("#main-header").innerHeight();
    $("#sidebar").innerHeight(newheight);
    $("#reader").innerHeight(newheight);
    return
  $(window).resize();
  return