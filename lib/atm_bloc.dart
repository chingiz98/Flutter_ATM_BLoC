import 'package:bloc/bloc.dart';
import 'package:flutterapptest/atm_event.dart';
import 'package:flutterapptest/atm_state.dart';
import 'dart:math';

class AtmBloc extends Bloc<AtmEvent, AtmState> {
  AtmBloc() : super(AtmState.initial());

  void onWithdraw(double amount){
    add(WithdrawEvent(amount));
  }

  Map<int, int> withdraw (int amount, Map<int, int> limits){
    Map<int, int> getMoney(int amount, List<int> nominals){
      if (amount == 0) return {}; // successfully found solution
      if (nominals.length == 0) return null; // can't find solution
      int nominal = nominals[0];
      var count = min<int>(limits[nominal],  (amount / nominal).floor());
      for(int i = count; i >= 0; i--){
        var result = getMoney(amount - i*nominal, nominals.sublist(1));
        if(result != null){
          if(i > 0){
            result[nominal] = i;
          }
          return result;
        }
      }
    }

    Map<int,int> result = getMoney(amount, limits.keys.toList());
    print(result);
    return result;
  }

  @override
  Stream<AtmState> mapEventToState(AtmEvent event) async* {
    if (event is WithdrawEvent){
      if(event.amount % 1 != 0){
        yield AtmState(limits: state.limits, currentOutput: null);
        return;
      }

      Map<int,int> output = withdraw(event.amount.toInt(), state.limits);
      Map<int, int> newLimits = state.limits;
      if(output != null){
        output.keys.toList().forEach((nominal) {
          newLimits[nominal] -= output[nominal];
        });
      }
      yield AtmState(limits: newLimits, currentOutput: output);
    }
  }
}