unit UTools;

{$mode objfpc}{$H+}
interface


uses
  Classes, Forms, Controls, SysUtils, Dialogs, UFigures, ExtCtrls, StdCtrls, Graphics, Buttons, Math;

type
  TTool = Class
    function BtnRegistration(i:integer;Sender:TObject):TBitBtn;
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer); virtual;
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

var
  Tools:array of TTool;
  FlagMouse:boolean;
  SizePen:integer;
  ColorPen:TColor;
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
  result.Left:=8+69*(i div 3);
  result.Top:=20+69*(i mod 3);
  result.Width:=49;
  result.Height:=49;
  result.Tag:=i;
  result.Glyph.LoadFromFile(inttostr(i)+'.bmp');
end;
Procedure TTool.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;
Procedure TTool.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;
Procedure TTool.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
end;

{TToolPen}


Procedure TToolPen.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=UFigures.TPen.Create;
  Figures[High(Figures)].SizePen:=SizePen;
  Figures[High(Figures)].Color:=ColorPen;
end;
Procedure TToolPen.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
end;
Procedure TToolPen.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    SetLength(Figures[High(Figures)].Points,Length(Figures[High(Figures)].Points)+1);
    Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].x:=X;
    Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].y:=Y;
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolLine}

Procedure TToolLine.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TLine.Create;
  Figures[High(Figures)].Point1.x:=X;
  Figures[High(Figures)].Point1.y:=Y;
  Figures[High(Figures)].SizePen:=SizePen;
  Figures[High(Figures)].Color:=ColorPen;
end;
Procedure TToolLine.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
end;
Procedure TToolLine.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    Figures[High(Figures)].Point2.x:=X;
    Figures[High(Figures)].Point2.y:=Y;
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolPolyLine}

Procedure TToolPolyLine.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i:integer;
begin
  if not FlagMouse then begin
    FlagMouse:=true;
    SetLength(Figures,Length(Figures)+1);
    Figures[High(Figures)]:=TPolyLine.Create;
    Figures[High(Figures)].SizePen:=SizePen;
    Figures[High(Figures)].Color:=ColorPen;
    SetLength(Figures[High(Figures)].Points,Length(Figures[High(Figures)].Points)+1);
  end;
  Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].x:=X;
  Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].y:=Y;
  SetLength(Figures[High(Figures)].Points,Length(Figures[High(Figures)].Points)+1);
  Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].x:=X;
  Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].y:=Y;
end;
Procedure TToolPolyLine.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button=TMouseButton.mbRight then begin
    FlagMouse:=false;
    exit;
  end;
end;
Procedure TToolPolyLine.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
var
  i:integer;
begin
  if FlagMouse then begin
    Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].x:=X;
    Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].y:=Y;
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolRoundRect}

Procedure TToolRoundRect.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TRoundRect.Create;
  Figures[High(Figures)].SizePen:=SizePen;
  Figures[High(Figures)].Color:=ColorPen;
  Figures[High(Figures)].Point1.x:=X;
  Figures[High(Figures)].Point1.y:=Y;
end;
Procedure TToolRoundRect.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
end;
Procedure TToolRoundRect.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    Figures[High(Figures)].Point2.x:=X;
    Figures[High(Figures)].Point2.y:=Y;
    with Figures[High(Figures)] do
    if FlagShift then
      Point2.y:=Point1.y+sign((Point1.y-Y)*(Point1.x-X))*(X-Point1.x);
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolRect}

Procedure TToolRect.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TRect.Create;
  Figures[High(Figures)].SizePen:=SizePen;
  Figures[High(Figures)].Color:=ColorPen;
  Figures[High(Figures)].Point1.x:=X;
  Figures[High(Figures)].Point1.y:=Y;
end;
Procedure TToolRect.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
end;
Procedure TToolRect.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    Figures[High(Figures)].Point2.x:=X;
    Figures[High(Figures)].Point2.y:=Y;
    with Figures[High(Figures)] do
    if FlagShift then
      Point2.y:=Point1.y+sign((Point1.y-Y)*(Point1.x-X))*(X-Point1.x);
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolEllipse}

Procedure TToolEllipse.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TEllipse.Create;
  Figures[High(Figures)].SizePen:=SizePen;
  Figures[High(Figures)].Color:=ColorPen;
  Figures[High(Figures)].Point1.x:=X;
  Figures[High(Figures)].Point1.y:=Y;
end;
Procedure TToolEllipse.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
end;
Procedure TToolEllipse.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    Figures[High(Figures)].Point2.x:=X;
    Figures[High(Figures)].Point2.y:=Y;
    with Figures[High(Figures)] do
    if FlagShift then
      Point2.y:=Point1.y+sign((Point1.y-Y)*(Point1.x-X))*(X-Point1.x);
    (Sender as TPaintBox).Invalidate;
  end;
end;

initialization
  ToolRegistration(TToolPen);
  ToolRegistration(TToolLine);
  ToolRegistration(TToolPolyLine);
  ToolRegistration(TToolRect);
  ToolRegistration(TToolRoundRect);
  ToolRegistration(TToolEllipse);
end.

