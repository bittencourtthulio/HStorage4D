                                  unit HS4D;

interface

uses
  HS4D.Interfaces;

type
  THS4D = class(TInterfacedObject, iHS4D)
    private
      FCredencial : iHS4DCredential;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iHS4D;
      function Credential : iHS4DCredential;
      function SendFile : iHS4DSend;
      function GetFile : iHS4DGet;
  end;

implementation

uses
  HS4D.Send,
  HS4D.Get,
  HS4D.Credential;

{ THS4D }

constructor THS4D.Create;
begin

end;

function THS4D.Credential: iHS4DCredential;
begin
  if not Assigned(FCredencial) then
    FCredencial := THS4DCredential.New(Self);

  Result := FCredencial;
end;

destructor THS4D.Destroy;
begin

  inherited;
end;

function THS4D.GetFile: iHS4DGet;
begin
  Result:= THSD4Get.new(Self);
end;

class function THS4D.New: iHS4D;
begin
  Result:= self.Create;
end;

function THS4D.SendFile: iHS4DSend;
begin
  Result:= THS4DSend.new(Self);
end;

end.