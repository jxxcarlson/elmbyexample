TimeSeries
==========

Directions:

1. Do `chmod u+x dataServer.py` to make the data server
   executable.  Then run `./dataServer.py 8000`

2. Run `elm make TimeSeries.elm`. Then open `index.html`

3. Click on `Get Data`

When you did this, the request "/data=100" was sent
to http://localhost:800. That server generated a sequence
of integers by doing a random walk: start with zero, then
repeatedly add random elements of {+1, -1}.

The server can be modified to generate other "time series."

The main idea is demonstrate the producer-consumer relation
between a generator of data and a visualizer for it.
