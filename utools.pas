unit UTools;

{$mode objfpc}{$H+}
interface


uses
  Classes, Forms, Controls, SysUtils, Dialogs, UFigures, ExtCtrls, StdCtrls,
  Graphics, Buttons, Math, UTransformation;

type

  TTool = Class
    function BtnRegistration(i:integer;Sender:TObject):TBitBtn;
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); virtual;abstract;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); virtual;abstract;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); virtual;abstract;
  end;

  TToolClass = class of TTool;


  TToolPen = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); override;
  end;



  TToolLine = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); override;
  end;


  TToolPolyLine = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); override;
  end;


  TToolRect = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); override;
  end;


  TToolEllipse = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); override;
  end;


  TToolRoundRect = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); override;
  end;

  TToolHand = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); override;
    private
      HandPoint:TDoublePoint;
  end;

  TToolLoupe = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); override;
  end;

  TToolLoupeRect = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); override;
  end;

var
  Tools:array of TTool;
  FlagMouse:boolean;
  GSizePen:integer;
  GColorPen:TColor;
  FlagShift:Boolean;

implementation
procedure ToolRegistration(TypeTool:TToolClass);
begin
  setlength(tools,length(tools)+1);
  tools[high(tools)]:=TypeTool.Create;
end;

function TTool.BtnRegistration(i:integer;Sender:TObject):TBitBtn;
begin
  result:=TBitBtn.Create(Sender as TComponent);
  result.Left:=25+80*(i div 5);
  result.Top:=25+70*(i mod 5);
  result.Width:=49;
  result.Height:=49;
  result.Tag:=i;
  result.Glyph.LoadFromFile(inttostr(i)+'.bmp');
end;

{TToolPen}


procedure TToolPen.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  AddFigure(UFigures.TPen,GColorPen,GSizePen);
end;
procedure TToolPen.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  check;
  if (length(Figures[High(Figures)].Points)=0) then SetLength(Figures,Length(Figures)-1);
end;
procedure TToolPen.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  AddPoint(x,y);
end;


{TToolLine}

procedure TToolLine.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  AddFigure(TLine,GColorPen,GSizePen);
  AddPoint(x,y);
  AddPoint(x,y);
end;
procedure TToolLine.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  check;
end;
procedure TToolLine.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  ReplaceLastPoint(x,y);
end;


{TToolPolyLine}

procedure TToolPolyLine.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i:integer;
begin
  if not FlagMouse then begin
    FlagMouse:=true;
    AddFigure(TPolyLine,GColorPen,GSizePen);
    AddPoint(x,y);
  end;
  AddPoint(x,y);
end;
procedure TToolPolyLine.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button=TMouseButton.mbRight then begin
    FlagMouse:=false;
    exit;
  end;
  check;
end;
procedure TToolPolyLine.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
var
  i:integer;
begin
  ReplaceLastPoint(x,y);
end;


{TToolRoundRect}

procedure TToolRoundRect.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  AddFigure(TRoundRect,GColorPen,GSizePen);
  AddPoint(x,y);
  AddPoint(x,y);
end;
procedure TToolRoundRect.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  check;
  with Figures[High(Figures)] do
    if (Points[0].x-Points[1].x)=0 then  SetLength(Figures,Length(Figures)-1);
end;
procedure TToolRoundRect.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  ReplaceLastPoint(x,y);
  if FlagShift then
    ReplaceLastPoint(x,y,1,1);
end;


{TToolRect}

procedure TToolRect.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  AddFigure(TRect,GColorPen,GSizePen);
  AddPoint(x,y);
  AddPoint(x,y);
end;
procedure TToolRect.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  check;
  with Figures[High(Figures)] do
    if (Points[0].x-Points[1].x)=0 then  SetLength(Figures,Length(Figures)-1);
end;
procedure TToolRect.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  ReplaceLastPoint(x,y);
  if FlagShift then
    ReplaceLastPoint(x,y,1,1);
end;


{TToolEllipse}

procedure TToolEllipse.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  AddFigure(TEllipse,GColorPen,GSizePen);
  AddPoint(x,y);
  AddPoint(x,y);
end;
procedure TToolEllipse.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  check;
  with Figures[High(Figures)] do
    if (Points[0].x-Points[1].x)=0 then  SetLength(Figures,Length(Figures)-1);
end;
procedure TToolEllipse.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  ReplaceLastPoint(x,y);
  if FlagShift then
    ReplaceLastPoint(x,y,1,1);
end;


{TToolHand}

procedure TToolHand.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  HandPoint:=Screen.ScreenToWorld(Point(X,Y));
end;
procedure TToolHand.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
end;
procedure TToolHand.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    Screen.Translation(Screen.ScreenToWorld(Point(X,Y)),HandPoint);
    HandPoint:=Screen.ScreenToWorld(Point(X,Y));
  end;
end;


{TToolLoupe}

procedure TToolLoupe.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;
procedure TToolLoupe.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=TMouseButton.mbRight then
    Screen.Scale(2,x,y);
  if Button=TMouseButton.mbLeft then
    Screen.Scale(1/2,x,y);
end;
procedure TToolLoupe.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
end;


{TToolLoupeRect}

procedure TToolLoupeRect.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  AddFigure(TRect,clBlack,1);
  AddPoint(x,y);
  AddPoint(x,y);
end;
procedure TToolLoupeRect.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  xmin,ymin:double;
begin
  FlagMouse:=false;
  with Figures[High(Figures)] do
    if (Points[0].x-Points[1].x)<>0 then begin
      xmin:=min(Points[0].x,Points[1].x);
      ymin:=min(Points[0].y,Points[1].y);
      Screen.Translation(Screen.Shift,DoublePoint(xmin,ymin));
      Screen.Scale(abs(Points[0].x-Points[1].x)/Screen.Width/Screen.Zoom,0,0);
    end;
  SetLength(Figures,Length(Figures)-1);
end;
procedure TToolLoupeRect.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  ReplaceLastPoint(x,y,Screen.Width,Screen.Height);
end;
initialization
  ToolRegistration(TToolPen);
  ToolRegistration(TToolLine);
  ToolRegistration(TToolPolyLine);
  ToolRegistration(TToolHand);
  ToolRegistration(TToolLoupe);
  ToolRegistration(TToolRect);
  ToolRegistration(TToolRoundRect);
  ToolRegistration(TToolEllipse);
  ToolRegistration(TToolLoupeRect);
end.

