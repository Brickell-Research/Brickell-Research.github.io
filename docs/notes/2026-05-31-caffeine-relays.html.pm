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

◊code-block{
"langfuse_to_datadog" (Relay):
  from   "langfuse"
  to     "datadog"
  every  15m
  metric_prefix "langfuse.scores"
  scorers {
    "helpfulness": Numeric,
    "safe":        Boolean
  }
}

◊h2{The Artifact}

◊h2{A Full Example}

More soon.
