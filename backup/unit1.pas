unit Unit1;

{$mode objfpc}{$H+}

interface

uses
 windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
 StdCtrls, Bass;

type

  { TForm1 }
  TPlayerMode = (Stop, Play, Paused);
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Edit1: TEdit;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Player;
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
Mode: TPlayerMode;//PlayMode


implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.Player;
begin
//проверяем, если не пауза
if mode<>paused then begin
//то проверяем существует ли файл загружаемый из PlayList
//если файл не существует, то выходим
if not FileExists(FileName) then begin ShowMessage('Файл не существует');exit;end;
//останавливаем и освобождаем канал воспроизведения
BASS_ChannelStop(Channel);BASS_StreamFree(Channel);
//пытаемся загрузить файл и получить дескриптор канала
Channel := BASS_StreamCreateFile(FALSE, PChar(filename), 0, 0, 0 );

if Channel=0 then begin ShowMessage('Ошибка загрузки Файла');exit;end;
end;

//командой BASS_ChannelPlay(Channel, False) пытаемся воспроизвести файл,
//если это невозможно, то выдаем сообщение об ошибке
if not BASS_ChannelPlay(Channel, False) then
            begin ShowMessage('Ошибка воспроизведения файла');exit;end;

//присваеваем заголовку формы имя проигрываемого файла
Form1.Caption:=ExtractFileName(FileName);
 //Устанавливаем PlayMode - play
 mode:=play;
end;
procedure TForm1.FormCreate(Sender: TObject);
begin
  if (HIWORD(BASS_GetVersion) <> BASSVERSION)  then
    begin
        MessageBox(0,'Не корректная версия BASS.DLL',nil,MB_ICONERROR);
        Halt;
    end;

    // Инициализация аудио - по умолчанию, 44100hz, stereo, 16 bits
    if not BASS_Init(-1, 44100, 0, Handle, nil) then
    begin
      MessageBox(0,'Ошибка инициализация аудио',nil,MB_ICONERROR);
          Halt;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);

  var j: integer;
begin
 OpenDialog1.Title  := 'Open Files';
 OpenDialog1.Filter := 'mp3|*.mp3'; //фильтр для файлов
//проверяем если PlayList не пустой то запоминаем номер текущей песни
//иначе устанавливаем номер песни 0 (первая позиция в PlayList)
if listbox1.Count<>0 then i:=ListBox1.ItemIndex else i:=0;
//Диалог открытия файла
if not OpenDialog1.Execute then exit;
  begin
  for j:=0 to OpenDialog1.Files.Count-1 do
    begin
    //заполняем PlayList
      ListBox1.Items.Add(OpenDialog1.Files.Strings[j]);
    end;
  end;
  //запоминаем имя файла текущей песни в плейлисте
   Filename:=ListBox1.Items.Strings[i];
  //Выделяем эту песню в PlayList
   ListBox1.ItemIndex:=i;
   Edit1.Text:=filename;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  close();
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   if mode=play then exit ;
//Запускаем процедуру проигрывания
mode:=play;
player;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if mode=play then
begin
 BASS_ChannelPause(Channel);//останавливаем воспроизведение - пауза
 mode:=paused;//устанавливаем playmode -> пауза
end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if mode=play then
begin
 BASS_ChannelStop(Channel);//останавливаем воспроизведение - стоп
 mode:=Stop;//устанавливаем playmode -> стоп
end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  BASS_ChannelStop(Channel);BASS_StreamFree(Channel);
   mode:=play;
 Channel := BASS_StreamCreateFile(false,PChar('F:\Lazarus\Плеер\Music1.mp3'), 0, 0, 0 );
  BASS_ChannelPlay(Channel, False);
end;


end.

