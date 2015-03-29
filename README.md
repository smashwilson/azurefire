# azurefire.net

[![Docker Repository on Quay.io](https://quay.io/repository/smashwilson/azurefire/status "Docker Repository on Quay.io")](https://quay.io/repository/smashwilson/azurefire)

This is the source for [smashwilson's](https://github.com/smashwilson) static site, on which he blogs about various shenanigans that may or may not be interesting for anyone else.

It's built on [Jekyll](http://jekyllrb.com/) and based on the [HMFAYSAL V2](http://v2.theevilgenius.tk) theme.

## Building

If you've got a relatively sane Ruby install, previewing new content is as easy as:

```bash
# Once
bundle install

# See your changes at http://localhost:4000/
bundle exec jekyll serve
```

If you're editing stylesheets or assets, you'll need to use `grunt`:

```bash
# Once
npm install -g grunt-cli
npm install .

# See your changes
grunt
```
