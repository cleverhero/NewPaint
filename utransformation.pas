unit UTransformation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  DoublePoint = Record
    x,y:Double;
  end;

function WorldToScreen(a:DoublePoint):TPoint;
function ScreenToWorld(a:TPoint):DoublePoint;

var
  ShiftX,ShiftY,zoom:double;
  AWidth,AHeight:integer;
  maxScreen,minScreen:DoublePoint;

implementation

function WorldToScreen(a:DoublePoint):TPoint;
begin
  WorldToScreen:=Point(Round((a.x-ShiftX)/zoom),Round((a.y-ShiftY)/zoom));
end;

function ScreenToWorld(a:TPoint):DoublePoint;
begin
  ScreenToWorld.x:=a.x*zoom+ShiftX;
  ScreenToWorld.y:=a.y*zoom+ShiftY;
end;

end.

