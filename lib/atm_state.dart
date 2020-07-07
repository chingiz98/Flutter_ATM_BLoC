class AtmState {

  final Map<int, int> limits;
  final Map<int, int> currentOutput;

  const AtmState({this.limits, this.currentOutput});

  factory AtmState.initial() => AtmState(limits: { 5000: 5, 2000: 10, 1000: 10, 500: 20, 200: 20, 100: 50 }, currentOutput: {});
}