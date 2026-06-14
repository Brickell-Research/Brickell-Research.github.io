#lang pollen

◊(define-meta title "Non-Determinism Creep")
◊(define-meta body-class "notebook")

◊note-meta["2026-06-14"]

◊h2{Non-Determinism Creep}

Outside of Brickell Research, I hold a day job where I have spent some time working on an important, yet a surfaces value trivial agentic feature. In order to seaprate this post here from that work, I will make up a scenario that captures the essence of the problem.

I have spent a fair amount of time the past few days watching the world cup on Fubo and for one of the games I was watching, I acidentally recorded the game. While not teribly useful for me - the games are in friendly timezones to myself - for folks on the other side of the globe, watching live games is likely impossible. Realizing this myself, let's say that Fubo has an api for game recording and I am interested in building an agentic AI voice agent that can help schedule the recordings.

Now funny enough, if you're a cranky realist like myself, your first instinct might be "can't we just build a simple with deterministic drop downs that the user can select from?" Easy right? Well it turns out that this feature is ingrained within a football fan immersive voice experience hotline. This hotline helps troubled football fans decide which team is for them by reasoning, live, through a set of non-deterministic questions proposed by an agent. Then, at the end of the call we setup the game recording to show the game at their time of choosing.

Maybe this scenario feels a bit contrived? While it is, bear with me. TLDR we've got an experience like this:

◊ol{
  ◊li{User calls in.}
  ◊li{Agent proposes non-deterministic questions about the user's preferences.}
  ◊li{User answers the questions.}
  ◊li{Agent then works with user to establish at what time they'd like to watch the game.}
}

◊h3{A Beginning}

Ok, so regardles of whatever fun survey we prompt the agent to help the user hone in on their preffered team, the agent needs to be able to work with the user to establish at what time they'd like to watch the game. Prompting this isn't inherently hard, nor particularly interesting. The hard bit is taking the time the user agreed upon and then scheduling the recording to be available at that time.

For starters, let's say the call itself is a one-shot, black box call and all we get at the end is a transcript. This was more or less where I started my journey at work.

Well, now we have the issue of taking a transcript and figuring out how to interpret at what time the user and the agent agreed upon.

◊code-block{
    let transcripts = call(agent, patient)
    let time_to_schedule_recording = extract_time(transcript)
}

At the beginning, the call volume was low enough that we just had a human operator handle the calls and extract the time manually. All worked well.

◊h3{Scaling}

However, our service was so awesome that Telemundo picked it up and started to grow the call volume. Furthermore our Spanish speaker base was growing rapidly and none of our human operators were billingual.

So we started to automate the call handling process using AI models.

Now we might be able to do something smart like have the agent return at the end of the call some json blob with the scheduled time, however, again, this is a black box. We only get the transcript. Thus, we now need to write a method that takes the transcript and extracts the time the user and the agent agreed upon. Since this is a non-trivial regex problem, let's instead use a second model to extract the time.

And furthermore, since we're heavily relying on this time being extracted properly, let's introduce a third model to eval the time extraction since if that extracted time is wrong we'll present the recording at the wrong time and users won't be happy with our football hotline service.

It turns out that we actually overlooked a small detail... we need to know what team the user selected as well, so we can schedule the recording at the correct time for the correct team. Probably need an eval for that as well.

Operating the call for a few weeks like this, we started to experience problems:

◊ol{
  ◊li{Misinterpretations of the time and the team from what the user actually selected.}
  ◊li{Evals non-deterministically failing with false positives and false negatives.}
  ◊li{Pure hallucinations around the user's preferences. For some reason the model interpretted the user's preference as England when no such team was selected.}
  ◊li{Randomly interpretting the result as "no time selected" if a user said they were super busy at the end of the call, even though they actually wanted to watch the game and in the conversation had already agreed upon a time; misinterpretation of intent.}
}

And thus we enterered a frustrating period of whack-a-mole, made worse by the fact that we did not feel we could trust our evals. Before long we were back to reading transcripts...

◊h3{Seeing the Forrest for the Trees}

Now going back to our pseudocode, consider the system we'd built:

◊code-block{
    # Original Call
    let transcripts = call(agent, patient)

    # Extract Time and Team
    let time_to_schedule_recording = extract_time(transcript)
    let team = extract_team(transcript)

    # Schedule Recording
    schedule_recording(team, time_to_schedule_recording)

    # Run Evals to verify the recording was scheduled correctly
    let evals = [ "team_extract_correctly", "time_extract_correctly"]
    run_evals(evals)
}

Running through this, we realized that every single time we relied on a model for interpretation, we were introducing non-determinism into our system. And that in itself wasn't necesarily an issue, it was the fact that we completely relied on the model to interpret the user's intent in order for the system to function as intended.

Yet this was hardly realistic... right? Consider the above but annotated with the potential failures.

◊ol{
  ◊li{Original call: most discuss team preference and time with the user}
  ◊li{Recording time extraction: re-interprets the user's intent to extract the recording time}
  ◊li{Team preference extraction: re-interprets the user's intent to extract the team preference}
  ◊li{Recording time eval: re-interprets the model's output to verify the recording was scheduled correctly}
  ◊li{Team preference eval: re-interprets the model's output to verify the team preference was extracted correctly}
}

Each of these can go wrong. Let's now re-organize the non-determinism points based on "stage".


◊ol{
  ◊li{Call: 3x points of non-determinism, original call and 2x extractions. All must be right for correctness.}
  ◊li{Evals: 2x re-interpretations of call result. All must be right for confidence.}
}

Let's just say, in order to assign some numbers, correctness looks like:

◊code-block{
    original_call = 99.9%
    extraction_of_time = 98%
    extraction_of_team = 99.3%
    odds_of_correct_call = 99.9 * 98 * 99.3 = 97.2%

    recording_time_eval = 97%
    team_preference_eval = 99%
    odds_of_correct_evals = 97 * 99 = 96.0%

    odds_of_total_correctnes = 97.2 * 96.0 = 93.3%
}

So in this case, the model is correct 93.3% of the time, or for the 2,000 calls we make a week, 133 will be either incorrect or the evals will be false positives/negatives. That is untenable. Not only will your users lose confidence in your feature, but your internal ops team will lose faith in the evals.

And this, for all intent and purposes, is a pretty simple example.

◊h3{Stop Re-Interpreting}

A critical insight is that within the call we have two things at the time of scheduling the recording: (1) we have interpretted the time and (2) we have the ability to go back and forth with the user, live in case of booking failure or the need to adjust. Thus, if we give the agent a tool, we can take advantage of those two things to fundamentally stop re-interpreting.

Furthermore, since we control the tool to schedule, we can put safety guards there, ensuring the booked time and booked team are both valid.

Thus, we can actually drammatically simplify the non-determinism creep! And honestly we don't need these specific evals anymore as we can trust the tool to schedule correctly (within reason).

◊code-block{
    original_call = 99.9%

    odds_of_total_correctnes = 99.9%
}

In the context of the 2,000 call volume, we now expect only 2 incorrect calls per week! Now we're starting to talk about a reasonably reliable system.

◊h3{A Framework for Tolerance}
