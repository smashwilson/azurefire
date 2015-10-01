---
layout: post
title: Don't Try to Fix People with Process
date: "2015-10-01"
category: news
description: A thought on creating an effective software process that doesn't suck.
tags:
- software
- process
image:
  feature: texture-nevada-road.jpg
---

Process can be a substantial source of friction on a team, but it doesn't have to be. It's a necessary and important component of building anything, but at its worst, it can feel like a series of arbitrary hoops to jump through before you can get anything done, or even be outright hostile. Keeping your process *useful* without ticking everyone off and killing velocity takes vigilance, care and attention.

The biggest pitfall that I've personally witnessed is **trying to use your process to fix bad developers,** and it's poison to a working process. You're in a conference room with a Word doc on the screen trying to hash out the steps that developers need to follow to make changes, and somehow the tone subtly shifts to "how do we keep these idiots from breaking everything." It can happen even when the developers are crafting the process themselves or have heavy input; my speculation is that that's some mix of lacking self-confidence or passive-aggressive sniping against teammates.

I'm exaggerating a little -- if anyone actually *says* something like this, you're already doomed. More realistically, symptoms of this include long checklists of peer reviews, voting systems, and lots of cross-validation and extra sign-offs. At some point, you need to admit to yourselves that it isn't that you're managing risk and preventing bugs from shipping, it's that you don't trust the rest of the team who are *building the actual product*, and trust is one of the most important ingredients in a functional team.

Some concrete things that you can do to counteract this:

 * **Make mandatory steps voluntary when you can**. Let a developer choose when a pull request needs extra review before it's merged. You'll be surprised how often your devs opt in to peer reviews, especially once they've seen it catch a few subtle bugs, and they'll be greatful when they just want to fix a typo in the README.

 * **Optimize for shipping,** not for catching all bugs before they reach production at all costs. Like most decisions, there is a spectrum here, but it's very, very easy to fall closer to the "preventing bugs" side than you need to be, and that too has a cost. No matter how many barriers and gates and checks you impose on your team, developers are human, and mistakes *will* make it through at some point. The more hurdles lie between a developer and their code being live in production, the longer those bugs will *stay* in production before fixes can be applied.
 
  The real equation at work is:
   
  _(frequency of bugs shipped) * (damage from each) * (time to fix)_
   
  Taking more care can reduce the frequency of bugs shipped but only by increasing the time to fix. Sometimes that's appropriate, but be mindful of the full picture. Note that giving developers more opportunities to use their own judgement on a task-by-task basis can also bring you closer to an optimum solution here.

 * **Automate everything you can**. Use continuous integration to catch test failures instead of just mandating that everyone run the test suite by hand. Link issues to pull requests and automatically cross-reference and close them when the code is actually merged or shipped. Pull reports from your ticketing system rather than make everyone email you what they're doing all the time.
 
   Each time you introduce a human into the workflow, you're introducing a time delay, increasing social complexity, and adding a point of failure. A human being is far more likely to forget to run your integration tests than [Travis](https://travis-ci.org/) is! The more work that you can push into infrastructure instead, the more accurately and expediently your process will be followed. Of course there are times when slowing you down is the point -- peer reviews, for example -- but there are many more opportunities for streamlining.
   
   Essentially, automation lets you increase the amount of rigor you introduce, while keeping the prices of time and complexity low.
 
 * **Revisit and refine** often. Listen to your team, watch how you work together with a critical eye, and only keep the bits that are actually adding value for you. There's a strong pull, as the one who writes the process, to add *more* process over time; fight the instinct and instead bias toward cutting as much of it as you can get away with.
 
   The downside here is that changing too frequently can make it hard for everyone to keep up with that they're supposed to be doing. I'd counter this by building process updates into the natural planning and shipping cadence so that everyone knows when to expect changes, and by keeping it lean enough to fit in a single page. You could even keep a workflow description in a `CONTRIBUTING.md` file alongside your source and propose changes with pull requests and take advantage of all of the existing notification and discussion machinery you use for source code to iterate on process, too.
   
   Realistically, you should converge on something that works for your team and your project fairly quickly; I'd expect big changes that everyone has to relearn only after lots of people join or leave, or after major shifts in project direction, when things are chaotic anyway.

 * **"Fix" developers with mentorship and communication instead.** Process is a tool you can use for coordinating efforts, planning, and communicating outward; teaching, pair programming, and one-on-ones or just pinging someone in chat are the tools that you can use to deal with problems.
 
  You'll never be able to put together a magical flowchart that you can follow to turn a problem coworker into a helpful one. People are individuals and it's the relationships that you share that help you all grow.

---

The bottom line is that it isn't your process that's creating software, with a group of engineers following it like automata to reach a predictable outcome. It's a team of human beings using creativity and discipline and judgement, and because they're writing the actual source, you're already trusting them deeply. They all want to ship something that works, that they can be proud of. Remember you're on the same side!