type Economic
  extends Modelica.Units.SI;
  type Money = Real(final quantity = "Money", final unit = "dolar");
  type Quantity = Real(final quantity = "Quantity", final unit = "1");
  type Price = Real(final quantity = "Price", final unit = "dolar");

  connector EcPin
    Economic.Price P (start=0) "preço na conexão";
    flow Economic.Quantity Q (start=0)"quantidade que passa na conexão";
    annotation(
      defaultComponentName = "EcPin",
      Icon(graphics = {Ellipse(origin = {1, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-19, 20}, {19, -20}})}),
      Documentation(revisions = "<html>
<ul>
<li><em> 2023   </em>
       by Elcio Deccache<br> initially implemented<br>
       </li>
</ul>
</html>", info = "<html>
<p>EcPin é o conector econômico básico.Suas grandezas básicas são Preço e Quantidade. </p>
</html>"));
  end EcPin;

  model OneEnd
    //extends EcPin;
    //MyUnits.Price Pr;
    //MyUnits.Quantity Qt;
    Economic.EcPin Conect annotation(
      Placement(visible = true, transformation(origin = {4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
//Pr = Conect.P;
//Qt = Conect.Q;
    annotation(
      Icon(graphics = {Rectangle(origin = {0, 1}, lineColor = {255, 0, 0}, fillColor = {85, 255, 0}, extent = {{-60, 61}, {60, -61}})}));
  end OneEnd;

block FixedSeller
  extends Economic.OneEnd;
  parameter Economic.Price Pr = 2;
  equation
  Conect.P = Pr;
  annotation(
    Icon(graphics = {Text(origin = {4, -78}, extent = {{-66, 14}, {66, -14}}, textString = "%name"), Text(origin = {0, 74}, extent = {{-64, 14}, {64, -14}}, textString = "Seller"), Text(origin = {-15, 2}, extent = {{-51, 18}, {51, -18}}, textString = "%P"), Rectangle(origin = {0, 1}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{60, 61}, {-60, -61}})}),
    Documentation(revisions = "<html>
<ul>
<li><em> 2023   </em>
     by Elcio Deccache<br> initially implemented<br>
     </li>
</ul>
</html>", info = "<html>
<p>Seller model that provides goods at a constant price. It can also be used as a constant price buyer. The quantity of the good will be defined by the rest of the model.</p>

</html>"));
end FixedSeller;

block FixedBuyer
    parameter Economic.Quantity Qt "Quantidade comprada";
    extends Economic.OneEnd;
  equation
    Conect.Q = Qt;
    annotation(
      Icon(graphics = {Text(origin = {-5, -80}, extent = {{-55, 12}, {55, -12}}, textString = "%name"), Text(origin = {-2, 77}, extent = {{-60, 11}, {60, -11}}, textString = "Buyer"), Rectangle(origin = {0, 1}, lineColor = {255, 170, 0}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{60, 61}, {-60, -61}})}),    Documentation(revisions = "<html>
  <ul>
  <li><em> 2023   </em>
       by Elcio Deccache<br> initially implemented<br>
       </li>
  </ul>
  </html>", info = "<html>
  <p>Buyer model that provides a fixed quantity of goods. It can also be used as a buyer when the quantity of goods is negative. The price of the good will be defined by the remainder of the model.</p>
  
  </html>"));
  end FixedBuyer;

block BuyerVar
    extends Economic.OneEnd;
    parameter Real QtCoef = 1 "Coefeiciente para quantidades";
    parameter Real PrCoef = 1 "Coeficiente para peços";
    parameter Real Total = 2 "Total da combinação";
  equation
    Conect.Q*QtCoef + Conect.P*PrCoef - Total = 0;
    annotation(
      Icon(graphics = {Rectangle(origin = {0, 1}, lineColor = {0, 255, 0}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, extent = {{60, 61}, {-60, -61}}), Text(origin = {1, 76}, extent = {{-49, 12}, {49, -12}}, textString = "BuyerVar"), Text(origin = {-1, -69}, extent = {{-67, 11}, {67, -11}}, textString = "%name")}),
      Documentation(revisions = "<html>
<ul>
<li><em> 2023   </em>
       by Elcio Deccache<br> initially implemented<br>
       </li>
</ul>
</html>", info = "<html>
<p>Buyer model that provides a constant quantity of goods. With negative values it can be used as a vendor model for a constant quantity. The price of the good will be defined by the remainder of the model..</p>

</html>"));
  end BuyerVar;

  block StepQt
    extends Economic.OneEnd;
    parameter Time StartTime = 0 "Tempo de início do pulso";
    parameter Time EndTime = 1 "Tempo de fim do pulso";
    parameter Quantity offSet = 0 "Deslocamento do pulso";
    parameter Quantity Pulse = 1 "Amplitudo do pulso";
  equation
    Conect.Q = offSet + (if ((time > StartTime) and (time < EndTime)) then Pulse else 0);
    annotation(
      Icon(graphics = {Text(origin = {0, 1}, extent = {{-46, 47}, {46, -47}}, textString = "Q")}),     Documentation(revisions = "<html>
  <ul>
  <li><em> 2023   </em>
       by Elcio Deccache<br> initially implemented<br>
       </li>
  </ul>
  </html>", info = "<html>
  <p>This is a step function for quantity. It can be used to model abrupt changes in the market, such as a drop in production or a sudden demand.</p>
  
  </html>"));
  end StepQt;

block Fabric
  Economic.EcPin Raw annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.EcPin Product annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Clocked.ClockSignals.Clocks.PeriodicExactClock periodicClock1(factor = 1) annotation(
    Placement(visible = true, transformation(origin = {-22, -74}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Clocked.RealSignals.Sampler.SampleClocked sample1 annotation(
    Placement(visible = true, transformation(origin = {0, -28}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Clocked.RealSignals.NonPeriodic.FractionalDelay fractionalDelay(shift = ClockDelay) annotation(
    Placement(visible = true, transformation(origin = {32, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Parâmetros de produção
  parameter Integer ClockDelay = 1;
  parameter Real Formule = 1 "Relação entre as quantidades de matéria prima e produto Qpr/Qr";
  Economic.EcPin QtControl annotation(
    Placement(visible = true, transformation(origin = {0, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Raw.P = Product.P*Formule;
  Raw.Q = -QtControl.Q;
  connect(periodicClock1.y, sample1.clock) annotation(
    Line(points = {{-16, -74}, {0, -74}, {0, -36}}, color = {175, 175, 175}));
  sample1.u = QtControl.Q;
  Product.Q = fractionalDelay.y*Formule;
  QtControl.P = Product.P/Formule;
  Product.P = Raw.P*Formule;
  connect(fractionalDelay.u, sample1.y) annotation(
    Line(points = {{20, -28}, {6, -28}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(origin = {0, -27}, extent = {{-80, 67}, {80, -67}}), Line(origin = {-0.207107, 59.6464}, points = {{-79.7929, -19.6464}, {-39.7929, 20.3536}, {-39.7929, -19.6464}, {0.207107, 20.3536}, {0.207107, -19.6464}, {40.2071, 20.3536}, {40.2071, -19.6464}, {80.2071, 20.3536}, {80.2071, -19.6464}, {80.2071, -19.6464}}), Text(origin = {4, -83}, extent = {{-72, 11}, {72, -11}}, textString = "%name")}),    Documentation(revisions = "<html>
<ul>
<li><em> 2023   </em>
     by Elcio Deccache<br> initially implemented<br>
     </li>
</ul>
</html>", info = "<html>
<p>This is an element that represents transformation in a manufacturing process. It can modify the composition of the product (and adjust the price) and includes the delay corresponding to the transformation process. The quantity to be produced must be entered in the quantity information port and may vary over time.</p>

</html>"));
end Fabric;

  model Stock
    import Modelica.Math.*;
    EcPin Input annotation(
      Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    EcPin Output annotation(
      Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Real Estoque(start = 0.2);
    Real Aux(start = 0);
    Boolean est(start = true);
    parameter Real Step = 0.001;
  equation
//Input.P=Output.P;
    if est then
      Input.P = Output.P;
    else
      Input.Q = -Output.Q;
    end if;
    Aux = if est then Output.Q + Input.Q else 0;

    (Estoque - delay(Estoque, Step))/Step = Aux;
  algorithm
    if ((delay(Estoque, Step) < 0) and (Input.Q + Output.Q < 0)) then
      est := false;
    else
      est := true;
    end if;

    annotation(
      Diagram,
      Icon(graphics = {Ellipse(origin = {0, 1}, extent = {{-80, 81}, {80, -81}}), Text(extent = {{-16, 12}, {-16, 12}}, textString = "S"), Text(origin = {0, 3}, extent = {{-24, 27}, {24, -27}}, textString = "S")}),
      Documentation(revisions = "<html>
  <ul>
  <li><em> 2023   </em>
       by Elcio Deccache<br> initially implemented<br>
       </li>
  </ul>
  </html>", info = "<html>
  <p>This is a stock model that allows the quantity produced to be adjusted with the quantity sold. If parts are missing, those in storage can be used. If stock runs out, only the pieces that are produced can be sold.</p>
  
  </html>"));
  end Stock;

  type QuantTime = Real(final quantity = "Quantity*Time", final unit = "s");

block Tax
  //import Modelica.Math.*;
  parameter Real ICMSRate = 18;
  parameter Real CSLLRate = 15;
  parameter Real ISSRate = 0;
  EcPin Input annotation(
    Placement(visible = true, transformation(origin = {-98, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  EcPin Output annotation(
    Placement(visible = true, transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.Earn ICMSEarn annotation(
    Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-42, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.Earn CSLLEarn annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {4, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Economic.Earn ISSEarn annotation(
    Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
   Money ICMSAux(start = 0);
   Money CSLLAux(start = 0);
   Money ISSAux(start = 0);
   
  parameter Real TotalRate = ICMSRate + CSLLRate + ISSRate;
  parameter Real AuxRate = 1/(1 - (TotalRate/100));
equation
//relações de entrada e saída.
  Input.Q + Output.Q = 0;
  Output.P = Input.P*AuxRate;
// Cálculo de impostos
  der(ICMSAux) = if ((Output.P*Output.Q > 0)) then ((Output.Q)*(Output.P)*(ICMSRate)/100) else 0;
  
  der(CSLLAux) = if ((Output.P*Output.Q > 0)) then ((Output.Q)*(Output.P)*(CSLLRate)/100) else 0;
  
  der(ISSAux) = if ((Output.P*Output.Q > 0)) then ((Output.Q)*(Output.P)*(ISSRate)/100) else 0;  
  
    ICMSEarn.Earns = -1*ICMSAux;
    CSLLEarn.Earns = -1*CSLLAux;
    ISSEarn.Earns = -1*ISSAux;

 
  annotation(
    Diagram(graphics = {Rectangle(origin = {0, 6}, fillPattern = FillPattern.Solid, extent = {{-40, -30}, {40, 30}}), Line(origin = {0, -24}, points = {{-60, 0}, {60, 0}, {60, 0}}, thickness = 1.5)}),
    Icon(graphics = {Rectangle(origin = {-1, 20}, fillPattern = FillPattern.Solid, extent = {{-41, -40}, {41, 40}}), Line(origin = {-0.5, -20}, points = {{-59.5, 0}, {60.5, 0}, {50.5, 0}}, thickness = 3)}),
    Documentation(revisions = "<html>
<ul>
<li><em> 2023   </em>
     by Elcio Deccache<br> initially implemented<br>
     </li>
</ul>
</html>", info = "<html>
<p>This element is to model the effects of taxes. It has parameters for federal, state and municipal tax rates. It also has output for tax values at the three levels.</p>

</html>"));
end Tax;

  connector Earn
    //Money fix;
     Money Earns(start=0);
  equation

    annotation(
      Diagram(graphics = {Ellipse(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}})}),
      Icon(graphics = {Ellipse(origin = {-3, -1}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}})}));
  end Earn;

block Interest
  parameter Real InterestRate = 0.01;
  parameter Real Capital = 5000;
  EcPin Input annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  EcPin Output annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Earn Juros annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Real Idle(start=0);
  equation
    Input.Q = Output.Q;
    Output.P = Input.P+ (InterestRate*Capital)/Input.Q;
    der(Idle) = InterestRate*Capital;

    Juros.Earns= -1*Idle;
   
    annotation(
    Icon(graphics = {Text(origin = {-1, 2}, extent = {{-49, -41}, {49, 41}}, textString = "%"), Rectangle(extent = {{-100, 100}, {100, -100}})}),
    Documentation(revisions = "<html>
<ul>
<li><em> 2023   </em>
     by Elcio Deccache<br> initially implemented<br>
     </li>
</ul>
</html>", info = "<html>
<p>This element models the impact of the cost of capital on the cost of production.</p>

</html>"));
end Interest;


block Interest_Box
Earn earn annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Real Treasure;
equation
    der(Treasure) = earn.Earns; 
annotation(
    Diagram,
    Icon(graphics = {Rectangle(extent = {{-100, -100}, {100, 100}}), Rectangle(extent = {{-80, -80}, {80, 80}}), Text(origin = {1, 1}, extent = {{-63, -47}, {63, 47}}, textString = "%$")}));

end Interest_Box;
  annotation(
    uses(Modelica(version = "4.0.0")));
end Economic;
