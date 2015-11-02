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
    procedure ShiftXEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShiftYEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure ZoomEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
  private
    Buttons:array of TBitBtn;
    ActiveBtn,FullScreenBtn:TBitBtn;
    NormalTextZoom,NormalTextShiftX,NormalTextShiftY:boolean;
  public
    { public declarations }
  end;

var
  Form1:TForm;
  Colors:array [1..6] of TColor = (ClBlack,ClWhite,clRed,Clgreen,clBlue,clYellow);
implementation

{$R *.lfm}

{ TForm1 }
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
  if length(Figures)<>0 then begin
    dx:=maxScreen.x-minScreen.x;
    dy:=maxScreen.y-minScreen.y;
    if dx*AHeight>=dy*AWidth then
      zoom:=dx/AWidth;
    if dy*AWidth>dx*AHeight then
      zoom:=dy/AHeight;
    ZoomEdit.Text:=floattostr(100/Zoom);
    NormalTextZoom:=true;
    ShiftX:=minScreen.x;
    ShiftY:=minScreen.y;
    ScrollBarX.Position:=Round(ShiftX);
    ScrollBarY.Position:=Round(ShiftY);
    ShiftXEdit.Text:=floattostr(ShiftX);
    ShiftYEdit.Text:=floattostr(ShiftY);
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
  AWidth:=PaintBox.Width;
  AHeight:=PaintBox.Height;
end;

procedure TForm1.ScrollBarXScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  ShiftX:=ScrollBarX.Position;
  ShiftXEdit.Text:=floattostr(ShiftX);
  PaintBox.Invalidate;
end;

procedure TForm1.ScrollBarYScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  ShiftY:=ScrollBarY.Position;
  ShiftYEdit.Text:=floattostr(ShiftY);
  PaintBox.Invalidate;
end;

procedure TForm1.ShiftXEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then begin
    if not NormalTextShiftX then begin
      ShiftXEdit.Text:=floattostr(ShiftX);
      NormalTextShiftX:=true;
    end;
    ShiftX:=strtofloat(ShiftXEdit.Text);
    PaintBox.Invalidate;
  end;
  if not(chr(key) in ['0'..'9',chr(VK_LEFT)..chr(VK_DOWN),chr(VK_DELETE),chr(VK_SHIFT)])
  and (key<>8) and (key<>13) then
    NormalTextShiftX:=false;
end;

procedure TForm1.ShiftYEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then begin
    if not NormalTextShiftY then begin
      ShiftYEdit.Text:=floattostr(ShiftY);
      NormalTextShiftY:=true;
    end;
    ShiftY:=strtofloat(ShiftYEdit.Text);
    PaintBox.Invalidate;
  end;
  if not(chr(key) in ['0'..'9',chr(VK_LEFT)..chr(VK_DOWN),chr(VK_DELETE),chr(VK_SHIFT)])
  and (key<>8) and (key<>13) then
    NormalTextShiftY:=false;
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

  AWidth:=PaintBox.Width;
  AHeight:=PaintBox.Height;

  ShiftX:=0;
  ShiftY:=0;
  zoom:=1;

  NormalTextZoom:=true;
  NormalTextShiftX:=true;
  NormalTextShiftY:=true;

  minScreen.x:=0;
  minScreen.y:=0;
  maxScreen:=minScreen;

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
  ZoomEdit.Text:=floattostr(100/Zoom);
  NormalTextZoom:=true;
  ScrollBarX.Position:=Round(ShiftX);
  ScrollBarY.Position:=Round(ShiftY);
  ShiftXEdit.Text:=floattostr(ShiftX);
  ShiftYEdit.Text:=floattostr(ShiftY);
  PaintBox.Invalidate;
end;

procedure TForm1.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    if (ScreenToWorld(Point(X,Y)).x)>0.9*(ScrollBarX.Max) then
      ScrollBarX.Max:=Round(1.15*ScreenToWorld(Point(X,Y)).x);
    if (ScreenToWorld(Point(X,Y)).y)>0.9*(ScrollBarY.Max) then
      ScrollBarY.Max:=Round(1.15*ScreenToWorld(Point(X,Y)).y);
    if (ScreenToWorld(Point(X,Y)).x)<0.9*(ScrollBarX.Min) then
      ScrollBarX.Min:=Round(1.3*ScreenToWorld(Point(X,Y)).x);
    if (ScreenToWorld(Point(X,Y)).y)<0.9*(ScrollBarY.Min) then
      ScrollBarY.Min:=Round(1.3*ScreenToWorld(Point(X,Y)).y);
    Tools[ActiveBtn.Tag].MouseMove(Sender,Shift,X,Y);
    ScrollBarX.Position:=Round(ShiftX);
    ScrollBarY.Position:=Round(ShiftY);
    ShiftXEdit.Text:=floattostr(ShiftX);
    ShiftYEdit.Text:=floattostr(ShiftY);
    PaintBox.Invalidate;
  end;
end;

procedure TForm1.ZoomEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then begin
    if not NormalTextZoom then begin
      ZoomEdit.Text:=floattostr(100/zoom);
      NormalTextZoom:=true;
    end;
    if strtofloat(ZoomEdit.Text)=0 then begin
      ZoomEdit.Text:=floattostr(100/zoom);
      NormalTextZoom:=true;
    end;
    zoom:=100/strtofloat(ZoomEdit.Text);
    PaintBox.Invalidate;
  end;
  if not(chr(key) in ['0'..'9',chr(VK_LEFT)..chr(VK_DOWN),chr(VK_DELETE),chr(VK_SHIFT)])
  and (key<>8) and (key<>13) then
    NormalTextZoom:=false;
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

