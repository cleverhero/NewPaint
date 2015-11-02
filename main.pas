unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, Buttons, StdCtrls, About, UTools, UFigures, LCLType, CheckLst,
  UTransformation;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnClear: TButton;
    ColorBox: TComboBox;
    ColorLabel: TLabel;
    Label1: TLabel;
    ShiftXLabel: TLabel;
    ShiftYLabel: TLabel;
    ZoomEdit: TEdit;
    ShiftXEdit: TEdit;
    ShiftYEdit: TEdit;
    ZoomLabel: TLabel;
    ScrollBarY: TScrollBar;
    ScrollBarX: TScrollBar;
    SizeLabel: TLabel;
    MainMenu1: TMainMenu;
    MenuFail: TMenuItem;
    MenuAbout: TMenuItem;
    MenuExit: TMenuItem;
    PaintBox: TPaintBox;
    Panel: TPanel;
    SizeBox: TComboBox;
    procedure BClick(Sender: TObject);
    procedure FullScreenBtnClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure ColorBoxSelect(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure ScrollBarXScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ScrollBarYScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure SizeBoxSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Sender: TObject;Shift: TShiftState;
      X, Y: Integer);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure Update;
    procedure CheckString(AText:string);
  private
    Buttons:array of TBitBtn;
    ActiveBtn,FullScreenBtn:TBitBtn;
  public
    { public declarations }
  end;

var
  Form1:TForm;
  flags : TBits;
  Colors:array [1..6] of TColor = (ClBlack,ClWhite,clRed,Clgreen,clBlue,clYellow);
implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.Update;
begin
  ZoomEdit.Text:=floattostr(100/Screen.Zoom);
  ScrollBarX.Position:=Round(Screen.Shift.X);
  ScrollBarY.Position:=Round(Screen.Shift.Y);
  ShiftXEdit.Text:=floattostr(Screen.Shift.X);
  ShiftYEdit.Text:=floattostr(Screen.Shift.Y);
end;

procedure TForm1.CheckString(AText:string);
var
  i:integer;
begin
  flags.Size:=1000000000000;
  flags[999999999999]:=true;
  for i:=1 to length(AText) do
    if not(AText[i] in ['0'..'9',',']) then begin
      Update;
      Break;
    end;
end;

procedure TForm1.MenuExitClick(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.MenuAboutClick(Sender: TObject);
begin
   About.FormAbout.Show;
end;

procedure TForm1.BClick(Sender: TObject);
var
  Btn:TBitBtn;
begin
  Btn:=(Sender as TBitBtn);
  ActiveBtn:=Btn;
  PaintBox.OnMouseDown:=@MouseDown;
  PaintBox.OnMouseUp:=@MouseUp;
  PaintBox.OnMouseMove:=@MouseMove;
end;

procedure TForm1.FullScreenBtnClick(Sender: TObject);
var
  dx,dy:double;
begin
  with Screen do
    if length(Figures)<>0 then begin
      Translation(Shift,DoublePoint(minScreen.x,minScreen.y));
      dx:=maxScreen.x-minScreen.x;
      dy:=maxScreen.y-minScreen.y;
      if dx*Height>=dy*Width then
        Screen.Scale(dx/Width/Zoom,0,0);
      if dy*Width>dx*Height then
        Screen.Scale(dy/Height/Zoom,0,0);
      PaintBox.Invalidate;
  end;
end;

procedure TForm1.BtnClearClick(Sender: TObject);
begin
  if FlagMouse then begin
    FlagMouse:=not FlagMouse;
    PaintBox.OnMouseUp(Nil,TMouseButton.mbRight,[],0,0);
  end;
  setlength(Figures,0);
  PaintBox.Invalidate;
end;

procedure TForm1.ColorBoxSelect(Sender: TObject);
begin
  GColorPen:=Colors[ColorBox.ItemIndex+1];
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (ssCtrl in Shift) and (key=VK_Z) and (length(Figures)>0) then begin
    if FlagMouse then begin
      FlagMouse:=not FlagMouse;
      PaintBox.OnMouseUp(Nil,TMouseButton.mbRight,[],0,0);
    end;
    setlength(Figures,length(Figures)-1);
    PaintBox.Invalidate;
  end;
  if (key=VK_SHIFT) then
    FlagShift:=true;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key=VK_SHIFT) then
    FlagShift:=false;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Screen.Width:=PaintBox.Width;
  Screen.Height:=PaintBox.Height;
