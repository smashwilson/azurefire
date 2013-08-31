# azurefire

[![Build Status](https://travis-ci.org/smashwilson/azurefire.png?branch=master)](https://travis-ci.org/smashwilson/azurefire)

This is the code that powers [azurefire.net](http://azurefire.net/). It's a
minimalist Sinatra app that I use to host my personal blog, or whatever else
I want to do with that space in the future.

Everything related to the blog engine is file-based. Markdown posts and
comments are "baked" to html and rendered in-place by the haml templates.

## Why build my own blog engine?

Sure, there are tons of alternatives out there, even within the realm of
mostly-static website generation (Jekyll, for one). They'd come with
a wealth of actual "features" and "stability". But there's something
almost relaxing about rolling your own, from the ground up: it's a project
with clear requirements, in a well-understood domain...

Basically, writing a blog is programmer calisthenics.
