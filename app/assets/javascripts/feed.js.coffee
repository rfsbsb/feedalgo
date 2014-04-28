$ ->
  $("#sidebar a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    href = e.target.href;
    history.pushState({}, '', href);
    return
  # Resizing the two main components on window resizing
  $(window).resize ->
    newheight = $(window).innerHeight() - $("#main-header").innerHeight();
    $("#sidebar").innerHeight(newheight);
    $("#reader").innerHeight(newheight);
    return
  $(".small-folder").click ->
    $(this).parent().find(".nav").toggleClass('closed open', 'slow');
    $(this).toggleClass("icon-folder-close icon-folder-open");
    # toggling the state of the folder
    folder_id = $(this).parent().attr('id').replace("folder_",'');
    $.get('/f/folder/toggle/' + folder_id);
    return
  $(document).on "click", "#new-feed .btn", (e, data, status, xhr) ->
    $('.preloader').removeClass("hide");

  # Avoid submit form when press enter
  $(document).on "keyup keypress", ".modal-dialog form", (e, data, status, xhr) ->
    code = e.keyCode || e.which;
    if (code == 13)
      e.preventDefault();
      return false;
    return true


  $(window).resize();
  return