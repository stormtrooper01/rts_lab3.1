import 'dart:math';

List<int> fermatDecomposition(Map<String, int> map){
  int decompositionNumber = map["decompositionNumber"];
  int maxSteps = map["steps"];
  int currentStep = 0;
  int x = sqrt(decompositionNumber).toInt();

  double res;
  int resSqrt;
  do {
    if(currentStep == maxSteps) {
      return null;
    }
    x++;
    currentStep++;
    res = pow(x, 2) - decompositionNumber.toDouble();
    resSqrt = sqrt(res).toInt();
  }while(pow(resSqrt, 2) != res);

  int y = sqrt(pow(x, 2) - decompositionNumber).toInt();
  int p = x - y;
  int q = x + y;
  List<int> array = [p, q, currentStep];
  return array;
}
