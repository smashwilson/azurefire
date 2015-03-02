---
layout: post
title: "Getting Rusty"
date: "2015-03-01"
category: news
description: Getting acquinted with the Rust programming language.
tags:
- software
- rust
- learn everyday
image:
  feature: texture-rainier-treetops.jpg
---

Lately I've been toying a little with [Rust](http://www.rust-lang.org/). Learning new programming languages is [something I enjoy]({{ site.url }}/about/) when I get the chance to do so. Just as [spoken language affects the way we see the world](http://en.wikipedia.org/wiki/Linguistic_relativity), programming languages affect the way we approach problems, so I believe it's beneficial to stretch your boundaries once in a while and immerse yourself in something different from your familiar tools.

Also, there's something oddly refreshing about being a total beginner at something again. Rust is still pre-1.0 for another few months, so there aren't many Rust programmers who *aren't* total beginners.

Rust is a modern system programming language created by Mozilla Research. Its distinguishing feature is an ambitious one: exact, automatic memory management without a garbage collector. The front page of the Rust site even features this excellent piece of nerd-sniping:

![Nerd sniping]({{ "getting-rusty/nerd-baiting.png" | asset_path }})

I know at least one low-level systems hacker who saw this and immediately spent a Friday night trying to break it.

## The Project

The best way that I've found to learn something new is to use it to build something non-trivial in scope. For Rust, I'm re-writing a webapp that I threw together with about two hundred lines of Ruby in an afternoon some years ago. It's a game, or a writing exercise, where a group of friends can take turns building a story. Each person contributes a paragraph or two at a time. The catch is that, until the story is complete, each contributor can see only the submission immediately before their own. It's just a bit like a game of "[Telephone](http://en.wikipedia.org/wiki/Chinese_whispers)," except that you add to the message instead of relay it, and often go around the group more than once.

It's a lot of fun! Depending on who's writing, the results can range from hilarious to bizarre.

The Ruby version was quick, dirty, and full of bugs and race conditions. For its Rust incarnation, I'm adding some features: OAuth logins from GitHub or Google, multiple concurrent stories, and real persistence via PostgreSQL instead of just using the raw filesystem. I'm not horribly far along with development. If you're interested in following along, the source is [on GitHub](https://github.com/smashwilson/collaborative-fiction).

I should note that this is actually an awful use case for Rust. At its peak, I had maybe a dozen casual users, rarely concurrent. A single-threaded Sinatra application on the cheapest cloud server can easily handle the load. Using Rust here is massive overkill, but the point is to learn Rust rather than ship something.

## Ownership and the Borrow Checker

The ownership system is the mechanism that Rust uses for memory management. Essentially, the compiler infers the exact lifetime of each object, so that a `free()` call (or more commonly a stack deallocation) can unambiguously be performed as soon as no more references remain.

{% highlight rust %}
fn caller() -> {
  let t = Thing::new();

  takesOwnership(t);

  // You can't use t here
}

fn takesOwnership(t: Thing) -> {
  println!("I got {:?}", t);

  // t gets destroyed here!
}
{% endhighlight %}

<!-- Borrowing -->

{% highlight rust %}
fn caller() -> {
  let t = Thing::new();

  borrows(t);

  println!("I've still got a {:?}", t);
}

fn borrows(s: &Thing) -> {
  println!("I borrowed {:?}", s);
}
{% endhighlight %}

<!-- Returning references -->

{% highlight rust %}
fn caller() -> {
  let t = returns();

  println!("I have a {:?}", t);
}

fn returns() -> Thing {
  Thing{
    field: 1
  }
}
{% endhighlight %}

## Type System

<!--  -->

## Thoughts

<!--  -->
