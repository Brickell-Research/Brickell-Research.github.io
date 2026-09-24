#lang pollen

◊(define-meta title "Winter 2026 Roadmap")
◊(define-meta body-class "notebook")

◊note-meta["2026-09-23"]

◊h2{Winter 2026 Roadmap}

As it stands, per the initial use case (and then some), Caffeine is pretty much feature complete. For someone only compiling SLOs to Datadog, we support:

◊ol{
  ◊li{Datadog SLO Terraform generation.}
  ◊li{Type system over SLO inputs.}
  ◊li{LSP with support for VSCode and Open VSX.}
  ◊li{Basic assume/guarante structure with dependency visualization artifact generation.}
  ◊li{A reasonable syntax and structure to express measurements and system expectations in.}
}

Amongst other things, such as the caffeine version manager, that (I hope) makes Caffeine a first class user experience.

