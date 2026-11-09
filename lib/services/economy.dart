class Economy {
  double treasury = 12000;
  double debt = 0;
  double grainPrice = 12;
  int deficitMonths = 0;

  void monthlyUpdate(double revenue, double expenses) {
    double net = revenue - expenses;
    treasury += net;
    if (net < 0) deficitMonths++; else deficitMonths = 0;
    if (treasury < 0) { debt += -treasury + 500; treasury = 200; }
    debt += debt * 0.04;
    if (deficitMonths >= 3) { grainPrice += 3; }
  }
}