end;

procedure TForm1.ScrollBarXScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  Screen.Shift.X:=ScrollBarX.Position;
  ShiftXEdit.Text:=floattostr(Screen.Shift.X);
  PaintBox.Invalidate;
end;

procedure TForm1.ScrollBarYScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  Screen.Shift.Y:=ScrollBarY.Position;
  ShiftYEdit.Text:=floattostr(Screen.Shift.Y);
  PaintBox.Invalidate;
end;

procedure TForm1.SizeBoxSelect(Sender: TObject);
begin
  GSizePen:=Strtoint(SizeBox.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  SizeBox.OnSelect(SizeBox);
  ColorBox.OnSelect(ColorBox);

  Screen.Width:=PaintBox.Width;
  Screen.Height:=PaintBox.Height;

  Screen.Shift.X:=0;
  Screen.Shift.Y:=0;
  Screen.Zoom:=1;

  Screen.minScreen.x:=0;
  Screen.minScreen.y:=0;
  Screen.maxScreen.x:=Screen.Width;
  Screen.maxScreen.y:=Screen.Height;

  Screen.OnChange:=@Update;

  setlength(Buttons,length(tools));
  for i:=0 to high(tools) do begin
    Buttons[i]:=tools[i].BtnRegistration(i,self);
    Buttons[i].Parent:=Panel;
    Buttons[i].OnClick:=@BClick;
  end;

  FullScreenBtn:=TBitBtn.Create(Form1);
  FullScreenBtn.Left:=25+80*1;
  FullScreenBtn.Top:=25+70*4;
  FullScreenBtn.Width:=49;
  FullScreenBtn.Height:=49;
  FullScreenBtn.Glyph.LoadFromFile('FullScreen.bmp');
  FullScreenBtn.Parent:=Panel;
  FullScreenBtn.OnClick:=@FullScreenBtnClick;

  Buttons[0].Click;
end;

procedure TForm1.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Tools[ActiveBtn.Tag].MouseDown(Sender,Button,Shift,X,Y);
end;

procedure TForm1.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Tools[ActiveBtn.Tag].MouseUp(Sender,Button,Shift,X,Y);
  PaintBox.Invalidate;
end;

procedure TForm1.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
var
  p:TDoublePoint;
begin
  if FlagMouse then begin
    p:=Screen.ScreenToWorld(Point(X,Y));
    if p.x>0.9*ScrollBarX.Max then
      ScrollBarX.Max:=Round(1.15*p.x);
    if p.y>0.9*ScrollBarY.Max then
      ScrollBarY.Max:=Round(1.15*p.y);
    if p.x<0.9*ScrollBarX.Min then
      ScrollBarX.Min:=Round(1.3*p.x);
    if p.y<0.9*ScrollBarY.Min then
      ScrollBarY.Min:=Round(1.3*p.y);
    Tools[ActiveBtn.Tag].MouseMove(Sender,Shift,X,Y);
    PaintBox.Invalidate;
  end;
end;

procedure TForm1.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Edit:TEdit;
  i:integer;
begin
  Edit:=Sender as TEdit;
  if key=13 then begin
    CheckString(ZoomEdit.Text);
    CheckString(ShiftXEdit.Text);
    CheckString(ShiftXEdit.Text);
    if strtofloat(ZoomEdit.Text)=0 then
      Update;
    Screen.Zoom:=100/StrToFloat(ZoomEdit.Text);
    Screen.Translation(Screen.Shift,
      DoublePoint(StrToFloat(ShiftXEdit.Text),StrToFloat(ShiftYEdit.Text)));
    PaintBox.Invalidate;
  end;
end;

procedure TForm1.PaintBoxPaint(Sender: TObject);
var
  i,j:integer;
begin
  PaintBox.Canvas.Brush.Color:=clWhite;
  PaintBox.Canvas.Brush.Style:=bsSolid;
  PaintBox.Canvas.FillRect(0,0,Form1.Width,Form1.Height);
  PaintBox.Canvas.Brush.Style:=bsClear;
  for i:=0 to High(Figures) do
    Figures[i].Draw(PaintBox.Canvas);
end;
end.

