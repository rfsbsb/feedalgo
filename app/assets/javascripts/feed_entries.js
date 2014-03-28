
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

        // only load images when the feed is open avoiding unecesssary resource load
        var imgs = $(feed_entry).find("img[data-original]");
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

function mark_item_as_read(id) {
  if (id !== undefined) {
    $.get('/f/'+id+'/mark_as_read');
  }
}

/*
  Since the link_to :remote feature of rails does use jQuery delegate there's a
  propagation from clicking on favorite icon to the jQuery Accordion, causing it
  to open and close as the user fav/unfav a item.

  To solve this, we have to attach the click behavior to every element, every
  time it is loaded, intercept the propagation, and then call the proper
  rails.click method to the item.

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
    if (active !== false) {
      $("#feed-container .feed_entry").eq(active).prev().find('.feed_bar').click().focus();
    }
  });

  jwerty.key('j', function () {
    var active = $("#feed-container").accordion("option", "active");
    if (active !== false) {
      $("#feed-container .feed_entry").eq(active).next().find('.feed_bar').click().focus();
    }
  });

  jwerty.key('m', function () {
    var active = $("#feed-container").accordion("option", "active");
    if (active !== false) {
      var id = $("#feed-container .feed_entry").eq(active).find('.feed_bar').first().attr("id");
      mark_item_as_read(id);
    }
  });

  jwerty.key('f', function () {
    var active = $("#feed-container").accordion("option", "active");
    if (active !== false) {
      $("#feed-container .feed_entry").eq(active).find('.feed_icon').first().click();
    }
  });
}

$(document).ready(function() {
  attachAccordion();
  setKeyboardShortcuts();
});