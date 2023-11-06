model ExemploFabril1
  Economic.FixedSeller SugarCane1(Pr = 1.8)  annotation(
    Placement(visible = true, transformation(origin = {-74, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.Fabric Fabric1(ClockDelay = 1, Formule = 5)  annotation(
    Placement(visible = true, transformation(origin = {-32, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.Interest interest annotation(
    Placement(visible = true, transformation(origin = {-4, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.Tax tax1 annotation(
    Placement(visible = true, transformation(origin = {44, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.Stock stock1(Estoque(fixed = true, start = 500))  annotation(
    Placement(visible = true, transformation(origin = {22, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.StepQt Quantity1(EndTime = 0.7, Pulse = -2000, StartTime = 0.5, offSet = 3000)  annotation(
    Placement(visible = true, transformation(origin = {-24, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.BuyerVar SugarMerket1(QtCoef = 10, Total = 100000)  annotation(
    Placement(visible = true, transformation(origin = {86, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Fabric1.Raw, SugarCane1.Conect) annotation(
    Line(points = {{-40, 56}, {-54, 56}, {-54, 66}, {-80, 66}, {-80, 60}}));
  connect(Fabric1.Product, interest.Input) annotation(
    Line(points = {{-24, 56}, {-14, 56}}));
  connect(stock1.Output, tax1.Input) annotation(
    Line(points = {{30, 58}, {34, 58}, {34, 54}}));
  connect(stock1.Input, interest.Output) annotation(
    Line(points = {{14, 58}, {6, 58}, {6, 56}}));
  connect(Fabric1.QtControl, Quantity1.Conect) annotation(
    Line(points = {{-32, 46}, {-30, 46}, {-30, 32}}));
  connect(tax1.Output, SugarMerket1.Conect) annotation(
    Line(points = {{54, 54}, {80, 54}, {80, 60}}));
end ExemploFabril1;
