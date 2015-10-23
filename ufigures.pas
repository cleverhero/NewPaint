unit UFigures;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Math, UTransformation;

type
  TFigure = Class
    SizePen:Integer;
    Color:TColor;
    Points:array of DoublePoint;
    procedure Draw(Canvas:TCanvas); virtual;abstract;
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
procedure TPen.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Width:=SizePen;
  Canvas.Pen.Color:=Color;
  for i:=0 to High(Points)-1 do begin
    Canvas.Line(WorldToScreen(Points[i]),WorldToScreen(Points[i+1]));
  end;
end;

procedure TLine.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  Canvas.Line(WorldToScreen(Points[0]),WorldToScreen(Points[1]));
end;


procedure TPolyLine.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  for i:=0 to High(Points)-1 do begin
    Canvas.Line(WorldToScreen(Points[i]),WorldToScreen(Points[i+1]));
  end;
end;

procedure TRoundRect.Draw(Canvas:TCanvas);
var
  i:integer;
  x1,y1,x2,y2:integer;
  a:DoublePoint;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  a.x:=min(Points[0].x,Points[1].x);
  a.y:=min(Points[0].y,Points[1].y);
  x1:=WorldToScreen(a).x;
  y1:=WorldToScreen(a).y;
  a.x:=max(Points[0].x,Points[1].x);
  a.y:=max(Points[0].y,Points[1].y);
  x2:=WorldToScreen(a).x;
  y2:=WorldToScreen(a).y;
  Canvas.RoundRect(x1,y1,x2,y2,15,15);
end;

procedure TRect.Draw(Canvas:TCanvas);
var
  i:integer;
  x1,y1,x2,y2:integer;
  a:DoublePoint;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  a.x:=min(Points[0].x,Points[1].x);
  a.y:=min(Points[0].y,Points[1].y);
  x1:=WorldToScreen(a).x;
  y1:=WorldToScreen(a).y;
  a.x:=max(Points[0].x,Points[1].x);
  a.y:=max(Points[0].y,Points[1].y);
  x2:=WorldToScreen(a).x;
  y2:=WorldToScreen(a).y;
  Canvas.Rectangle(x1,y1,x2,y2);
end;

procedure TEllipse.Draw(Canvas:TCanvas);
var
  i:integer;
  x1,y1,x2,y2:integer;
  a:DoublePoint;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  a.x:=min(Points[0].x,Points[1].x);
  a.y:=min(Points[0].y,Points[1].y);
  x1:=WorldToScreen(a).x;
  y1:=WorldToScreen(a).y;
  a.x:=max(Points[0].x,Points[1].x);
  a.y:=max(Points[0].y,Points[1].y);
  x2:=WorldToScreen(a).x;
  y2:=WorldToScreen(a).y;
  Canvas.Ellipse(x1,y1,x2,y2);
end;

end.

