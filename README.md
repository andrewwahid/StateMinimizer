
# State Minimizer

Minimize states in a state machine using Implication Table method.

## Theory

An implication table is a tool used to facilitate the minimization of states in a state machine. The concept is to start assuming that every state may be able to combine with every other state, then eliminate combinations that are not possible. When all the impossible combinations have been eliminated, the remaining state combinations are valid, and thus can be combined.

The procedure is as follows:

- List state-combination possibilities in an implication table,
- Eliminate combinations that are impossible because the states produce different outputs,
- Eliminate combinations that are impossible because the combination depends on the equivalence of a previously eliminated possibility,
- Repeat the above step until no more eliminations are possible. 

You can read more about implication table method [here](https://web.eece.maine.edu/eason/ece275/StateMinimization.pdf)

## Demo

You can try it yourself [here](https://state-minimizer.surge.sh)
