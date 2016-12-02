---
title: Beyond Queues
summary: Notes on Nitsan Wakart's talk: 'Beyond Queues: Novel Concurrent Message Passing Techniques'
---

Nitsan blogs at [http://psy-lob-saw.blogspot.co.uk/](http://psy-lob-saw.blogspot.co.uk/), mostly on JVM-related performance issues.

He works on the Zing JVM by Azul Systems.

## Intro

The introduction mentioned LMAX, with a shoutout to Mike Barker :)

We did a fair bit of collaboration with Azul when we started using Zing at LMAX.

He also mentioned Azul's new ReadyNow tech in Zing - it persists JVM profiling information so that warmup and JIT compilation pauses are greatly reduced when restarting.

The talk is on 'novel' message passing techniques - by which he seems to mean an overview of the best high performance queues on the JVM at the moment.

He mentions the [Universal Scalability Law](http://www.perfdynamics.com/Manifesto/USLscalability.html) and says he's not going to be talking about scaling much.

### JDK queues

The JDK provides threads, blocking queues, lockless queues, thread pools/executors... lots of message-passing techniques and primitives.

But generally they are not suitable for low latency or high throughput applications.

They generate lots of garbage. Even array-backed queues generate garbage via the linked list used for the lock.

## JCTools Queues

These are used in [Netty](http://netty.io/) core, so they are fairly widely distributed.

All queues are bounded. If you need an unbounded queue you should rethink your design and apply backpressure. It's better to make backpressure explicit than to silently take ages to process a message while it makes its way to the front of an unbounded queue.

Be explicit about the acceptable wait time.

JCTools has specialised classes for different use cases.

- Single Producer, Single Consumer - fastest
- Multi Producer, Single Consumer - controls access to a shared resource
- Single Producer, Multi Consumer - fanout (not multiplexed)
- Multi Producer, Multi Consumer

There are some interesting benchmarks.
MPMC beats MPSC in certain thread configurations as contention is reduced by consistently pairing consumer and producer threads.

To reduce contention, JCTools queues provide a `relaxedPoll()`/`relaxedOffer()` api in addition to the usual.

These provide no full/empty guarantees: `false` returned from `relaxedOffer()` doesn't imply the queue was full.

JCTools also provides batch drain/fill operations, which claim chunks of the queue at once.

Access to the middle of a queue makes good performance harder. Note that JDK queues are also Collections.

Should you use it? yes...

- if queues are a bottleneck
- if garbage is a concern
- if produce/consumer counts are known in advance

These queues do reference passing: the reference is changing ownership when consumed from the queue.

Some event garbage is inevitable with this design, since the queues only pass references not heap memory.

Queues must establish a 'happens-before' relationship to be useful - you don't want your consumer to take a message reference but not see the producer's updates to the message it points to.

Non-blocking queues can always be converted to blocking queues by adding a wait strategy.

JCTools uses code generation for this.

Different wait strategies:

- spinning
- yielding
- sleeping (sometimes worse, sometimes better than yielding)
- waiting on a lock

You have to chain queues manually to build meaningful workflows.

## LMAX Disruptor

The disruptor was well known for a while, especially in finance, but based on the audience response is not all that widely used.

The first JVM design of the Disruptor was built about 6 years ago (so 2010).

One of the first significant pieces of open-sourced finance tech.

There are many finance people in the audience - most use open source code but do not contribute to open source projects. Not very surprising, unfortunately.

The Disruptor is not a queue.

It has single or multiple producers multicasting to single or multiple consumers.

Consumers can be linearised or run in parallel.

Events are preallocated, which typically gives good memory locality on the heap. This also implies a single event type, known in advance.

You should avoid storing reference data in events, since this memory will leak until the first oldgen collection after the writer next reuses the event.

Wait strategies are pluggable.

Entries are owned by the ringbuffer, not by the producer or consumer.
Entries are leased in order to write or read them.
Sometimes you might want multiple readers on the same entry; this is fine.

The Disruptor is for applications with well defined pipelines.

### Producing

- claim an event slot
- mutate fields in that event
- publish the sequence number of the slot

### Consuming

- you get called by a Disruptor consumer thread
- on return, the event is released to the next stages
- end-of-batch flag is provided to allow easy batch control in consumer code
- but, best to use another batch indicator as well since Disruptor batches might be too big
- it would be nice if the Disruptor didn't wait until end-of-batch to release events to the next stage - this is configurable but the default is not so helpful

### LMAX use case

- single writer puts reliable UDP messages coming in from socket buffer
- readers journal messages to disk and replicate them to a remote node in parallel
- once both reliability readers are done, another reader performs business logic and local state change
- the replay handler can use stale messages if some downstream app gets behind

## Aeron IPC

Aeron is not widely used, it hasn't yet reached version 1.0 (whatever that means) - but close.

It's a very high performance option - it beats pretty much everything handling the same use cases that it has been compared to.

Aeron as a whole includes a protocol layer (reliable UDP, built by the same folks who originally did Latency Busters Messaging, which became Informatica's Ultra Messaging).

Passes information across thread/process/language boundaries.

'Really great algorithm'. Bounded, but no compare-and-swap used.

No reference passing since it's all off-heap.

Publishing just sends a bunch of bytes, wrapped in the Aeron protocol.

You can also do zero-copy publishing by claiming a byte buffer.

Subscribing - your FragmentHandler polls for fragments, and reassembles them into messages.

Then layer a flyweight on top to get pleasant access to your message bytes.

Has dead publisher detection.

Aeron doesn't provide a dsl for pipeline definition like the Disruptor does.

The event contents are leased between threads - the events themselves are not represented in Aeron, so there's no reference chasing.

Should you use it?

- if you need reliable UDP (probably the first decent open-source implementation)
- if you need low latency
- if you need to pass information between processes or languages
- if you need to multicast to subscribers

There's nothing faster for MPMC multicast UDP.

## Pie in the sky: JCTools Proxy Channels

This is Nitsan's sales pitch, he warns us it's not production ready yet.

- async method calls on a defined interface
- to avoid garbage and so on, generate a custom transport layer for the interface
- an efficient way to pass binary and reference data to the consumer so a consumer can invoke on the target
- works for primitive args but not yet for references (it turns out that serialising references off-heap doesn't play well with JVM GCs)

Transfers call frame contents between threads.

