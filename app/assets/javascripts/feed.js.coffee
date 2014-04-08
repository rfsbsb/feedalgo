$ ->
  $(".item a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    href = e.target.href;
    history.pushState({}, '', href);
    return
  # Resizing the two main components on window resizing
  $(window).resize ->
    newheight = $(window).innerHeight() - $("#main-header").innerHeight();
    $("#sidebar").innerHeight(newheight);
    $("#reader").innerHeight(newheight);
    return
  $("#reader").on 'click', '.edit-title', (e, data, status, xhr) ->
    e.stopPropagation();
    e.preventDefault();
    $('.header .editable').editable('toggle', null);
    return
  $(".small-folder").click ->
    $(this).parent().find(".nav").toggleClass('closed open', 'slow');
    $(this).toggleClass("icon-folder-close icon-folder-open");
    # toggling the state of the folder
    folder_id = $(this).parent().attr('id').replace("folder_",'');
    $.get('/f/folder/toggle/' + folder_id);
    return

  $(window).resize();
  return