unit UTransformation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TDoublePoint = Record
    x,y:Double;
  end;

function DoublePoint(AX, AY: Double): TDoublePoint;

type
  TChangeEvent = procedure of Object;

  MyScreen = Class
    Zoom:double;
    Width,Height:integer;
    MaxScreen,MinScreen,Shift:TDoublePoint;
    OnChange:TChangeEvent;

    function WorldToScreen(a:TDoublePoint):TPoint;
    function ScreenToWorld(a:TPoint):TDoublePoint;
    procedure Scale(k:Double;x,y:integer);
    procedure Translation(ps,pf:TDoublePoint);
  end;

var
  Screen:MyScreen;

implementation
function DoublePoint(AX, AY: Double): TDoublePoint;
begin
  DoublePoint.x:=AX;
  DoublePoint.y:=AY;
end;

procedure MyScreen.Scale(k:Double;x,y:integer);
begin
  Shift:=DoublePoint(ScreenToWorld(Point(x,y)).x-x*Zoom*k,ScreenToWorld(Point(x,y)).y-y*Zoom*k);
  Zoom:=Zoom*k;
  OnChange;
end;

procedure MyScreen.Translation(ps,pf:TDoublePoint);
begin
  Shift.X+=pf.x-ps.x;
  Shift.Y+=pf.y-ps.y;
  OnChange;
end;

function MyScreen.WorldToScreen(a:TDoublePoint):TPoint;
begin
  WorldToScreen:=Point(Round((a.x-Shift.X)/Zoom),Round((a.y-Shift.Y)/Zoom));
end;

function MyScreen.ScreenToWorld(a:TPoint):TDoublePoint;
begin
  ScreenToWorld.x:=a.x*Zoom+Shift.X;
  ScreenToWorld.y:=a.y*Zoom+Shift.Y;
end;

initialization
  Screen:=MyScreen.Create;
end.

