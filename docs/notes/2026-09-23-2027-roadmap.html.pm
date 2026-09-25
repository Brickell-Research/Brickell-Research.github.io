#lang pollen

◊(define-meta title "2027 Roadmap")
◊(define-meta body-class "notebook")

◊note-meta["2026-09-23"]

◊h2{2027 Roadmap}

As it stands, per the initial use case (and then some), Caffeine is pretty much feature complete. For someone only compiling SLOs to Datadog, we support:

◊ol{
  ◊li{Datadog SLO Terraform generation.}
  ◊li{Type system over SLO inputs.}
  ◊li{LSP with support for VSCode and Open VSX.}
  ◊li{Basic assume/guarantee structure with dependency visualization artifact generation.}
  ◊li{A reasonable syntax and structure to express measurements and system expectations in.}
}

Amongst other things, such as the caffeine version manager, that (I hope) makes Caffeine a first class user experience. So where do we go from here? Truth be told I had built just about exactly
what I had wanted. And I still use it weekly at my day job. What more is needed that won't bloat the compiler and will provide more benefit?

If you began to cringe and think "he is about to say AI isn't he..." yes, you're right, but give me a chance.

So today we can actually already write SLOs on evals. Simple. Get the data to be metrics in Datadog, capture that metric as a measurement, write an assumption. However, in a way that wasn't obvious before,
it turns out there are two types of assumptions at play.

◊ol{
  ◊li{Structural: the things we build upon must continue meeting their guarantees or else we can't meet ours if those dependencies are hard.}
  ◊li{Contextual: what elements of the system, and the world around it, did we base our expectations upon.}
}

Two is net new. It came from thinking about the lessons I have learned writing evals for a production voice agent at work. The expectation I have is very much a product of the state of the agent today.

◊ul{
  ◊li{the model}
  ◊li{the judge}
  ◊li{the data}
  ◊li{the harness}
  ◊li{a breakdown of the distribution of personas}
  ◊li{traffic volume and patterns}
}

And furthermore, we can extract this to "normal" engineering cases as well. For instance let's say we just stood up a new internal API service for the 100 employees at our company that work all
within the same EST timezone. But then in six months this will be external to users across the United States. Clearly that SLO might drift. How can we signal that the expectation we made must be
revisited since the underlying state of the world is fundamentally different?

Thus we have the distinction. Structural assumption violations show that some dependency within the system is no longer meeting its guarantees and thus we cannot meet our own. That one's attributable,
you can point at the dependency that broke its promise. Contextual assumption violations show that the underlying state of the world has changed and thus our expectations must be revisited. That one
isn't attributable in the same way, nothing broke a promise, the world just moved out from under it. Both are important to capture, but the latter is more subtle and harder to detect.

Put another way: an expectation is a promise we make. A contextual assumption is an observation our promise depends on, but doesn't control. That direction of accountability is really the whole distinction.

And thus we define a limitation on this. Contextual assumptions must be measurable. These get interesting because in a way they are also expectations. We assume our system will stay below 1,000 users or
we expect our system to be 50% spanish speakers. However, they are not SLOs. These are not things we can control or guarantee but they are equally important things to capture, make explicit (not keep tacit)
and thus we can then build connections between parts of the system that rely on eachother. A side effect of this is you can actually begin to reason about blast radius of assumption violations. That's
quite powerful. Some of this measurability can be mechanical rather than manually asserted too, hash the dataset, pin the model/judge/harness versions, so a name like ◊code{triage-cases-v4} can't quietly
change out from under an old result without anyone noticing.

◊h3{Pass/Fail Isn't Enough Anymore}

Right now a result is basically pass or fail. Once contextual assumptions are a first class thing, there's a second axis to track: valid or stale. A passing score whose context has drifted out from
under it isn't really evidence of anything current, it's stale. And a failing score evaluated under a context that's already drifted isn't necessarily a clean signal the system is broken either, it
mostly just means we don't have good evidence anymore either way.

This matters because staleness can act as a leading indicator. Traffic mix or persona distribution can drift out of the range it was validated against well before the latency graph or the eval score
itself goes red. Catching that early means flagging "hey, this expectation needs a re-check" during a calm moment, rather than finding out the hard way after something user-visible breaks.

And because several expectations can share the same underlying contextual assumption, say, the same persona distribution or the same dataset, a violation doesn't have to mean manually tracking down
what's affected. That's a blast radius query: which expectations became suspect the moment this piece of the world changed.

◊h3{What This Means For Caffeine}

Datadog stays as the substrate. It's good at pointwise checks, query a metric, apply a threshold, and most contextual predicates (traffic volume, language share, latency distribution) can probably
compile straight down to Datadog monitors the same way expectations already do.

What Datadog can't hold is the relationship layer: which contextual assumption a given result was evaluated under, whether that assumption still holds, which other expectations share it, and what
should happen when it doesn't. That's a thin control plane living above Datadog, owned by Caffeine. Small, deterministic, auditable. An agent can help at the fuzzy edges, summarizing why a context
drifted, drafting a re-baselining PR, but it doesn't get to be the thing deciding whether a formal assumption passed. That decision has to stay something I can point at and explain.

Funny enough, I actually tried a version of the runtime piece of this once already, a "relay": a declarative connection from Langfuse, where our eval results actually live, to Datadog, code-generated
as a GitHub Action. It never shipped, because by the time I got around to it the plumbing had already been bolted directly onto the eval executor, and a whole new abstraction on top of that would have
added complexity without buying much. The lesson stuck with me though, don't invent a new runtime concept when an existing executor already does the job. Caffeine should describe topology and
semantics, and only own the runtime state it actually needs (staleness, relationships), not reinvent transport it already has.

◊h3{What's Still Open}

Re-evaluation is the obvious next question once something goes stale, re-run the eval, get a fresh result, restore validity or escalate a real failure. But "just fire a GitHub Action" undersells it.
What counts as a representative fresh sample? Who or what labels it? If the judge itself is part of what drifted, can it even be trusted to label the new sample? What's the actual failure policy, page,
ticket, PR, or just report? I think this is better modeled as a small state machine than a single stale-to-rerun edge, and I'm not going to pretend I've designed that yet.

There's also a whole statistical layer underneath all of this that I've mostly hand-waved past so far, confidence intervals on eval scores instead of treating them as exact numbers, how much sample
you actually need to support a given target, what drift test makes sense for a persona mix versus a continuous feature, how to avoid false alarms when you're watching a bunch of contextual assumptions
at once. I don't want to hardcode one universal statistical test into the compiler, more likely this ends up as typed predicates with sensible defaults you can override. But that's its own design pass,
not something I'm solving in this post.

So, rough sequencing as I see it: nail down the structural/contextual language distinction and what "measurable" actually means, add staleness as a real state alongside pass/fail, compile as much of
it as possible straight to Datadog, add the thin relationship layer on top for blast radius, and only then start prototyping re-evaluation triggers against the existing eval executor. A dedicated UI,
a bigger runtime, those only get built if Datadog and the existing tooling actually prove insufficient, not before.

Datadog watches the signals. Caffeine's job is to watch whether the relationships and context still make those signals valid evidence for an expectation.

