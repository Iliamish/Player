unit Unit1;

{$mode objfpc}{$H+}

interface

uses
 windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
 StdCtrls, ActnList, ExtCtrls, Bass, ComCtrls,iniFiles,ShellAPI;

type

  { TForm1 }
  TFFTData  = array [0..512] of Single;
  TPlayerMode = (Stop, Play, Paused);
  TForm1 = class(TForm)
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    ActionList1: TActionList;
    ActionList2: TActionList;
    ActionList3: TActionList;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    ScrollBar1: TScrollBar;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Timer1: TTimer;
    Timer2: TTimer;
    TrackBar1: TTrackBar;
    TrackBar10: TTrackBar;
    TrackBar11: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    TrackBar6: TTrackBar;
    TrackBar7: TTrackBar;
    TrackBar8: TTrackBar;
    TrackBar9: TTrackBar;
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure ActionList1Execute(AAction: TBasicAction; var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button3KeyPress(Sender: TObject; var Key: char);
    procedure Button4Click(Sender: TObject);
    procedure Button4KeyPress(Sender: TObject; var Key: char);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button6KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure Button6KeyPress(Sender: TObject; var Key: char);

    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);

    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Label1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1Paint(Sender: TObject);
    procedure Player;
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Draw(HWND : THandle; FFTData : TFFTData; X, Y : Integer);
    procedure Timer2Timer(Sender: TObject);
    procedure TrackBar10Change(Sender: TObject);
    procedure TrackBar11Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure TrackBar5Change(Sender: TObject);
    procedure TrackBar6Change(Sender: TObject);
    procedure TrackBar7Change(Sender: TObject);
    procedure TrackBar8Change(Sender: TObject);
    procedure TrackBar9Change(Sender: TObject);

  private

    { private declarations }
  public

    { public declarations }
  end;

var
  Form1: TForm1;
  i:integer;
filename: string;
 Channel: DWORD;//дескриптор канала
Mode: TPlayerMode;
chosenDirectory : string;
k:integer;
FFTPeacks  : array [0..128] of Integer;
FFTFallOff : array [0..128] of Integer;
p: BASS_DX8_PARAMEQ;
 fx: array[1..10] of integer ;
 IniFile: TIniFile;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.Draw(HWND : THandle; FFTData : TFFTData; X, Y : Integer);
        var i, YPos : LongInt; YVal : Single;
       begin

          Panel1.Canvas.Pen.Color := clWhite;
          Panel1.Canvas.Brush.Color := clWhite;
          PAnel1.Canvas.Rectangle(0, 0, PAnel1.Width, Panel1.Height);

       // pb1.Canvas.Pen.Color := clRed;
         for i := 0 to 127 do begin
           YVal := Abs(FFTData[i]);
           YPos := trunc((YVal) * 500);
           if YPos > Panel1.Height then YPos := Panel1.Height;

           if YPos >= FFTPeacks[i] then FFTPeacks[i] := YPos
             else FFTPeacks[i] := FFTPeacks[i] - 1;

           if YPos >= FFTFallOff[i] then FFTFallOff[i] := YPos
              else FFTFallOff[i] := FFTFallOff[i] - 3;

                     Panel1.Canvas.Pen.Color := clBlue;
                    Panel1.Canvas.MoveTo(X + i*(3+1) , Y + Panel1.Height - FFTPeacks[i]);
                     Panel1.Canvas.LineTo(X + i*(3+1) + 3, Y + Panel1.Height - FFTPeacks[i]);

                     Panel1.Canvas.Pen.Color := clRed;
                     Panel1.Canvas.Brush.Color := clRed;
                     Panel1.Canvas.Rectangle(X + i*(3+1) , Y + Panel1.Height - FFTFallOff[i], X + i*(3+1) + 3, Y + Panel1.Height);

              end;

        end;

procedure TForm1.Timer2Timer(Sender: TObject);
        var FFTFata : TFFTData;
