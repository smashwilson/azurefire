$(document).ready(function () {

  // Enable live preview for the comment entry textarea.
  $('#comment-body').keyup(function () {
    $('#comment-preview').load("/markdown-preview", { "body": this.value })
  });

})
