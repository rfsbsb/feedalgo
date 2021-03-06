function attachAccordion() {
  $("#feed-container").accordion().accordion('destroy').accordion({
    header: ".feed_bar",
    collapsible: true,
    animate: false,
    heightStyle: "content",
    active: false,
    activate: function(event, ui) {
      if (ui.newHeader !== undefined && $(ui.newHeader).offset() !== undefined) {
        if ($(ui.newHeader).hasClass("unread")) {
          mark_item_as_read($(ui.newHeader).attr('id'));
        }
        var feed_entry = $(ui.newHeader).parent();
        // only load images and iframes when the feed is open avoiding unecesssary resource load
        var imgs = $(feed_entry).find("img[data-original],iframe[data-original]");
        $(imgs).each(function(index){
          $(this).attr('src', $(this).attr('data-original'));
          $(this).removeAttr('data-original');
        });
      }
    },
    create: function (event, ui) {
      $(".feed-container").children().first().find(".feed_bar").focus();
    }
  });
  favoriteIcons();
}

function update_count(id, value) {
  $('#sidebar #feed_' + id + ' .badge').html(value);
}

function mark_item_as_read(id) {
  if (id !== undefined) {
    $.get('/f/mark_as_read/' + id);
  }
}

/*
  Since the link_to :remote Rails' feature uses jQuery delegate there's a
  propagation from clicking on favorite icon to the jQuery Accordion, causing it
  to open and close as the user fav/unfav a item.

  To solve this, we have to attach the click behavior to every element, every
  time it is loaded, intercept the propagation, and then call the proper
  rails.click method to the item.

  Also, it cannot be attached in a .live/.delegate/.on method as explained
  on event.stopPropagation additional notes' page:
  http://api.jquery.com/event.stopPropagation/

  That's the reason this function exists.
*/
function favoriteIcons() {
  $('.feed_icon').click(function(event) {
    event.stopPropagation();
    event.stopImmediatePropagation();
    $(this).trigger('click.rails');
    return false;
  });
}

function setKeyboardShortcuts() {
  jwerty.key('k', function () {
    var active = $("#feed-container").accordion("option", "active");
    if (active !== false && !$(':focus').is("input")) {
      $("#feed-container .feed_entry").eq(active).prev().find('.feed_bar').click().focus();
    }
  });

  jwerty.key('j', function () {
    var active = $("#feed-container").accordion("option", "active");
    if (active !== false && !$(':focus').is("input")) {
      $("#feed-container .feed_entry").eq(active).next().find('.feed_bar').click().focus();
    }
  });

  jwerty.key('m', function () {
    var active = $("#feed-container").accordion("option", "active");
    if (active !== false && !$(':focus').is("input")) {
      var id = $("#feed-container .feed_entry").eq(active).find('.feed_bar').first().attr("id");
      mark_item_as_read(id);
    }
  });

  jwerty.key('f', function () {
    var active = $("#feed-container").accordion("option", "active");
    if (active !== false && !$(':focus').is("input")) {
      $("#feed-container .feed_entry").eq(active).find('.feed_icon').first().click();
    }
  });
}

function load_paging() {
  if ($(".next_page") !== undefined) {
    var page = $(".next_page").attr("data-next-page");
    var url = $(".next_page").attr("data-next-page-url");
    $.post(url, {page: page});
    $(".next_page").remove();
  }
}

$(document).ready(function() {
  $("#reader").on('click', '#showAll', function(){
    var url = $("span.read_url").attr('data-read-url');
    $.get(url);
  });

  $("#reader").on('click', '#showUnread' ,function(){
    var url = $("span.unread_url").attr('data-unread-url');
    $.get(url);
  });

  $("#reader").on('click', '#showFavorite' ,function(){
    var url = $("span.favorite_url").attr('data-favorite-url');
    $.get(url);
  });

  $("#reader").on('click', '.mark', function(){
    var url = $("span.mark_all_url").attr('data-mark-all-url');
    var period = $(this).attr('id');
    $.post(url, {period: period});
  });

  $("#reader").scroll(function(){
    if ($(".next_page").visible()) {
      load_paging();
    }
  });

  attachAccordion();
  setKeyboardShortcuts();
});