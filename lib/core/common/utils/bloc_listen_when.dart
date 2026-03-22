// Helpers for BlocListener.listenWhen / BlocConsumer.listenWhen so success/error
// toasts and one-shot navigation do not repeat on every rebuild while the bloc remains
// on the same terminal state.

/// Only invoke the listener when [isTerminal] becomes true (was false on [previous]).
bool listenWhenEnteringTerminal<S>(
  S previous,
  S current,
  bool Function(S state) isTerminal,
) {
  if (isTerminal(current)) return !isTerminal(previous);
  return true;
}