begin
   if mode<>play then Exit;
   if  BASS_ChannelIsActive(channel)=BASS_ACTIVE_STOPPED   then
               begin
               ListBox1.ItemIndex:=ListBox1.ItemIndex+1;

   Filename:=ListBox2.Items.Strings[ListBox1.ItemIndex]+ListBox1.Items.Strings[ListBox1.ItemIndex];
       mode:=stop;
       player;

      end;
  BASS_ChannelGetData(Channel, @FFTFata, BASS_DATA_FFT1024);
Draw (Panel1.Canvas.Handle, FFTFata, 0,-5);
end;

procedure TForm1.Player;

begin

if mode<>paused then begin

if not FileExists(FileName) then begin ShowMessage('Файл не существует');exit;end;

BASS_ChannelStop(Channel);BASS_StreamFree(Channel);

Channel := BASS_StreamCreateFile(FALSE, PChar(filename), 0, 0, 0 );

if Channel=0 then begin ShowMessage('Ошибка загрузки Файла');exit;end;
end;

fx[1] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);//первый канал эквалайзера
  fx[2] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);//второй канал
  fx[3] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
  fx[4] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
  fx[5] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
  fx[6] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
  fx[7] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
  fx[8] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
  fx[9] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);
  fx[10] := BASS_ChannelSetFX(channel, BASS_FX_DX8_PARAMEQ, 1);


  p.fGain :=15-trackbar2.Position;
  p.fBandwidth := 3;
  p.fCenter := 80;
  BASS_FXSetParameters(fx[1], @p);


  p.fGain := 15-trackbar3.Position;
  p.fBandwidth := 3;
  p.fCenter := 170;
  BASS_FXSetParameters(fx[2], @p);


  p.fGain := 15-trackbar4.Position;
  p.fBandwidth := 3;
  p.fCenter := 310;
  BASS_FXSetParameters(fx[3], @p);

  p.fGain := 15-trackbar5.Position;
  p.fBandwidth := 3;
  p.fCenter := 600;
  BASS_FXSetParameters(fx[4], @p);

  p.fGain := 15-trackbar6.Position;
  p.fBandwidth := 3;
  p.fCenter := 1000;
  BASS_FXSetParameters(fx[5], @p);

  p.fGain := 15-trackbar7.Position;
  p.fBandwidth := 3;
  p.fCenter := 3000;
  BASS_FXSetParameters(fx[6], @p);

  p.fGain := 15-trackbar8.Position;
  p.fBandwidth := 3;
  p.fCenter := 6000;
  BASS_FXSetParameters(fx[7], @p);

  p.fGain := 15-trackbar9.Position;
  p.fBandwidth :=3;
  p.fCenter := 10000;
  BASS_FXSetParameters(fx[8], @p);

  p.fGain := 15-trackbar10.Position;
  p.fBandwidth := 3;
  p.fCenter := 12000;
  BASS_FXSetParameters(fx[9], @p);

  p.fGain := 15-trackbar11.Position;
  p.fBandwidth := 3;
  p.fCenter := 14000;
  BASS_FXSetParameters(fx[10], @p);
if not BASS_ChannelPlay(Channel, False) then
            begin ShowMessage('Ошибка воспроизведения файла');exit;end;

scrollbar1.Min:=0; //минимальное значение
    scrollbar1.Max:=bass_ChannelGEtLength(Channel, 0)-1;
Form1.Caption:=ExtractFileName(FileName);

 mode:=play;
end;

procedure TForm1.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  bass_ChannelSetPosition(Channel, scrollbar1.position, 0);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
TrackLen, TrackPos: Double;
ValPos: Double;
ValLen: Double;

begin
if mode<>play then Exit;
if  BASS_ChannelIsActive(channel)=BASS_ACTIVE_STOPPED   then
            begin
            ListBox1.ItemIndex:=ListBox1.ItemIndex+1;

            Filename:=ListBox2.Items.Strings[ListBox1.ItemIndex]+ListBox1.Items.Strings[ListBox1.ItemIndex];
    mode:=stop;
    player;

   end;


scrollbar1.Position:=bass_channelGetPosition(channel,0);


