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
    procedure CreatePoint(x,y:integer);
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
  result.Left:=8+69*(i div 3);
  result.Top:=20+69*(i mod 3);
  result.Width:=49;
  result.Height:=49;
  result.Tag:=i;
  result.Glyph.LoadFromFile(inttostr(i)+'.bmp');
end;
procedure TTool.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;
procedure TTool.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;
procedure TTool.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
end;

procedure TTool.CreatePoint(x,y:integer);
begin
  with Figures[High(Figures)] do begin
    Points[high(Points)]:=Point(x,y);
  end;
end;

{TToolPen}


procedure TToolPen.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=UFigures.TPen.Create;
  with Figures[High(Figures)] do begin
    SizePen:=GSizePen;
    Color:=GColorPen;
  end;
end;
procedure TToolPen.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
end;
procedure TToolPen.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then
  with Figures[High(Figures)] do begin
    SetLength(Points,Length(Points)+1);
    CreatePoint(x,y);
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolLine}

procedure TToolLine.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TLine.Create;
  with Figures[High(Figures)] do begin
    SetLength(Points,1);
    CreatePoint(x,y);
    SizePen:=GSizePen;
    Color:=GColorPen;
  end;
end;
procedure TToolLine.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  if Length(Figures[High(Figures)].Points)<2 then SetLength(Figures,Length(Figures)-1);
end;
procedure TToolLine.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then
  with Figures[High(Figures)] do begin
    SetLength(Points,2);
    CreatePoint(x,y);
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolPolyLine}

procedure TToolPolyLine.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i:integer;
begin
  if not FlagMouse then begin
    FlagMouse:=true;
    SetLength(Figures,Length(Figures)+1);
    Figures[High(Figures)]:=TPolyLine.Create;
    with Figures[High(Figures)] do begin
      SizePen:=GSizePen;
      Color:=GColorPen;
      SetLength(Points,Length(Points)+1);
    end;
  end;
  with Figures[High(Figures)] do begin
    CreatePoint(x,y);
    SetLength(Points,Length(Points)+1);
    CreatePoint(x,y);
  end;
end;
procedure TToolPolyLine.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button=TMouseButton.mbRight then begin
    FlagMouse:=false;
    exit;
  end;
end;
procedure TToolPolyLine.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
var
  i:integer;
begin
  if FlagMouse then
  with Figures[High(Figures)] do begin
    CreatePoint(x,y);
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolRoundRect}

procedure TToolRoundRect.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TRoundRect.Create;
  with Figures[High(Figures)] do begin
    SetLength(Points,1);
    CreatePoint(x,y);
    SizePen:=GSizePen;
    Color:=GColorPen;
  end;
end;
procedure TToolRoundRect.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  if Length(Figures[High(Figures)].Points)<2 then SetLength(Figures,Length(Figures)-1);
end;
procedure TToolRoundRect.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then
  with Figures[High(Figures)] do begin
    SetLength(Points,2);
    CreatePoint(x,y);
    if FlagShift then
      Points[1].y:=Points[0].y+sign((Points[0].y-Y)*(Points[0].x-X))*(X-Points[0].x);
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolRect}

procedure TToolRect.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TRect.Create;
  with Figures[High(Figures)] do begin
    SetLength(Points,1);
    CreatePoint(x,y);
    SizePen:=GSizePen;
    Color:=GColorPen;
  end;
end;
procedure TToolRect.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  if Length(Figures[High(Figures)].Points)<2 then SetLength(Figures,Length(Figures)-1);
end;
procedure TToolRect.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then
  with Figures[High(Figures)] do begin
    SetLength(Points,2);
    CreatePoint(x,y);
    if FlagShift then
      Points[1].y:=Points[0].y+sign((Points[0].y-Y)*(Points[0].x-X))*(X-Points[0].x);
    (Sender as TPaintBox).Invalidate;
  end;
end;


{TToolEllipse}

procedure TToolEllipse.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TEllipse.Create;
  with Figures[High(Figures)] do begin
    SetLength(Points,1);
    CreatePoint(x,y);
    SizePen:=GSizePen;
    Color:=GColorPen;
  end;
end;
procedure TToolEllipse.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  if Length(Figures[High(Figures)].Points)<2 then SetLength(Figures,Length(Figures)-1);
end;
procedure TToolEllipse.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then
  with Figures[High(Figures)] do begin
    SetLength(Points,2);
    CreatePoint(x,y);
    if FlagShift then
      Points[1].y:=Points[0].y+sign((Points[0].y-Y)*(Points[0].x-X))*(X-Points[0].x);
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

