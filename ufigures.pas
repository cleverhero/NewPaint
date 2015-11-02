unit UFigures;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Math, UTransformation;

type
  TFigure = Class
    SizePen:Integer;
    Color:TColor;
    Points:array of TDoublePoint;
    constructor Create(AColor:TColor;AWidth:integer);
    procedure Draw(Canvas:TCanvas); virtual;abstract;
  end;

  TFigureClass = class of TFigure;

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

  procedure AddFigure(TypeFigure:TFigureClass;AColor:TColor;AWidth:integer);
  procedure AddPoint(x,y:integer);
  procedure ReplaceLastPoint(x,y:integer);
  procedure ReplaceLastPoint(x,y,kx,ky:integer);
  procedure check;

var
  Figures:array of TFigure;

implementation
constructor TFigure.Create(AColor:TColor;AWidth:integer);
begin
  inherited Create;
  Color:=AColor;
  SizePen:=AWidth;
end;

procedure AddFigure(TypeFigure:TFigureClass;AColor:TColor;AWidth:integer);
begin
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TypeFigure.Create(AColor,AWidth);
end;

procedure AddPoint(x,y:integer);
begin
  with Figures[High(Figures)] do begin
    SetLength(Points,Length(Points)+1);
    Points[high(Points)]:=Screen.ScreenToWorld(Point(x,y));
  end;
end;

procedure check;
var
  i:integer;
begin
  with Figures[High(Figures)] do
    with Screen do
      if (high(Figures)=0) and(High(Points)>=0) then begin
        minScreen.x:=Points[0].x;
        minScreen.y:=Points[0].y;
        maxScreen.x:=Points[0].x;
        maxScreen.y:=Points[0].y;
      end;
  with Figures[High(Figures)] do
    with Screen do
      for i:=0 to high(Points) do begin
        minScreen.x:=min(Points[i].x,minScreen.x);
        minScreen.y:=min(Points[i].y,minScreen.y);
        maxScreen.x:=max(Points[i].x,maxScreen.x);
        maxScreen.y:=max(Points[i].y,maxScreen.y);
      end;
end;

procedure ReplaceLastPoint(x,y,kx,ky:integer);
begin
  with Figures[High(Figures)] do begin
    Points[high(Points)]:=Screen.ScreenToWorld(Point(x,y));
    Points[1].y:=Points[0].y+
      sign((Points[0].y-Points[1].y)*(Points[0].x-Points[1].x))*
      (Points[1].x-Points[0].x)*ky/kx;
  end;
end;

procedure ReplaceLastPoint(x,y:integer);
begin
  with Figures[High(Figures)] do begin
    Points[high(Points)]:=Screen.ScreenToWorld(Point(x,y));
  end;
end;

procedure TPen.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Width:=SizePen;
  Canvas.Pen.Color:=Color;
  for i:=0 to High(Points)-1 do begin
    Canvas.Line(Screen.WorldToScreen(Points[i]),Screen.WorldToScreen(Points[i+1]));
  end;
end;

procedure TLine.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  with Screen do
    Canvas.Line(WorldToScreen(Points[0]),WorldToScreen(Points[1]));
end;


procedure TPolyLine.Draw(Canvas:TCanvas);
var
  i:integer;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  with Screen do
    for i:=0 to High(Points)-1 do
      Canvas.Line(WorldToScreen(Points[i]),WorldToScreen(Points[i+1]));
end;

procedure TRoundRect.Draw(Canvas:TCanvas);
var
  i:integer;
  x1,y1,x2,y2:integer;
  a:TDoublePoint;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  with Screen do begin
    a.x:=min(Points[0].x,Points[1].x);
    a.y:=min(Points[0].y,Points[1].y);
    x1:=WorldToScreen(a).x;
    y1:=WorldToScreen(a).y;
    a.x:=max(Points[0].x,Points[1].x);
    a.y:=max(Points[0].y,Points[1].y);
    x2:=WorldToScreen(a).x;
    y2:=WorldToScreen(a).y;
  end;
  Canvas.RoundRect(x1,y1,x2,y2,15,15);
end;

procedure TRect.Draw(Canvas:TCanvas);
var
  i:integer;
  x1,y1,x2,y2:integer;
  a:TDoublePoint;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  with Screen do begin
    a.x:=min(Points[0].x,Points[1].x);
    a.y:=min(Points[0].y,Points[1].y);
    x1:=WorldToScreen(a).x;
    y1:=WorldToScreen(a).y;
    a.x:=max(Points[0].x,Points[1].x);
    a.y:=max(Points[0].y,Points[1].y);
    x2:=WorldToScreen(a).x;
    y2:=WorldToScreen(a).y;
  end;
  Canvas.Rectangle(x1,y1,x2,y2);
end;

procedure TEllipse.Draw(Canvas:TCanvas);
var
  i:integer;
  x1,y1,x2,y2:integer;
  a:TDoublePoint;
begin
  Canvas.Pen.Color:=Color;
  Canvas.Pen.Width:=SizePen;
  with Screen do begin
    a.x:=min(Points[0].x,Points[1].x);
    a.y:=min(Points[0].y,Points[1].y);
    x1:=WorldToScreen(a).x;
    y1:=WorldToScreen(a).y;
    a.x:=max(Points[0].x,Points[1].x);
    a.y:=max(Points[0].y,Points[1].y);
    x2:=WorldToScreen(a).x;
    y2:=WorldToScreen(a).y;
  end;
  Canvas.Ellipse(x1,y1,x2,y2);
end;

end.

