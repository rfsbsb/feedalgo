$ ->
  $(".item a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    href = e.target.href
    history.pushState({}, '', href);
    return