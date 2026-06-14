#lang pollen

◊(define-meta title "A New Feature Coming Soon to Caffeine: Relays")
◊(define-meta body-class "notebook")

◊note-meta["2026-05-31"]

◊h2{Two Birds One Stone}

As we have been using Caffeine the past few months, a couple challenges have come up. ◊aside{Rob actually changed jobs at the end of April, so we now know of two companies using Caffeine!}

◊ol{
  ◊li{Datadog query syntax is not formally defined}
  ◊li{The "integrate the metric" and then use it with Caffeine is likely a common scenario.}
}

We believe that if we actually shift left and introduce Caffeine earlier in the observability operations process, we can solve both of these. Thus, we introduce ◊pink{relays}: an artifact that connects metrics from one system to another and serves as the measurement within Caffeine.

The specific relay we are starting with is Langfuse to Datadog. By setting this up, we would then know what the Datadog query looks like ahead of time and thus the user would not actually need to write a query themselves, just their intent!

◊h2{Syntax}

So consider how measurements look today:
◊code-block{
"some measurement":
    Requires { service_name: String }
    Provides {
        indicators: {
            numerator: "sum:successes{$$service->service_name$$}",
            denominator: "sum:total{$$service->service_name$$}"
        },
        evaluation: "numerator / denominator"
    }
}

Here we had to define both the numerator and denominator queries and even though we are attempting to write our own datadog query parser library, since it is not quite documented, it is actually fairly likely most folks will successfully compile expectations to only have them fail to apply.

Consider now the relay version of this measurement:
◊code-block{
"some measurement":
  Requires { service_name: String }
  from   "some source"
  to     "datadog"
  every  15m
  metric_prefix "some_source.hits"
}

Now this is definitely not the final version, but the beauty here is that with the relay, the user does not need to write a query at all. Instead they just define their intent and the relay takes care of the rest.

Today folks would have to (a) figure out how to do the plumbing themselves AND then (b) figure out the query syntax to specify in the measurement definition to more or less just write Caffeine... but with the relay we just handle that all for folks. And as bonus avoid the unpleasant experience of writing Datadog queries by hand.

◊h2{The Artifact}

◊h2{A Full Example}

More soon.
