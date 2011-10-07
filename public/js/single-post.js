$(document).ready(function () {
  var lastUpdate = new Date().getTime()

  // Enable live preview for the comment entry textarea. Update at most once every half-second.
  $('#comment-body').keyup(function () {
    if (new Date().getTime() - lastUpdate >= 500) {
      $('#comment-preview').load("/markdown-preview", { "body": this.value })
      lastUpdate = new Date().getTime()
    }
  });

})
