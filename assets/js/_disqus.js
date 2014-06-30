// Enable Disqus comments at an <div id="disqus_thread"></div> element.

$(function () {
  var root = document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0];

  if ($('div#disqus_thread').length) {
    var embed = document.createElement('script');
    embed.type = 'text/javascript';
    embed.async = true;
    embed.src = '//' + disqus_shortname + '.disqus.com/embed.js';
    root.appendChild(embed);
  }

  if ($('a.disqus_count').length) {
    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.async = true;
    s.src = '//' + disqus_shortname + '.disqus.com/count.js';
    root.appendChild(s);
  }
});
