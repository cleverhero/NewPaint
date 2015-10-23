unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, Buttons, StdCtrls, About, UTools, UFigures, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnClear: TButton;
    LabelSize: TLabel;
    LabelColor: TLabel;
    SizeBox: TComboBox;
    MainMenu1: TMainMenu;
    MenuFail: TMenuItem;
    MenuAbout: TMenuItem;
    MenuExit: TMenuItem;
    PaintBox: TPaintBox;
    Panel: TPanel;
    Settings: TPanel;
    ColorBox: TComboBox;
    procedure BClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure ColorBoxSelect(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SizeBoxSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
  private
    Buttons:array of TBitBtn;
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
  PaintBox.OnMouseDown:=@Tools[Btn.Tag].MouseDown;
  PaintBox.OnMouseUp:=@Tools[Btn.Tag].MouseUp;
  PaintBox.OnMouseMove:=@Tools[Btn.Tag].MouseMove;
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

  setlength(Buttons,length(tools));
  for i:=0 to high(tools) do begin
    Buttons[i]:=tools[i].BtnRegistration(i,self);
    Buttons[i].Parent:=Panel;
    Buttons[i].OnClick:=@BClick;
  end;
  Buttons[0].Click;
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

