unit UFigures;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Math;

type
  TFigure = Class
    SizePen:Integer;
    Color:TColor;
    Points:array of TPoint;
    Point1,Point2:TPoint;
    procedure Draw(Canvas:TCanvas); virtual;
  end;

  TPen = Class(TFigure)
   procedure Draw(Canvas:TCanvas); override;
  end;


  TLine = Class(TFigure)
    procedure Draw(Canvas:TCanvas); override;
  end;


  TPolyLine = Class(TFigure)
    procedure Draw(Canvas:TCanvas); override;
  end;


  TRect = Class(TFigure)
    procedure Draw(Canvas:TCanvas); override;
  end;


  TEllipse = Class(TFigure)
    procedure Draw(Canvas:TCanvas); override;
  end;



  TRoundRect = Class(TFigure)
    procedure Draw(Canvas:TCanvas); override;
  end;

var
  Figures:array of TFigure;

implementation
procedure TFigure.Draw(Canvas:TCanvas);
begin
end;


procedure TPen.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Width:=SizePen;
  Canvas.Pen.Color:=Color;
  for i:=0 to High(Points)-1 do begin
    Canvas.Line(Points[i],Points[i+1]);
  end;
end;

procedure TLine.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  Canvas.Line(Point1,Point2);
end;


procedure TPolyLine.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  for i:=0 to High(Points)-1 do begin
    Canvas.Line(Points[i],Points[i+1]);
  end;
end;

procedure TRoundRect.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  Canvas.RoundRect(min(Point1.x,Point2.x),min(Point1.y,Point2.y),max(Point1.x,Point2.x),max(Point1.y,Point2.y),15,15);
end;

procedure TRect.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  Canvas.Rectangle(min(Point1.x,Point2.x),min(Point1.y,Point2.y),max(Point1.x,Point2.x),max(Point1.y,Point2.y));
end;

procedure TEllipse.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  Canvas.Ellipse(min(Point1.x,Point2.x),min(Point1.y,Point2.y),max(Point1.x,Point2.x),max(Point1.y,Point2.y));
end;

end.

