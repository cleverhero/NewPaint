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
  dx,dy,zoom:double;

implementation
function WorldToScreen(a:DoublePoint):TPoint;
begin
  WorldToScreen:=Point(Round((a.x-dx)/zoom),Round((a.y-dy)/zoom));
end;

function ScreenToWorld(a:TPoint):DoublePoint;
begin
  ScreenToWorld.x:=a.x*zoom+dx;
  ScreenToWorld.y:=a.y*zoom+dy;
end;

end.

