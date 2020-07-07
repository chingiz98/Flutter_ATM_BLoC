abstract class AtmEvent {}

class WithdrawEvent extends AtmEvent {
  final double amount;
  WithdrawEvent(this.amount);
}