TrackPos:=BASS_ChannelBytes2Seconds(Channel, BASS_ChannelGetPosition(Channel,0));

TrackLen:=BASS_ChannelBytes2Seconds(Channel, BASS_ChannelGetLength(Channel,0));

ValPos:=TrackPos / (24 * 3600);
ValLen:=TrackLen / (24 * 3600);

Label1.Caption:=FormatDateTime('hh:mm:ss',ValPos);
Label2.Caption:=FormatDateTime('hh:mm:ss',ValLen);

BASS_ChannelSetAttribute(Channel,BASS_ATTRIB_VOL, trackBar1.Position/100);

//BASS_ChannelSetAttribute(Channel,BASS_ATTRIB_PAN, Trackbar12.Position/5);

end;

procedure TForm1.FormCreate(Sender: TObject);
 var  n,count:integer;

begin
  if (HIWORD(BASS_GetVersion) <> BASSVERSION)  then
    begin
        MessageBox(0,'Не корректная версия BASS.DLL',nil,MB_ICONERROR);
        Halt;
    end;


    if not BASS_Init(-1, 44100, 0, Handle, nil) then
    begin
      MessageBox(0,'Ошибка инициализация аудио',nil,MB_ICONERROR);
          Halt;
    end;
     trackbar1.Min:=0;
    trackbar1.Max:=100;
    trackbar1.Position:=2;

IniFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config.ini');
  chosenDirectory:=IniFile.ReadString('Form info','Directory',chosenDirectory);
  form1.Left:=IniFile.ReadInteger('Form info','Left',500);
  form1.Top:=IniFile.ReadInteger('Form info','Top',180);
  form1.Width:=IniFile.ReadInteger('Form info','Width',600);
  form1.Height:=IniFile.ReadInteger('Form info','Height',700);

  trackbar1.position:=IniFile.ReadInteger('Volue','trackbar1.position',5);

  trackbar2.position:=IniFile.ReadInteger('EQLayzer','trackbar2.position',15);
  trackbar3.position:=IniFile.ReadInteger('EQLayzer','trackbar3.position',15);
  trackbar4.position:=IniFile.ReadInteger('EQLayzer','trackbar4.position',15);
  trackbar5.position:=IniFile.ReadInteger('EQLayzer','trackbar5.position',15);
  trackbar6.position:=IniFile.ReadInteger('EQLayzer','trackbar6.position',15);
  trackbar7.position:=IniFile.ReadInteger('EQLayzer','trackbar7.position',15);
  trackbar8.position:=IniFile.ReadInteger('EQLayzer','trackbar8.position',15);
  trackbar9.position:=IniFile.ReadInteger('EQLayzer','trackbar9.position',15);
  trackbar10.position:=IniFile.ReadInteger('EQLayzer','trackbar10.position',15);
  trackbar11.position:=IniFile.ReadInteger('EQLayzer','trackbar11.position',15);

  Count:=IniFile.ReadInteger('ItemsCount','Count',0);
//загрузка плейлиста
  if Count<>0 then
  begin
   for n := 0 to Count - 1 do
    ListBox1.Items.Add(IniFile.ReadString('PlayList', 'file' + IntToStr(n+1),'Ошибка чтения'));

    Filename:=ListBox1.Items.Strings[0];
    ListBox1.ItemIndex:=0;
  end;
  if Count<>0 then
  begin
   for n := 0 to Count - 1 do
    ListBox2.Items.Add(IniFile.ReadString('PlayList2', 'file' + IntToStr(n+1),'Ошибка чтения'));


    ListBox2.ItemIndex:=0;
  end;
   DragAcceptFiles(Self.Handle, True);
  //DragAcceptFiles(Form1.ListBox1.Handle, True);
