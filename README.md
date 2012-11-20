Planned work
============

Smarter setup script
--------------------

The range of appropriate values for `[THAT ONE FILE]` differs by computer. On mine, it's 0-7. Since the core of this script is `[THAT ONE FUNCTION]` and it accepts values as percentages, the most useful `interval` setting in `config.cfg` is going to reflect the ratio of 0-100 to the smaller range (0-7 in my case).

Otherwise, as you increment/decrement you're going to hit useless values - i.e. two consecutive percentage-values that map to the same value in the smaller range. For example, on my computer 12 is the best interval (each increment/decrement results in an actual change in brightness).

I would like the setup script to extract the expected range from `[THAT ONE FILE, ABOVE]`, and then adjust `interval` in `config.cfg` accordingly.