end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of String
  );
 var
   t: Integer;
   description,file1:string;
 begin
   //Listbox1.Items.Add(IntToStr(Length(FileNames)) + ' file(s) dropped on ' + Name + ':');
   for t := 0 to High(FileNames) do
     begin
    description:='';
    file1:=FileNames[t];
    while pos('\',file1)>0 do
    begin

    description:=description+copy(File1,1,pos('\',file1));
    delete(file1,1,pos('\',file1) );
    end;
    Listbox1.Items.Add(File1);
    Listbox2.Items.Add(description);
    end;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  {if Chr(Key) = #32 then
   begin
  Form1.button4Click(Sender);

   Form1.button6Click(Sender);

   end;}
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
var e:integer;
begin
 case key of
   #32: begin
   Form1.button4Click(Sender);


   //Form1.button6Click(Sender);
   end;
 #13 : Form1.Button3Click(Sender);
  end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  { if Chr(Key) = #32 then

  Form1.button4Click(Sender);

   Form1.button6Click(Sender);  }
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox2Click(Sender: TObject);
begin

end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

procedure TForm1.Panel1Paint(Sender: TObject);
begin
   Panel1.Canvas.Pen.Color:=clWhite; //цвет пера
  PAnel1.Canvas.Brush.Color:=clWhite;//цвет кисти
  PAnel1.Canvas.Rectangle(0,0,Panel1.Width,Panel1.Height); //рисуем прямоугольник фон
end;

procedure TForm1.Button1Click(Sender: TObject);

  var j: integer;
begin
 OpenDialog1.Title  := 'Open Files';
 OpenDialog1.Filter := 'mp3|*.mp3';
if listbox1.Count<>0 then i:=ListBox1.ItemIndex else i:=0;

if not OpenDialog1.Execute then exit;
  begin
  for j:=0 to OpenDialog1.Files.Count-1 do
    begin

      ListBox1.Items.Add(OpenDialog1.Files.Strings[j]);
    end;
  end;

   Filename:=ListBox1.Items.Strings[i];

   ListBox1.ItemIndex:=i;

end;

procedure TForm1.ActionList1Execute(AAction: TBasicAction; var Handled: Boolean
  );
begin

end;

procedure TForm1.Action1Execute(Sender: TObject);
begin
   listbox2.items.delete(listbox1.itemindex) ;
 listbox1.items.delete(listbox1.itemindex)  ;
end;

procedure TForm1.Action2Execute(Sender: TObject);
begin
    Form1.button8Click(Sender);
end;

procedure TForm1.Action3Execute(Sender: TObject);
begin
if mode=play then
Form1.button4Click(Sender) else
       Form1.button6Click(Sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

end;

procedure TForm1.Button3Click(Sender: TObject);
var a:integer;
begin
   if (mode=play)and(ListBox1.ItemIndex=a)  then exit ;
    k:=0;
    Filename:=ListBox2.Items.Strings[ListBox1.ItemIndex]+ListBox1.Items.Strings[ListBox1.ItemIndex];
    a:=ListBox1.ItemIndex;

   BASS_ChannelPlay(Channel,false);
mode:=play;
k:=0;
player;
end;

procedure TForm1.Button3KeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if (mode=play)  then
begin
 BASS_ChannelPause(Channel);
 mode:=paused;
end;
end;

procedure TForm1.Button4KeyPress(Sender: TObject; var Key: char);
begin
      if key = #32 then

   Form1.button4Click(Sender);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if mode=play then
begin
 BASS_ChannelStop(Channel);
 BASS_StreamFree(Channel);
 mode:=Stop;
end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if (mode=paused) then
  begin
      BASS_ChannelPlay(Channel,false);
      mode:=play;

  end;
end;

procedure TForm1.Button6KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TForm1.Button6KeyPress(Sender: TObject; var Key: char);
begin
  if key = #32 then

   Form1.button4Click(Sender);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  listBox1.Items.Clear();
   listBox2.Items.Clear();
end;

procedure TForm1.Button8Click(Sender: TObject);

var
  tsr : tsearchrec;

begin
   if SelectDirectory('Выберите каталог', '', chosenDirectory)  then
  begin
  if FindFirst(chosenDirectory+'\'+'*.mp3',faAnyFile,tsr) = 0 then
    repeat
      begin
      ListBox1.Items.Add(tsr.name);
      ListBox2.Items.Add(chosenDirectory+'\');
      end;

    until FindNext(tsr) <> 0;
  FindClose(tsr);

   end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);

begin

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var n:integer;
begin
  Bass_Stop();
    BASS_StreamFree(channel);
    Bass_Free;
  //сохраняем настройки в inifile
  //форма
    IniFile.WriteString('Form info','Directory',chosenDirectory);
    IniFile.WriteInteger('Form info','Left',Left);
    IniFile.WriteInteger('Form info','Top',Top);
    IniFile.WriteInteger('Form info','Width',Width);
    IniFile.WriteInteger('Form info','Height',Height);
  //громкость звука
    IniFile.WriteInteger('Volue','trackbar1.position',trackbar1.position);
  //эквалайзер
    IniFile.WriteInteger('EQLayzer','trackbar3.position',trackbar2.position);
    IniFile.WriteInteger('EQLayzer','trackbar4.position',trackbar3.position);
    IniFile.WriteInteger('EQLayzer','trackbar5.position',trackbar4.position);
    IniFile.WriteInteger('EQLayzer','trackbar6.position',trackbar5.position);
    IniFile.WriteInteger('EQLayzer','trackbar7.position',trackbar6.position);
    IniFile.WriteInteger('EQLayzer','trackbar8.position',trackbar7.position);
    IniFile.WriteInteger('EQLayzer','trackbar9.position',trackbar8.position);
    IniFile.WriteInteger('EQLayzer','trackbar10.position',trackbar9.position);
    IniFile.WriteInteger('EQLayzer','trackbar11.position',trackbar10.position);
    IniFile.WriteInteger('EQLayzer','trackbar12.position',trackbar11.position);
  //количество файлов в PlayList
    IniFile.WriteInteger('ItemsCount','Count',ListBox1.Items.Count);
  //очистка секции PlayList
    IniFile.EraseSection('PlayList');
  //выгрузка из PlayList
    for n := 0 to ListBox1.Items.Count - 1 do
    IniFile.WriteString('PlayList', 'file' + IntToStr(n+1), ListBox1.Items.Strings[n]);
    for n := 0 to ListBox1.Items.Count - 1 do
    IniFile.WriteString('PlayList2', 'file' + IntToStr(n+1), ListBox2.Items.Strings[n]);
  //Время создания PlayList
    IniFile.WriteTime('Time','Write time',Time);
  //Освобождаем объекты перед закрытием
    IniFile.Free;

    DragAcceptFiles(Form1.Handle, False);
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[1], @p);
p.fgain := 15-TrackBar3.position;
BASS_FXSetParameters(fx[1], @p);
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[2], @p);
p.fgain := 15-TrackBar4.position;
BASS_FXSetParameters(fx[2], @p);
end;

procedure TForm1.TrackBar4Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[3], @p);
p.fgain := 15-TrackBar5.position;
BASS_FXSetParameters(fx[3], @p);
end;

procedure TForm1.TrackBar5Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[4], @p);
p.fgain := 15-TrackBar6.position;
BASS_FXSetParameters(fx[4], @p);
end;

procedure TForm1.TrackBar6Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[5], @p);
p.fgain := 15-TrackBar7.position;
BASS_FXSetParameters(fx[5], @p);
end;

procedure TForm1.TrackBar7Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[6], @p);
p.fgain := 15-TrackBar8.position;
BASS_FXSetParameters(fx[6], @p);
end;

procedure TForm1.TrackBar8Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[7], @p);
p.fgain := 15-TrackBar9.position;
BASS_FXSetParameters(fx[7], @p);
end;

procedure TForm1.TrackBar9Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[8], @p);
p.fgain := 15-TrackBar10.position;
BASS_FXSetParameters(fx[8], @p);
end;

procedure TForm1.TrackBar10Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[9], @p);
p.fgain := 15-TrackBar11.position;
BASS_FXSetParameters(fx[9], @p);
end;

procedure TForm1.TrackBar11Change(Sender: TObject);
begin
BASS_FXGetParameters(fx[10], @p);
p.fgain := 15-TrackBar11.position;
BASS_FXSetParameters(fx[10], @p);
end;

end.

